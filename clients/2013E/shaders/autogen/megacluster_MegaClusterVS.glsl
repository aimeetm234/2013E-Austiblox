attribute vec2 uv1;
attribute vec2 uv0;
attribute vec3 normal;
attribute vec4 vertex;
uniform mat4 WorldMatrix;
uniform mat4 ViewProjection;
uniform vec4 LightConfig1;
uniform vec4 LightConfig0;
uniform vec3 Lamp1Color;
uniform vec3 Lamp0Dir;
uniform vec3 Lamp0Color;
uniform vec4 FogParams;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = (WorldMatrix * vertex).xyz;
  float tmpvar_2;
  tmpvar_2 = dot (normal, -(Lamp0Dir));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1;
  vec4 tmpvar_4;
  tmpvar_4 = (ViewProjection * tmpvar_3);
  vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = ((clamp (tmpvar_2, 0.0, 1.0) * Lamp0Color) + (max (-(tmpvar_2), 0.0) * Lamp1Color));
  vec4 tmpvar_6;
  tmpvar_6.xyz = (((tmpvar_1 + (normal * 6.0)).xzy * LightConfig0.xyz) + LightConfig1.xyz);
  tmpvar_6.w = ((FogParams.z - tmpvar_4.w) * FogParams.w);
  vec4 tmpvar_7;
  tmpvar_7.xyz = tmpvar_1;
  tmpvar_7.w = tmpvar_4.w;
  gl_Position = tmpvar_4;
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.xy = uv0;
  gl_TexCoord[0] = tmpvar_8;
  vec4 tmpvar_9;
  tmpvar_9.zw = vec2(0.0, 1.0);
  tmpvar_9.xy = uv1;
  gl_TexCoord[1] = tmpvar_9;
  gl_FrontColor = tmpvar_5;
  gl_TexCoord[2] = tmpvar_6;
  gl_TexCoord[3] = tmpvar_7;
  gl_FogFragCoord = tmpvar_4.w;
}

