#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	const float NoiseScale = 7;

	float3 normal = tex2D(NormalMap, IN.Uv * 0.1).xyz - 0.5;

	float3 shiftPos = IN.SurfaceCoord.xyz;

    float3 noiseval = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.04).xyz;
	float3 noiseval2 = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.3).xyz + 0.2;
	noiseval *= noiseval2;

	float3 dColor = IN.Color.xyz + (noiseval*0.4 - 0.08);

	float tNormSum = 0.9+dot(0.4, normal);
	dColor *= tNormSum;

	normal.z = 2;

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = normal;
    surface.specularIntensity = 0.1;

	return surface;
}	
	