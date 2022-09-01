//
// Terrace-based contour line shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float terrace_number;
uniform vec4 contour_color;
uniform float pixel_width;
uniform float pixel_height;

float terrace_height(float height) {
	return floor(height * terrace_number);
}

void main()
{
	vec4 tex_color = texture2D( gm_BaseTexture, v_vTexcoord );
	float height_ratio = tex_color.r; // r = g = b
	float terraced_height = terrace_height(height_ratio);
	//tex_color = vec4(terraced_height);
	//tex_color.a = 1.0;
	
	vec2 offsetx;
	offsetx.x = pixel_width;
	vec2 offsety;
	offsety.y = pixel_height;
	float alpha_add = 0.0;
	
	//float max_height = max(
	//	terrace_height(texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).r),
	//	terrace_height(texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).r)
	//);
	//max_height = max(
	//	max_height,
	//	terrace_height(texture2D( gm_BaseTexture, v_vTexcoord + offsety ).r)
	//);
	//max_height = max(
	//	max_height,
	//	terrace_height(texture2D( gm_BaseTexture, v_vTexcoord - offsety ).r)
	//);
	float min_height = min(
		terrace_height(texture2D( gm_BaseTexture, v_vTexcoord + offsetx ).r),
		terrace_height(texture2D( gm_BaseTexture, v_vTexcoord - offsetx ).r)
	);
	min_height = min(
		min_height,
		terrace_height(texture2D( gm_BaseTexture, v_vTexcoord + offsety ).r)
	);
	min_height = min(
		min_height,
		terrace_height(texture2D( gm_BaseTexture, v_vTexcoord - offsety ).r)
	);
	
	//float contour_step = clamp(ceil(max_height - terraced_height),0.,1.);
	float contour_step = clamp(ceil(terraced_height - min_height),0.,1.);
	
	vec4 color = contour_color;
	
	color.a = contour_step;
	
    gl_FragColor = color;
}
