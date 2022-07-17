//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blur_steps;
uniform vec2 texel_size;
uniform float sigma;
uniform vec2 blur_vector;

float weight(float pos) {	// Gauss 1D
	return exp(-(pos*pos) / (2.0 * sigma * sigma));
}

void main()
{
	highp vec4 blurred_color = texture2D(gm_BaseTexture, v_vTexcoord);
	
	vec2 sample;
	float offset_d1, offset_d2, offset_l, sample_weight_d1, sample_weight_d2, sample_weight_l;
	float total_weight = 1.0;
	float kernel = 2.0 * blur_steps + 1.0;
	
	for (offset_d1 = 1.0; offset_d1 <= 2.0*blur_steps; offset_d1 += 2.0) {
		offset_d2 = offset_d1 + 1.0;
		
		sample_weight_d1 = weight(offset_d1/kernel);
		sample_weight_d2 = weight(offset_d2/kernel);
		sample_weight_l = sample_weight_d1 + sample_weight_d2;
		total_weight += 2.0*sample_weight_l;
		
		offset_l = (offset_d1 * sample_weight_d1 + offset_d2 * sample_weight_d2) / sample_weight_l;
		
		sample = v_vTexcoord - offset_l * texel_size * blur_vector;
		blurred_color += texture2D(gm_BaseTexture, sample) * sample_weight_l;
		
		sample = v_vTexcoord + offset_l * texel_size * blur_vector;
		blurred_color += texture2D(gm_BaseTexture, sample) * sample_weight_l;
	}
	
    gl_FragColor = v_vColour * blurred_color / total_weight;
}
