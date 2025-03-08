#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	const float NoiseScale = 7.f / 3.f;

	float2 NormalUV = IN.Uv * 0.01;
	float3 shiftPos = IN.SurfaceCoord.xyz;

	// low frequency
    float3 noiseval = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.1).xyz;
	float3 noiseval2 = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.5).xyz * 0.7 + 0.5;
	noiseval *= noiseval2;

	float3 dColor = IN.Color.xyz + (noiseval*0.35 - 0.15);
	
	float3 tNorm = tex2D(NormalMap,NormalUV).xyz - float3(0.5,0.5,0.5);
	float tNormSum = 0.85+0.15*dot(tNorm, 1);
	dColor *= tNormSum;

	tNorm.xy *= 0.15;

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = tNorm;
    surface.specularIntensity = 0.4;
    surface.reflectionIntensity = 0.275;

	return surface;
}
