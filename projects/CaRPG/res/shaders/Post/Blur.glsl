#version 420
layout (binding = 0) uniform sampler2D colorTexture;
uniform float uPixelSizex;
uniform float uPixelSizey;

out vec4 FragColor;

in vec2 TexCoords;
void main()
{
	FragColor = vec4(0.0, 0.0, 0.0, 0.0);

	FragColor += texture( colorTexture , vec2( TexCoords.x - 4.0 * uPixelSizex, TexCoords.y - 4.0 * uPixelSizey)) * 0.0162162162;
	FragColor += texture( colorTexture , vec2( TexCoords.x - 3.0 * uPixelSizex, TexCoords.y - 3.0 * uPixelSizey)) * 0.0540540541;
	FragColor += texture( colorTexture , vec2( TexCoords.x - 2.0 * uPixelSizex, TexCoords.y - 2.0 * uPixelSizey)) * 0.1216216216;
	FragColor += texture( colorTexture , vec2( TexCoords.x -  uPixelSizex, TexCoords.y - uPixelSizey)) * 0.1945945946;
	FragColor += texture( colorTexture , vec2( TexCoords.x , TexCoords.y )) * 0.2270270270;
	FragColor += texture( colorTexture , vec2( TexCoords.x +  uPixelSizex, TexCoords.y +  uPixelSizey )) * 0.1945945946;
	FragColor += texture( colorTexture , vec2( TexCoords.x + 2.0 * uPixelSizex, TexCoords.y + 2.0 * uPixelSizey )) * 0.1216216216;
	FragColor += texture( colorTexture , vec2( TexCoords.x + 3.0 * uPixelSizex, TexCoords.y + 3.0 * uPixelSizey)) * 0.0540540541;
	FragColor += texture( colorTexture , vec2( TexCoords.x + 4.0 * uPixelSizex, TexCoords.y + 4.0 * uPixelSizey)) * 0.0162162162;

}