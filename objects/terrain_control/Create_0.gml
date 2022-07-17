/// @description Generate terrain

terrain = new terrain_map_struct(terrain_sprite,contour_sprite,128,128,128,128,height_min,height_max,water_ratio,color1,color2,color_water);
terrain.initialize();

//terrain = new terrain_struct(x, y, width, length, height, scale);
//terrain.initialize();
//var w = width*(scale+1), l = length*(scale+1);

//terrain_surface = surface_create(w,l);

//terrain.set_height_rectangle(10,10,20,20,2);
//terrain.set_height_unsafe(12,12,3);
//terrain.set_height_unsafe(12,13,3);
//terrain.set_height_unsafe(13,12,3);
//terrain.set_height_unsafe(14,12,3);
//terrain.set_height_unsafe(14,13,3);
//terrain.set_height_unsafe(14,14,3);
//terrain.set_height_unsafe(13,14,3);

//vertex_format_begin();
//vertex_format_add_color();
//vertex_format_add_position();
//terrain_vertex_format = vertex_format_end();

//globalvar instance_surface, bloom_surface_1, bloom_surface_2, bloom_texture,
//bloom_threshold, bloom_range,
//blur_steps, blur_sigma, texel_width, texel_height,
//bloom_intensity, bloom_darken, bloom_saturation, bloom_texture;

//blur_steps = 8;
//blur_sigma = .1;

//globalvar b_sh_threshold, b_sh_range,
//bl_sh_blur_steps, bl_sh_sigma, bl_sh_texel_size, bl_sh_blur_vector,
//b_sh_intensity, b_sh_darken, b_sh_saturation, b_sh_texture;

//bl_sh_blur_steps = shader_get_uniform(blur_2_pass_gauss_lerp_sh, "blur_steps");
//bl_sh_sigma = shader_get_uniform(blur_2_pass_gauss_lerp_sh, "sigma");
//bl_sh_texel_size = shader_get_uniform(blur_2_pass_gauss_lerp_sh, "texel_size");
//bl_sh_blur_vector = shader_get_uniform(blur_2_pass_gauss_lerp_sh, "blur_vector");

dirs = [
	new vector2(0,-1), new vector2(-1,0), new vector2(1,0), new vector2(0, 1),
	new vector2(-1,-1), new vector2(1,-1), new vector2(-1,1), new vector2(1, 1),
	new vector2(-1,-2), new vector2(1,-2), new vector2(-2,-1), new vector2(2, -1), new vector2(-2,1), new vector2(2,1), new vector2(-1,2), new vector2(1, 2)
];

function get_average_height(h1,h2,h3,h4) {
	var is_water = h1 == -1 or h2 == -1 or h3 == -1 or h4 == -1;
		
	if is_water {
		return -1;
	} else {
		return round((h1+h2+h3+h4)/4);
	}
}

function get_height_color(height, color1, color2, color_water) {
	return height > -1 ? merge_color(color1,color2,height/MAX_HEIGHT) : color_water;
}

//function draw_terrain() {
//	surface_set_target(terrain_surface);
//	//draw_set_color(c_black);
//	//draw_rectangle(0, 0, width, length, false);
	
//	// Dumb Multipass Draw
//	//for (var l = 0; l <= MAX_HEIGHT; l++) {
		
//	//	if (!draw_mode) {
//	//	for (var i = 0; i < width; ++i) {
//	//	    for (var j = 0; j < length; ++j) {
//	//			var h = terrain.get_height(i, j);
//	//			if (h == l) {
//	//				draw_sprite(contour_sp, 0, i*scale, j*scale);
//	//			}
//	//		}
//	//	}
//	//	}
//	//	for (var i = 0; i < width; ++i) {
//	//	    for (var j = 0; j < length; ++j) {
//	//			var h = terrain.get_height(i, j);
//	//			if (h == l) {
//	//				var si = h >= 0 ? terrain_sp : water_sp, ii = h >= 0 ? h : 0;
//	//				draw_sprite_ext(si, ii, i*scale, j*scale, 1, 1, 0, color, 1);
//	//			}
//	//		}
//	//	}
//	//}
	
//	// Smart Shader Draw
//	draw_set_color(c_white);
//	for (var i = 0; i < width-1; ++i) {
//		//draw_primitive_begin(pr_trianglestrip);
//		draw_primitive_begin(pr_trianglelist);
//		//draw_primitive_begin(pr_linelist);
//		var i2 = i+1;
//		var off = scale/2;
//		//var hi1 = terrain.get_height(i, 0);
//		//var ci1 = merge_color(color1,color2,hi1/MAX_HEIGHT);
//		for (var j = 0; j < length-1; ++j) {
//			var j2 = j+1;
//			var h1 = terrain.get_height(i, j);
//			var h2 = terrain.get_height(i2, j);
//			var h3 = terrain.get_height(i, j2);
//			var h4 = terrain.get_height(i2, j2);
//			var havg = get_average_height(h1,h2,h3,h4);
//			var c1 = get_height_color(h1, color1, color2, color_water); //h1 > 0 ? merge_color(color1,color2,h1/MAX_HEIGHT) : color_water;
//			var c2 = get_height_color(h2, color1, color2, color_water); //merge_color(color1,color2,h2/MAX_HEIGHT);
//			var c3 = get_height_color(h3, color1, color2, color_water); //merge_color(color1,color2,h3/MAX_HEIGHT);
//			var c4 = get_height_color(h4, color1, color2, color_water); //merge_color(color1,color2,h4/MAX_HEIGHT);
//			var cavg = get_height_color(havg, color1, color2, color_water); //merge_color(color1,color2,havg/MAX_HEIGHT);
			
//			var drawx1 = i*scale+off, drawy1 = j*scale+off,
//				drawx2 = i2*scale+off, drawy2 = j2*scale+off;
//			var drawxmid = i*scale+scale/2+off, drawymid = j*scale+scale/2+off;
//			//draw_set_color(c1);
//			//draw_rectangle(i*scale,j*scale,i2*scale,j2*scale,false);
//			//draw_circle(drawx,drawy,scale/2,false);
			
//			// Draw 4 triangles
//			draw_vertex_color(drawx1, drawy1, c1, 1);
//			draw_vertex_color(drawxmid, drawymid, cavg, 1);
//			draw_vertex_color(drawx2, drawy1, c2, 1);
			
//			draw_vertex_color(drawx2, drawy1, c2, 1);
//			draw_vertex_color(drawxmid, drawymid, cavg, 1);
//			draw_vertex_color(drawx2, drawy2, c4, 1);
			
//			draw_vertex_color(drawx2, drawy2, c4, 1);
//			draw_vertex_color(drawxmid, drawymid, cavg, 1);
//			draw_vertex_color(drawx1, drawy2, c3, 1);
			
//			draw_vertex_color(drawx1, drawy2, c3, 1);
//			draw_vertex_color(drawxmid, drawymid, cavg, 1);
//			draw_vertex_color(drawx1, drawy1, c1, 1);
			
//			//draw_vertex_color(i2*scale, j*scale, c2, 1);
//			//draw_vertex_color(drawx, j*scale, c3, 1);
//			//draw_vertex_color(i2*scale, j*scale, c4, 1);
			
//			//draw_vertex_color(i*scale, j*scale, c1, 1);
//			//draw_vertex_color(i2*scale, j*scale, c2, 1);
			
//			//draw_vertex_color(i*scale, j*scale, c2, 1);
//			//draw_vertex_color(i*scale, j2*scale, c1, 1);
			
//			//draw_vertex_color(i*scale, j2*scale, c3, 1);
//			//draw_vertex_color(i2*scale, j2*scale, c4, 1);
			
//			//draw_point(i*scale,j*scale);
//			//draw_point(i*scale+1*scale,j*scale);
//		}
//		draw_primitive_end();
//	}
	
//	draw_rectangle(1,1,(width-1)*scale,(length-1)*scale,true)
//	drawn = true;
//	surface_reset_target();
//}

function draw_terrain_surface() {
	with (terrain) {
		draw_terrain_surface();
	}
	//var w = surface_get_width(terrain_surface), l = surface_get_height(terrain_surface);
	//var terrain_surface_pass1 = surface_create(w,l);
	//var terrain_surface_pass2 = surface_create(w,l);
	
	//surface_set_target(terrain_surface_pass1);
	//shader_set(blur_2_pass_gauss_lerp_sh);
	
	//// First pass
	//shader_set_uniform_f(bl_sh_blur_steps, blur_steps);
	//shader_set_uniform_f(bl_sh_sigma, blur_sigma);
	//texel_width = 1/w;
	//texel_height = 1/l;
	//shader_set_uniform_f(bl_sh_texel_size, texel_width, texel_height);
	//shader_set_uniform_f(bl_sh_blur_vector,1,0);
	
	//draw_surface(terrain_surface, 0,0);//x, y);
	
	//// Second pass
	//surface_reset_target();
	//surface_set_target(terrain_surface_pass2);
	//shader_set_uniform_f(bl_sh_blur_vector,0,1);
	
	//draw_surface(terrain_surface_pass1, 0,0);// x, y);
	
	//shader_reset();
	//surface_reset_target();
	
	//draw_surface(terrain_surface_pass2, x, y);
	//surface_free(terrain_surface_pass1);
	//surface_free(terrain_surface_pass2);
}

function draw_mouse_pointer() {
	var mx = mouse_x, my = mouse_y;
	var mpos = terrain.snap_draw(mx, my);
	draw_set_color(c_white);
	draw_rectangle(mpos.x,mpos.y,mpos.x+scale,mpos.y+scale,true);
}

function draw_brush(d_x, d_y, t_x, t_y, terrain_draw, sprite_draw, set_terrain) {
	if (terrain_draw) surface_set_target(terrain_surface);
	var si = brush_height >= 0 ? terrain_sp : water_sp, ii = brush_height >= 0 ? brush_height : 0;
	var c = merge_color(color1,color2,brush_height/MAX_HEIGHT)
	switch(brush_scale) {
		case 5:
			for (var i = 8; i < 16; ++i) {
				var d_pos = dirs[i];
				if (sprite_draw) draw_sprite_ext(si, ii, d_x+d_pos.x*scale, d_y+d_pos.y*scale, 1, 1, 0, c, 1);
				if (set_terrain) terrain.set_height_unsafe(t_x+d_pos.x, t_y+d_pos.y, brush_height);
			}
		case 4:
			for (var i = 0; i < 4; ++i) {
				var d_pos = dirs[i];
				if (sprite_draw) draw_sprite_ext(si, ii, d_x+d_pos.x*scale*2, d_y+d_pos.y*scale*2, 1, 1, 0, c, 1);
				if (set_terrain) terrain.set_height_unsafe(t_x+d_pos.x*2, t_y+d_pos.y*2, brush_height);
			}
		case 3:
			for (var i = 4; i < 8; ++i) {
				var d_pos = dirs[i];
				if (sprite_draw) draw_sprite_ext(si, ii, d_x+d_pos.x*scale, d_y+d_pos.y*scale, 1, 1, 0, c, 1);
				if (set_terrain) terrain.set_height_unsafe(t_x+d_pos.x, t_y+d_pos.y, brush_height);
			}
		case 2:
			for (var i = 0; i < 4; ++i) {
				var d_pos = dirs[i];
				if (sprite_draw) draw_sprite_ext(si, ii, d_x+d_pos.x*scale, d_y+d_pos.y*scale, 1, 1, 0, c, 1);
				if (set_terrain) terrain.set_height_unsafe(t_x+d_pos.x, t_y+d_pos.y, brush_height);
			}
		case 1:
			if (sprite_draw) draw_sprite_ext(si, ii, d_x, d_y, 1, 1, 0, c, 1);
			if (set_terrain) terrain.set_height_unsafe(t_x, t_y, brush_height);
			break;
	}
	if (terrain_draw) surface_reset_target();
}