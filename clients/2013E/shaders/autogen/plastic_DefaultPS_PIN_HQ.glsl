uniform sampler2D StudsMap;
uniform sampler3D LightMap;
uniform vec4 LightConfig1;
uniform vec4 LightBorder;
uniform vec3 Lamp0Dir;
uniform vec3 Lamp0Color;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[2];
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[4];
  vec4 oColor0_3;
  vec4 tmpvar_4;
  tmpvar_4 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec3 tmpvar_5;
  tmpvar_5 = mix (gl_Color.xyz, tmpvar_4.xyz, tmpvar_4.www);
  vec4 tmpvar_6;
  tmpvar_6.xyz = tmpvar_5;
  tmpvar_6.w = gl_Color.w;
  vec3 tmpvar_7;
  tmpvar_7 = clamp (tmpvar_1.xyz, 0.0, 1.0);
  vec3 tmpvar_8;
  tmpvar_8 = abs((tmpvar_7 - 0.5));
  vec4 tmpvar_9;
  tmpvar_9 = mix (LightBorder, texture3D (LightMap, (tmpvar_7 - LightConfig1.xyz)), vec4(float((0.49 >= max (tmpvar_8.x, max (tmpvar_8.y, tmpvar_8.z))))));
  oColor0_3.xyz = ((((AmbientColor + (gl_SecondaryColor.xyz * tmpvar_9.w)) + tmpvar_9.xyz) * tmpvar_5) + (Lamp0Color * ((tmpvar_9.w * gl_SecondaryColor.w) * pow (clamp (dot (normalize(tmpvar_2.xyz), normalize((-(Lamp0Dir) + normalize(gl_TexCoord[3].xyz)))), 0.0, 1.0), tmpvar_2.w))));
  oColor0_3.w = tmpvar_6.w;
  oColor0_3.xyz = mix (FogColor, oColor0_3.xyz, vec3(clamp (tmpvar_1.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_3;
}

