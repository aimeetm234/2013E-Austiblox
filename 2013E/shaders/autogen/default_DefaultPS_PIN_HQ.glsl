uniform vec3 Lamp0Dir;
uniform sampler2D DiffuseMap;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_TexCoord[3];
  gl_FragData[0] = ((texture2D (DiffuseMap, gl_TexCoord[0].xy) * gl_Color) + (gl_SecondaryColor * pow (clamp (dot (normalize (tmpvar_1.xyz), normalize ((-(Lamp0Dir) + normalize (gl_TexCoord[2].xyz)))), 0.000000, 1.00000), tmpvar_1.w)));
}

