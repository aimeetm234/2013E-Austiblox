#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	const float3 NoiseScale = float3(0.09, 0.02, 0.004) * 3;

	float spread = 0.3;
	float grass_threshold = 0.95;
	float NormalRatio = 0.15;
	float2 NormalUV = IN.Uv * 0.1;
	
	float3 shiftPos = IN.SurfaceCoord.xyz;
	float3 ns = NoiseScale;
    float noiseval2 = tex3D(NoiseMap,shiftPos.xyz*ns.x).x * 0.4;
	float noiseval = tex3D(NoiseMap,shiftPos.zyx*ns.y).x * 0.6;
	noiseval -= noiseval2;
	float noiseval3 = tex3D(NoiseMap,shiftPos.xyz*ns.z).x * 0.3;
	noiseval += noiseval3;

	float interp = (noiseval - grass_threshold + spread)/2/spread+0.5;
	interp = clamp(interp,0,1);
	
    float3 grassColor = tex2D(DiffuseMap, NormalUV).xyz;
	float3 dirt = tex2D(NormalMap,NormalUV).xyz ;
	
	float3 dColor;

	dColor = lerp(grassColor+IN.Color.xyz-float3(0.31,0.43,0.146), dirt, interp);
    dColor = saturate(dColor);	

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = float3(0, 0, 1);
    surface.specularIntensity = 0.1;

	return surface;
}