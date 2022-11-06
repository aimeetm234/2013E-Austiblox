uniform sampler2D DiffuseMap;
void main ()
{
  gl_FragData[0] = ((texture2D (DiffuseMap, gl_TexCoord[0].xy) * gl_Color) + gl_SecondaryColor);
}

