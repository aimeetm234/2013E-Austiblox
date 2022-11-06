#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(VertexOutput IN)
{
	const float3 NoiseScale = float3(0.02083, 0.0693, 0.2083) * 3;
	const float spread = 0.3;
	const float rust_threshold = 0.8;
	const float NormalRatio = 0.15;

	float3 normal = tex2D(NormalMap, IN.Uv*0.15).xyz - 0.5;

	float3 shiftPos = IN.SurfaceCoord.xyz;
	
	float3 ns =NoiseScale;
    float noiseval = tex3D(NoiseMap,shiftPos.xyz*ns.x).x * 0.5;
	float noiseval2 = tex3D(NoiseMap,shiftPos.zyx*ns.y).x * 0.3;
	float noiseval3 = tex3D(NoiseMap,shiftPos.zyx*ns.z).x * 0.2;
	noiseval += noiseval2+noiseval3;

    float3 metalColor = IN.Color.rgb*1.3;
	float3 rustColor = tex2D(DiffuseMap, float2(0,1-noiseval)).xyz;
	
	float tNormSum = 0.65+dot(normal, 0.35);

	//Interpolate values between rust and metal    
	float interp = (noiseval - rust_threshold + spread)/2/spread+0.5;
	interp = saturate(interp);

	float3 dColor = lerp(rustColor, metalColor, interp);
	float3 dColor2 = dColor * tNormSum;
	dColor = lerp(dColor, dColor2, interp);

	normal.xy *= (1 - interp);

    Surface surface = (Surface)0;
    surface.albedo = dColor;
    surface.normal = normal;
    surface.specularIntensity = lerp(0.12, 0.6, interp * (1 - saturate(IN.Tangent_Fade.w)));

	return surface;
}