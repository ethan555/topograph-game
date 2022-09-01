function prepare_outline_surface(width_, height_) {
	if (!surface_exists(outline_surface)) {
		outline_surface = surface_create(width_, height_);
		
		outline_texture = surface_get_texture(outline_surface);
		texel_width = texture_get_texel_width(outline_texture);
		texel_height = texture_get_texel_height(outline_texture);
		
		surface_set_target(outline_surface);
		draw_clear_alpha(c_white,0);
		surface_reset_target();
	} else if (
		surface_get_width(outline_surface) < width_ or
		surface_get_height(outline_surface) < height_
	) {
		surface_resize(outline_surface, width_, height_);
		
		outline_texture = surface_get_texture(outline_surface);
		texel_width = texture_get_texel_width(outline_texture);
		texel_height = texture_get_texel_height(outline_texture);
		
		surface_set_target(outline_surface);
		draw_clear_alpha(c_white,0);
		surface_reset_target();
	}
}