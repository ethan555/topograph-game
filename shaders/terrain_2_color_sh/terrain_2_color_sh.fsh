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
	float ratioLand = max(0.1, 1.0-ratioWater);
	heightRatio = clamp((heightRatio-ratioWater)/ratioLand, 0.0, 1.0);
	vec4 heightColor = mix(color1, color2, heightRatio);
	vec4 color = mix(heightColor, colorWater, isWater);
	
	float waterBase = isWater * ratioLand * 0.5;
	vec4 heightmapShade = texture2D( gm_BaseTexture, v_vTexcoord ) + waterBase;
	
    gl_FragColor = mix(color, color * heightmapShade, .8);
}
