//
// Outline border
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 outline_color;
uniform float pixel_width;
uniform float pixel_height;

const float max_add = 1.;

//float get_alpha_add(base_texture, offset) {
//	return texture2D( gm_BaseTexture, v_vTexcoord + offset ).a;
//}

void main()
{
	vec4 color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	float alpha = color.a;
	
	vec2 offsetx;
	offsetx.x = pixel_width;
	vec2 offsety;
	offsety.y = pixel_height;
	float alpha_add = 0.0;
	
	alpha_add += texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).a +
			texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).a +
			texture2D( gm_BaseTexture, v_vTexcoord + offsety ).a +
			texture2D( gm_BaseTexture, v_vTexcoord - offsety ).a;
	//alpha += (1. - texture2D( gm_BaseTexture, v_vTexcoord - (offsetx + offsety) ).a);
	
	alpha_add = clamp(alpha_add, 0., max_add);
	
	float outline_ratio = clamp(alpha_add - alpha, 0., 1.);
	
	color = mix(color, outline_color, outline_ratio);
	
    gl_FragColor = color;
}
