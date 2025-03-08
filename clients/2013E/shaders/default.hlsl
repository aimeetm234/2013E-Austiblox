#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;
    float3 Normal	    : NORMAL;
    float2 Uv	        : TEXCOORD0;
    float2 UvStuds	    : TEXCOORD1;

#ifdef PIN_SKINNED
    float4 ColorDiffuse  : COLOR0;
    int4   ColorSpecular : COLOR1;
#else
    float4 ColorDiffuse  : COLOR0;
    float4 ColorSpecular : COLOR1;
#endif
};

struct VertexOutput
{
    float4 HPosition    : POSITION;
    float2 Uv           : TEXCOORD0;
	float2 UvStuds		: TEXCOORD1;
    float4 Diffuse      : COLOR0;
    float4 Specular     : COLOR1;
  
#ifdef PIN_HQ
    float4 View_Depth   : TEXCOORD2;
    float4 Normal_Spec  : TEXCOORD3;
#endif
};

uniform float3 CameraPosition;
uniform float4x4 ViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp1Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;
uniform float3 AmbientColor;

#ifdef PIN_SKINNED
uniform float4 WorldMatrixArray[72 * 3];
#else
uniform float4x4 WorldMatrix;
#endif

#ifdef PIN_DEBUG
uniform float4 DebugColor;
#endif

VertexOutput DefaultVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

#ifdef PIN_SKINNED
    int boneIndex = IN.ColorSpecular.r;

    float4 worldRow0 = WorldMatrixArray[boneIndex * 3 + 0];
    float4 worldRow1 = WorldMatrixArray[boneIndex * 3 + 1];
    float4 worldRow2 = WorldMatrixArray[boneIndex * 3 + 2];
		
	float3 posWorld = float3(dot(worldRow0, IN.Position), dot(worldRow1, IN.Position), dot(worldRow2, IN.Position));
    float3 normalWorld = float3(dot(worldRow0.xyz, IN.Normal), dot(worldRow1.xyz, IN.Normal), dot(worldRow2.xyz, IN.Normal));
#else
    // world matrix does not contain rotation/scale for static geometry so we can avoid transforming normal
	float3 posWorld = mul(WorldMatrix, IN.Position).xyz;
    float3 normalWorld = IN.Normal;
#endif

#if defined(PIN_DEBUG)
    float4 colorDiffuse = DebugColor;
    float specularIntensity = 0;
    float specularPower = 50.0;
#elif defined(PIN_SKINNED)
    float4 colorDiffuse = IN.ColorDiffuse / 255.f;
    float specularIntensity = IN.ColorSpecular.g / 255.f;
    float specularPower = IN.ColorSpecular.a;
#else
    float4 colorDiffuse = IN.ColorDiffuse;
    float specularIntensity = IN.ColorSpecular.g;
    float specularPower = IN.ColorSpecular.a * 255.f;
#endif

#ifdef GLSL
    // Due to some issues with FFP implementation of OpenGL & secondary specular, we disable specular stream everywhere
    specularIntensity = 0.9f;
    specularPower = 50.f;
#endif

    float3 view = CameraPosition - posWorld.xyz;

    float3 ambient = AmbientColor;

#ifdef PIN_HQ
	float3 diffuse = max(dot(normalWorld, -Lamp0Dir), 0) * Lamp0Color + max(dot(normalWorld, -Lamp1Dir), 0) * Lamp1Color;
    float3 specular = (dot(normalWorld, -Lamp0Dir) > 0) * Lamp0Color;
#else
    // Note: we use a fixed specular power so that vertex processing matches the fixed function vertex processing for static parts
    float4 lit0 = lit(dot(normalWorld, -Lamp0Dir), dot(normalize(-Lamp0Dir + normalize(view)), normalWorld), /* specularPower */ 50.0);

	float3 diffuse = lit0.y * Lamp0Color + max(dot(normalWorld, -Lamp1Dir), 0) * Lamp1Color;
    float3 specular = lit0.z * Lamp0Color;
#endif

	OUT.HPosition = mul(ViewProjection, float4(posWorld, 1));
	OUT.Uv = IN.Uv;
	OUT.UvStuds = IN.UvStuds;

    OUT.Diffuse = float4((ambient + diffuse) * colorDiffuse.rgb, colorDiffuse.a);
    OUT.Specular = float4(specular * specularIntensity, 0);

#ifdef PIN_HQ
    OUT.View_Depth = float4(view, OUT.HPosition.w);
    OUT.Normal_Spec = float4(normalWorld, specularPower);
#endif

	return OUT;
}

sampler2D DiffuseMap: register(s0);
sampler2D StudsMap: register(s1);

void DefaultPS(VertexOutput IN,
#ifdef PIN_GBUFFER
    out float4 oColor1: COLOR1,
#endif
    out float4 oColor0: COLOR0)
{
#ifdef PIN_MATERIALS
	float4 studs = tex2D(StudsMap, IN.UvStuds);
    float4 material = tex2D(DiffuseMap, IN.Uv);

	float4 diffuse = float4(lerp(material.rgb + IN.Diffuse.rgb - 0.5, studs.rgb, studs.a), IN.Diffuse.a);
#else
    float4 diffuse = tex2D(DiffuseMap, IN.Uv) * IN.Diffuse;
#endif
        
#ifdef PIN_HQ
    float4 specular = IN.Specular * (half)pow(saturate(dot(normalize(IN.Normal_Spec.xyz), normalize(-Lamp0Dir + normalize(IN.View_Depth.xyz)))), IN.Normal_Spec.w);
#else
    float4 specular = IN.Specular;
#endif

    oColor0 = diffuse + specular;

#ifdef PIN_GBUFFER
    oColor1 = gbufferPack(IN.View_Depth.w, diffuse.rgb, specular.rgb);
#endif
}
