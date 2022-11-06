#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	const float WoodContrast = 0.1;
	const float RingScale = 4;
	const float AmpScale = 1;
	const float LightRingEnd = 0.4;
	const float DarkRingStart = 0.8;
	const float DarkRingEnd = 0.83;
	const float NormMapScale = 0.6;
	const float NoiseScale = 64;
	const float MixedColorRatio = 0.315;
	const float AAFreqMultiplier = 12;
	const float Ks1 = 0.32;
	const float Ks2 = 0.16;

	float3 WoodPos = IN.SurfaceCoord.xyz;

	float3 tNorm = tex2D(NormalMap, WoodPos.xy * NormMapScale).xyz - 0.5;

    float3 noiseval = tex3D(NoiseMap,WoodPos.xyz/NoiseScale).xyz;

	float signalfreq = length(float4(ddx(WoodPos.yz), ddy(WoodPos.yz)));
	float aa_attn = saturate(signalfreq*AAFreqMultiplier - 1.0f);
    float3 Pwood = WoodPos + (AmpScale * noiseval);
    float r = RingScale * length(Pwood.yz);
    r = r + tex3D(NoiseMap,r.xxx/32.0).x;
    r = r - floor(r);
    r = smoothstep(LightRingEnd, DarkRingStart, r) - smoothstep(DarkRingEnd,1.0,r);
	// apply anti-aliasing
	r = lerp(r, MixedColorRatio, aa_attn);
	
    float3 dColor = IN.Color.rgb + WoodContrast * (MixedColorRatio - r);

    tNorm.xy *= saturate(1.05 - abs(IN.SurfaceCoord.w));

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = tNorm;
    surface.specularIntensity = lerp(lerp(Ks1, Ks2, r), 0.2696, saturate(IN.Tangent_Fade.w));

	return surface;
}
