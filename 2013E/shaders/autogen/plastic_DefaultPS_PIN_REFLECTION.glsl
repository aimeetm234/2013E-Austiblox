uniform sampler2D StudsMap;
uniform float Reflectance;
uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform samplerCube EnvironmentMap;
uniform vec3 AmbientColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[2];
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[4];
  vec4 oColor0_3;
  vec4 albedo_4;
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec4 tmpvar_6;
  tmpvar_6.xyz = mix (gl_Color.xyz, tmpvar_5.xyz, tmpvar_5.www);
  tmpvar_6.w = gl_Color.w;
  albedo_4.w = tmpvar_6.w;
  vec3 tmpvar_7;
  tmpvar_7 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_8;
  tmpvar_8 = abs((tmpvar_7 - 0.5));
  vec4 tmpvar_9;
  tmpvar_9 = mix (LightBorder, texture3D (LightMap, (tmpvar_7 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_8.x, max (tmpvar_8.y, tmpvar_8.z))))));
  vec3 i_10;
  i_10 = -(gl_TexCoord[3].xyz);
  albedo_4.xyz = mix (tmpvar_6.xyz, textureCube (EnvironmentMap, (i_10 - (2.0 * (dot (tmpvar_2.xyz, i_10) * tmpvar_2.xyz)))).xyz, vec3((Reflectance * 0.8)));
  oColor0_3.xyz = ((((AmbientColor + (gl_SecondaryColor.xyz * tmpvar_9.w)) + tmpvar_9.xyz) * albedo_4.xyz) + (Lamp0Color * (gl_SecondaryColor.w * tmpvar_9.w)));
  oColor0_3.w = albedo_4.w;
  oColor0_3.xyz = mix (FogColor, oColor0_3.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_3;
}

