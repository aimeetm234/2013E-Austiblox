#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	float2 NormalUV = IN.Uv * 0.2;
	float2 NormalUV2 = NormalUV * 0.4;
	float2 NormalUV3 = NormalUV2 * 0.1;

	float3 dColor = IN.Color.xyz;
	
	float3 tNorm = tex2D(NormalMap,NormalUV).xyz;
	float3 tNorm2 = tex2D(NormalMap, NormalUV2).xyz;
	tNorm = lerp(tNorm, tNorm2, 0.5);
	tNorm2 = tex2D(NormalMap, NormalUV3).xyz;
	tNorm = lerp(tNorm, tNorm2, 0.3);
	tNorm -= 0.5;
	
	float tNormSum = 0.4+dot(tNorm, 0.6);
	dColor *= tNormSum;

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = tNorm;
    surface.specularIntensity = 0.9;
    surface.reflectionIntensity = 0.35;

	return surface;
}

