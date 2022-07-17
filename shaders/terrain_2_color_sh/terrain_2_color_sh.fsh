//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float ratioWater;	// 0 <= r <= 1
//uniform vec2 heightRange;	// 0 <= x, y <= 1
uniform vec4 color1;		// min height color
uniform vec4 color2;		// max height color
uniform vec4 colorWater;	// color of water

void main()
{
	float heightRatio = texture2D( gm_BaseTexture, v_vTexcoord ).r; // r = b = g
	float isWater = float(heightRatio < ratioWater);
	vec4 color = vec4(1);
	heightRatio = clamp((heightRatio-ratioWater)/(1.0-ratioWater), 0.0, 1.0);
	vec4 heightColor = mix(color1, color2, heightRatio);
	color = mix(heightColor, colorWater, isWater);
	
    gl_FragColor = mix(color, color * texture2D( gm_BaseTexture, v_vTexcoord ), .8);
}
