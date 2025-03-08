#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	float4 material = tex2D(DiffuseMap, IN.Uv * 0.18);

    Surface surface = (Surface)0;
    surface.albedo = IN.Color.rgb + material.rgb - 0.5;
    surface.normal = float3(0, 0, 1);
    surface.specularIntensity = 0.19;

	return surface;
}