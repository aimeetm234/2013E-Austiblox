#define GBUFFER_MAX_DEPTH 500.0f 

float4 gbufferPack(float depth, float3 diffuse, float3 specular)
{
	depth = saturate(depth / GBUFFER_MAX_DEPTH);
	
	const float3 bitSh	= float3(255*255, 255, 1);
    const float3 lumVec = float3(0.299, 0.587, 0.114);

	float2 comp;
	comp = depth*float2(255,255*256);
	comp = frac(comp);
	comp = float2(depth,comp.x*256/255) - float2(comp.x, comp.y)/255;
	
	float4 result;
	
	result.r = dot(specular, lumVec);
	result.g = dot(diffuse, lumVec);
	result.ba = comp.yx;
	
	return result;
}
