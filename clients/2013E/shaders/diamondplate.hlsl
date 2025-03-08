#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	float3 normal = 2 * tex2D(NormalMap, IN.Uv * 1.2).xyz - 1;

	normal.xy *= 0.3;

    Surface surface = (Surface)0;
    surface.albedo = IN.Color.rgb;
    surface.normal = normal;
    surface.specularIntensity = 0.9;

	return surface;
}