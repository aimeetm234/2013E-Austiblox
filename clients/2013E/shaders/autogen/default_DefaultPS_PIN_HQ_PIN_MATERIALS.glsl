uniform sampler2D StudsMap;
uniform vec3 Lamp0Dir;
uniform sampler2D DiffuseMap;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[3];
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec4 tmpvar_3;
  tmpvar_3.xyz = mix (((texture2D (DiffuseMap, gl_TexCoord[0].xy).xyz + gl_Color.xyz) - 0.500000), tmpvar_2.xyz, tmpvar_2.www);
  tmpvar_3.w = gl_Color.w;
  gl_FragData[0] = (tmpvar_3 + (gl_SecondaryColor * pow (clamp (dot (normalize (tmpvar_1.xyz), normalize ((-(Lamp0Dir) + normalize (gl_TexCoord[2].xyz)))), 0.000000, 1.00000), tmpvar_1.w)));
}

