attribute vec4 colour;
attribute vec2 uv1;
attribute vec2 uv0;
attribute vec3 normal;
attribute vec4 vertex;
uniform mat4 WorldMatrix;
uniform mat4 ViewProjection;
uniform vec3 Lamp1Dir;
uniform vec3 Lamp1Color;
uniform vec3 Lamp0Dir;
uniform vec3 Lamp0Color;
uniform vec3 CameraPosition;
uniform vec3 AmbientColor;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = (WorldMatrix * vertex).xyz;
  float tmpvar_2;
  tmpvar_2 = dot (normal, -(Lamp0Dir));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.00000;
  tmpvar_3.xyz = tmpvar_1;
  vec4 tmpvar_4;
  tmpvar_4 = (ViewProjection * tmpvar_3);
  vec4 tmpvar_5;
  tmpvar_5.xyz = ((AmbientColor + ((max (0.000000, tmpvar_2) * Lamp0Color) + (max (dot (normal, -(Lamp1Dir)), 0.000000) * Lamp1Color))) * colour.xyz);
  tmpvar_5.w = colour.w;
  vec4 tmpvar_6;
  tmpvar_6.w = 0.000000;
  tmpvar_6.xyz = ((pow ((max (0.000000, dot (normalize ((-(Lamp0Dir) + normalize ((CameraPosition - tmpvar_1)))), normal)) * step (0.000000, tmpvar_2)), 50.0000) * Lamp0Color) * 0.900000);
  gl_Position = tmpvar_4;
  vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.000000, 1.00000);
  tmpvar_7.xy = uv0;
  gl_TexCoord[0] = tmpvar_7;
  vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.000000, 1.00000);
  tmpvar_8.xy = uv1;
  gl_TexCoord[1] = tmpvar_8;
  gl_FrontColor = tmpvar_5;
  gl_FrontSecondaryColor = tmpvar_6;
  gl_FogFragCoord = tmpvar_4.w;
}

