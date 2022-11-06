uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 FogColor;
uniform sampler2D DiffuseLowMap;
uniform sampler2D DiffuseHighMap;
uniform vec3 AmbientColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[2];
  vec4 oColor0_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (DiffuseHighMap, gl_TexCoord[0].xy);
  vec3 tmpvar_4;
  tmpvar_4 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_5;
  tmpvar_5 = abs((tmpvar_4 - 0.5));
  vec4 tmpvar_6;
  tmpvar_6 = mix (LightBorder, texture3D (LightMap, (tmpvar_4 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_5.x, max (tmpvar_5.y, tmpvar_5.z))))));
  oColor0_2.xyz = ((((AmbientColor * 0.5) + (gl_Color.xyz * tmpvar_6.w)) + tmpvar_6.xyz) * mix (texture2D (DiffuseLowMap, gl_TexCoord[1].xy).xyz, tmpvar_3.xyz, tmpvar_3.www));
  oColor0_2.w = 1.0;
  oColor0_2.xyz = mix (FogColor, oColor0_2.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_2;
}

