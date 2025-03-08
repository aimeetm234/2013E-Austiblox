uniform sampler2D StudsMap;
uniform float Reflectance;
uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp0Dir;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform samplerCube EnvironmentMap;
uniform vec3 AmbientColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[2];
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[3];
  vec4 tmpvar_3;
  tmpvar_3 = gl_TexCoord[4];
  vec4 oColor0_4;
  vec4 albedo_5;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(tmpvar_3.xyz);
  vec4 tmpvar_7;
  tmpvar_7 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec4 tmpvar_8;
  tmpvar_8.xyz = mix (gl_Color.xyz, tmpvar_7.xyz, tmpvar_7.www);
  tmpvar_8.w = gl_Color.w;
  albedo_5.w = tmpvar_8.w;
  vec3 tmpvar_9;
  tmpvar_9 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_10;
  tmpvar_10 = abs((tmpvar_9 - 0.5));
  vec4 tmpvar_11;
  tmpvar_11 = mix (LightBorder, texture3D (LightMap, (tmpvar_9 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_10.x, max (tmpvar_10.y, tmpvar_10.z))))));
  vec3 i_12;
  i_12 = -(tmpvar_2.xyz);
  albedo_5.xyz = mix (tmpvar_8.xyz, textureCube (EnvironmentMap, (i_12 - (2.0 * (dot (tmpvar_6, i_12) * tmpvar_6)))).xyz, vec3((Reflectance * 0.8)));
  oColor0_4.xyz = ((((AmbientColor + (gl_SecondaryColor.xyz * tmpvar_11.w)) + tmpvar_11.xyz) * albedo_5.xyz) + (Lamp0Color * ((tmpvar_11.w * gl_SecondaryColor.w) * pow (clamp (dot (tmpvar_6, normalize((-(Lamp0Dir) + normalize(tmpvar_2.xyz)))), 0.0, 1.0), tmpvar_3.w))));
  oColor0_4.w = albedo_5.w;
  oColor0_4.xyz = mix (FogColor, oColor0_4.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_4;
}

