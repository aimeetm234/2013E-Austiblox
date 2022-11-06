uniform sampler2D StudsMap;
uniform sampler2D DiffuseMap;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (StudsMap, gl_TexCoord[1].xy);
  vec4 tmpvar_2;
  tmpvar_2.xyz = mix (((texture2D (DiffuseMap, gl_TexCoord[0].xy).xyz + gl_Color.xyz) - 0.500000), tmpvar_1.xyz, tmpvar_1.www);
  tmpvar_2.w = gl_Color.w;
  gl_FragData[0] = (tmpvar_2 + gl_SecondaryColor);
}

