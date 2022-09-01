//
// Entirely Colorize
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 colorize_color;
uniform float ratio;

void main()
{
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	color = mix(color, colorize_color, ratio);
	
    gl_FragColor = color;
}
