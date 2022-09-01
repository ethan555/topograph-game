//
// Outline inner
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float pixel_width;
uniform float pixel_height;

void main()
{
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	vec2 offsetx;
	offsetx.x = pixel_width;
	vec2 offsety;
	offsety.y = pixel_height;
	float alpha = 0.;
	alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).a);
	alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).a);
	alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord + offsety ).a);
	alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord - offsety ).a);
	//alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord - (offsetx + offsety) ).a);
	float max_add = 1.;
	alpha = clamp(alpha, 0., max_add);
	
	color.rgb = vec3(alpha);
	
    gl_FragColor = color;
}
