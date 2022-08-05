//
// Terrace-based contour line shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float terraceNumber;
uniform vec4 contourColor;
uniform vec2 texelDimensions;

void main()
{
	vec4 texColor = texture2D( gm_BaseTexture, v_vTexcoord );
	float heightRatio = texColor.r; // r = g = b
	float terracedHeight = floor(heightRatio * terraceNumber) / terraceNumber;
	texColor = vec4(terracedHeight);
	texColor.a = 1.0;
	
    gl_FragColor = texColor;
}
