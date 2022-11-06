uniform sampler2D StudsMap;
uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp1Color;
uniform vec3 Lamp0Dir;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform sampler2D DiffuseMap;
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
  vec3 tmpvar_6;
  tmpvar_6 = mix (mix (((gl_Color.xyz + texture2D (DiffuseMap, (gl_TexCoord[0].xy * 0.18)).xyz) - 0.5), gl_Color.xyz, vec3(clamp (gl_TexCoord[6].w, 0.0, 1.0))), tmpvar_5.xyz, tmpvar_5.www);
  vec4 tmpvar_7;
  tmpvar_7.xyz = tmpvar_6;
  tmpvar_7.w = gl_Color.w;
  albedo_4.w = tmpvar_7.w;
  vec3 tmpvar_8;
  tmpvar_8 = normalize(tmpvar_2.xyz);
  float tmpvar_9;
  tmpvar_9 = dot (tmpvar_8, -(Lamp0Dir));
  vec4 tmpvar_10;
  tmpvar_10.xyz = ((clamp (tmpvar_9, 0.0, 1.0) * Lamp0Color) + (max (-(tmpvar_9), 0.0) * Lamp1Color));
  tmpvar_10.w = (float((tmpvar_9 >= 0.0)) * 0.19);
  vec3 tmpvar_11;
  tmpvar_11 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_12;
  tmpvar_12 = abs((tmpvar_11 - 0.5));
  vec4 tmpvar_13;
  tmpvar_13 = mix (LightBorder, texture3D (LightMap, (tmpvar_11 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_12.x, max (tmpvar_12.y, tmpvar_12.z))))));
  albedo_4.xyz = tmpvar_6;
  oColor0_3.xyz = ((((AmbientColor + (tmpvar_10.xyz * tmpvar_13.w)) + tmpvar_13.xyz) * tmpvar_6) + (Lamp0Color * ((tmpvar_13.w * tmpvar_10.w) * pow (clamp (dot (tmpvar_8, normalize((-(Lamp0Dir) + normalize(gl_TexCoord[3].xyz)))), 0.0, 1.0), tmpvar_2.w))));
  oColor0_3.w = albedo_4.w;
  oColor0_3.xyz = mix (FogColor, oColor0_3.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_3;
}

