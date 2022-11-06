uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform sampler2D DiffuseLowMap;
uniform sampler2D DiffuseHighMap;
uniform vec3 AmbientColor;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_TexCoord[0].xy;
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[2];
  vec4 oColor0_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (DiffuseHighMap, tmpvar_1);
  vec4 tmpvar_5;
  tmpvar_5 = texture2D (DiffuseLowMap, tmpvar_1);
  vec3 tmpvar_6;
  tmpvar_6 = clamp (tmpvar_2.xyz, 0.0, 1.0);
  vec3 tmpvar_7;
  tmpvar_7 = abs((tmpvar_6 - 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = mix (LightBorder, texture3D (LightMap, (tmpvar_6 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_7.x, max (tmpvar_7.y, tmpvar_7.z))))));
  oColor0_3.xyz = ((((AmbientColor + (gl_Color.xyz * tmpvar_8.w)) + tmpvar_8.xyz) * mix (tmpvar_5.xyz, mix (texture2D (DiffuseLowMap, gl_TexCoord[1].xy).xyz, tmpvar_4.xyz, tmpvar_4.www), tmpvar_5.www)) + (Lamp0Color * (gl_Color.w * tmpvar_8.w)));
  oColor0_3.w = 1.0;
  oColor0_3.xyz = mix (FogColor, oColor0_3.xyz, vec3(clamp (tmpvar_2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_3;
}

