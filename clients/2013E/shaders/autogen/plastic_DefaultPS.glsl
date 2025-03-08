uniform sampler2D StudsMap;
uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[2];
  vec4 oColor0_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec3 tmpvar_4;
  tmpvar_4 = mix (gl_Color.xyz, tmpvar_3.xyz, tmpvar_3.www);
  vec4 tmpvar_5;
  tmpvar_5.xyz = tmpvar_4;
  tmpvar_5.w = gl_Color.w;
  vec3 tmpvar_6;
  tmpvar_6 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_7;
  tmpvar_7 = abs((tmpvar_6 - 0.5));
  vec4 tmpvar_8;
  tmpvar_8 = mix (LightBorder, texture3D (LightMap, (tmpvar_6 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_7.x, max (tmpvar_7.y, tmpvar_7.z))))));
  oColor0_2.xyz = ((((AmbientColor + (gl_SecondaryColor.xyz * tmpvar_8.w)) + tmpvar_8.xyz) * tmpvar_4) + (Lamp0Color * (gl_SecondaryColor.w * tmpvar_8.w)));
  oColor0_2.w = tmpvar_5.w;
  oColor0_2.xyz = mix (FogColor, oColor0_2.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_2;
}

