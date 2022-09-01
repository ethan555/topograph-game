function draw_unit(faction_color_) {
	var offset = 0;
	var draw_scale = 1;
	if (faction == FACTION_PLAYER) draw_scale = get_zoom_draw_ratio();
	
	draw_sprite_ext(sprite_index,0,x+offset,y+offset,
		draw_scale,draw_scale,draw_angle,image_blend,image_alpha);
	draw_sprite_ext(sprite_index,1,x+offset,y+offset,
		draw_scale,draw_scale,draw_angle,faction_color_,image_alpha);
}

function draw_surface_centered(surface_, x_, y_, left_, top_, width_, height_, xscale_, yscale_, angle_, blend_, alpha_) {
	// Draw surface rotated around a central point
	var cx = width_ / 2;
	var cy = height_ / 2;
	
	var dx = offset_x(x_,-cx*xscale_,-cy*yscale_,angle_);
	var dy = offset_y(y_,-cx*xscale_,-cy*yscale_,angle_);
	
	//var s = dsin(angle_);
	//var c = dcos(angle_);
	
	//var tx = (-cx);
	//var ty = (-cy);
	
	//var rot_x = tx * c - ty * s;
	//var rot_y = tx * s + ty * c;
	
	//var dx = rot_x;
	//var dy = rot_y;
	
	//draw_surface_general(surface_, left_, top_, width_, height_,
		//x_+xscale_*dx, y_+xscale_*dy, xscale_, yscale_, angle_,
		//blend_, blend_, blend_, blend_, alpha_);
		
	draw_surface_general(
		surface_, left_, top_, width_, height_,
		dx, dy, xscale_, yscale_, angle_,
		blend_, blend_, blend_, blend_, alpha_
	);
}

function draw_unit_outline(faction_color_) {
	// Prepare outline surface
	prepare_outline_surface(sprite_width, sprite_height);
	
	// Get draw offset, scale
	var offset = 0;
	var draw_scale = get_zoom_draw_ratio();
	
	surface_set_target(outline_surface);
	draw_sprite_ext(sprite_index,0,sprite_width/2,sprite_height/2,
		1,1,0,image_blend,image_alpha);
	draw_sprite_ext(sprite_index,1,sprite_width/2,sprite_height/2,
		1,1,0,faction_color_,image_alpha);
	surface_reset_target();
		
	shader_set(outline_border_sh);
	var faction_r = color_get_red(focus_color)/255;
	var faction_g = color_get_green(focus_color)/255;
	var faction_b = color_get_blue(focus_color)/255;
	shader_set_uniform_f(u_outline_color, faction_r, faction_g, faction_b, 1.);
	shader_set_uniform_f(u_pixel_width, texel_width);
	shader_set_uniform_f(u_pixel_height, texel_height);
	draw_surface_centered(outline_surface, x+offset, y+offset, 0, 0, sprite_width, sprite_width,
		draw_scale, draw_scale, draw_angle, c_white, 1);
	shader_reset();
}
