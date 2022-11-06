#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;
    float3 Normal	    : NORMAL;
    float2 UvHigh		: TEXCOORD0;
    float2 UvLow	    : TEXCOORD1;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;

    float2 UvHigh		: TEXCOORD0;
    float2 UvLow	    : TEXCOORD1;

    float4 Diffuse_Specular	: COLOR0;

    float4 LightPosition_Fog : TEXCOORD2;
    float4 Position_Depth    : TEXCOORD3;
};

uniform float3 CameraPosition;
uniform float4x4 ViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;
uniform float3 AmbientColor;

uniform float WaterTimeframe;
uniform float WaterSintime;

uniform float3 FogColor;
uniform float4 FogParams;

uniform float4 LightConfig0;
uniform float4 LightConfig1;
uniform float4 LightBorder;

uniform float4x4 WorldMatrix;

VertexOutput MegaClusterVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    // Transform position and normal to world space
    // Note: world matrix does not contain rotation/scale for static geometry so we can avoid transforming normal
	float3 posWorld = mul(WorldMatrix, IN.Position).xyz;

    // Water encodes normal speed in normal length
#ifdef PIN_WATER
    float3 normalWorld = normalize(IN.Normal);
#else
    float3 normalWorld = IN.Normal;
#endif

    float ndotl = dot(normalWorld, -Lamp0Dir);

	OUT.HPosition = mul(ViewProjection, float4(posWorld, 1));

    float3 diffuse = saturate(ndotl) * Lamp0Color + max(-ndotl, 0) * Lamp1Color;

#ifdef PIN_WATER
    float specularIntensity = 0.4f;
    float specularPower = 25.f;

    // Using lit here improves performance on software vertex shader implementations
    float2 lt = lit(ndotl, dot(normalize(-Lamp0Dir + normalize(CameraPosition - posWorld.xyz)), normalWorld), specularPower).yz;

    OUT.Diffuse_Specular = float4(diffuse, specularIntensity * lt.y);
#else
    OUT.Diffuse_Specular = float4(diffuse, 0);
#endif

    OUT.LightPosition_Fog = float4(lgridPrepareSample(posWorld, normalWorld, LightConfig0, LightConfig1), (FogParams.z - OUT.HPosition.w) * FogParams.w);
    OUT.Position_Depth = float4(posWorld, OUT.HPosition.w);

#ifdef PIN_WATER
    float normalLength = abs(dot(IN.Normal, 1));
    float speed = floor(normalLength);
    float hasNonZeroFlow = min(1, speed);
    float hasZeroFlow = 1 - hasNonZeroFlow;
    
    // encode: speed == 0 ? sintime : timeframe * speed
    float textureOffset = (hasNonZeroFlow * WaterTimeframe * speed) + hasZeroFlow * 0.125 * WaterSintime;

    // encode: speed == 0 ? (x + offset, y) : (x, y + offset)
    float2 subsurfaceCoord = IN.UvHigh - float2(hasZeroFlow, hasNonZeroFlow) * 3 * textureOffset;

    OUT.UvHigh = subsurfaceCoord;
    OUT.UvLow = float2(IN.UvHigh.x, IN.UvHigh.y - 4 * textureOffset);
#else
    OUT.UvHigh = IN.UvHigh;
    OUT.UvLow = IN.UvLow;
#endif

	return OUT;
}

sampler2D DiffuseHighMap: register(s0);
sampler2D DiffuseLowMap: register(s1);
sampler3D LightMap: register(s2);

void MegaClusterPS(VertexOutput IN,
#ifdef PIN_GBUFFER
    out float4 oColor1: COLOR1,
#endif
    out float4 oColor0: COLOR0)
{
    // Compute albedo term
#ifdef PIN_WATER
    float4 wave = tex2D(DiffuseHighMap, IN.UvHigh);
    float4 ss0 = tex2D(DiffuseLowMap, IN.UvLow);
	float4 ss1 = tex2D(DiffuseLowMap, IN.UvHigh);

    float3 albedo = lerp(ss1.rgb, lerp(ss0.rgb, wave.rgb, wave.a), ss1.a);
#else
    float4 high = tex2D(DiffuseHighMap, IN.UvHigh);
    float4 low = tex2D(DiffuseLowMap, IN.UvLow);

    float3 albedo = lerp(low.rgb, high.rgb, high.a);
#endif

    float4 light = lgridSample(LightMap, IN.LightPosition_Fog.xyz, LightConfig0, LightConfig1, LightBorder);

    // For some reason, terrain ambient was multiplied by 0.5
#ifdef PIN_WATER
    float ambientFactor = 1;
#else
    float ambientFactor = 0.5;
#endif

    // Compute diffuse term
    float3 diffuse = (AmbientColor * ambientFactor + IN.Diffuse_Specular.rgb * light.a + light.rgb) * albedo.rgb;

    // Compute specular term
#ifdef PIN_WATER
    float3 specular = Lamp0Color * (IN.Diffuse_Specular.a * light.a);
#else
    float3 specular = 0;
#endif

    // Combine
    oColor0.rgb = diffuse + specular;
    oColor0.a = 1;

    float fogAlpha = saturate(IN.LightPosition_Fog.w);

#ifdef GLSL
    // Manually apply fog in GLSL path
    oColor0.rgb = lerp(FogColor, oColor0.rgb, fogAlpha);
#endif

#ifdef PIN_GBUFFER
    oColor1 = gbufferPack(IN.Position_Depth.w, diffuse.rgb, specular.rgb, fogAlpha);
#endif
}
