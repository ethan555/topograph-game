/// @description Draw terrain surface

draw_terrain_surface();
draw_mouse_pointer();
//if (!drawn) {
	// Draw terrain, bit by bit
	//surface_set_target(terrain_surface);
	////draw_set_color(c_black);
	////draw_rectangle(0, 0, width, length, false);
	
	//// Dumb Multipass Draw
	////for (var l = 0; l <= MAX_HEIGHT; l++) {
		
	////	if (!draw_mode) {
	////	for (var i = 0; i < width; ++i) {
	////	    for (var j = 0; j < length; ++j) {
	////			var h = terrain.get_height(i, j);
	////			if (h == l) {
	////				draw_sprite(contour_sp, 0, i*scale, j*scale);
	////			}
	////		}
	////	}
	////	}
	////	for (var i = 0; i < width; ++i) {
	////	    for (var j = 0; j < length; ++j) {
	////			var h = terrain.get_height(i, j);
	////			if (h == l) {
	////				var si = h >= 0 ? terrain_sp : water_sp, ii = h >= 0 ? h : 0;
	////				draw_sprite_ext(si, ii, i*scale, j*scale, 1, 1, 0, color, 1);
	////			}
	////		}
	////	}
	////}
	
	//// Smart Shader Draw
	//for (var i = 0; i < width-1; ++i) {
	//	draw_primitive_begin(pr_trianglestrip);
	//	var hi1 = terrain.get_height(i, 0);
	//	var ci1 = merge_color(color1,color2,hi1/MAX_HEIGHT);
	//	for (var j = 0; j < length; ++j) {
	//		var i2 = i+1;
	//		var h1 = terrain.get_height(i, j);
	//		var h2 = terrain.get_height(i2, j);
	//		var c1 = merge_color(color1,color2,h1/MAX_HEIGHT);
	//		var c2 = merge_color(color1,color2,h2/MAX_HEIGHT);
	//		draw_vertex_color(i*scale, j*scale, c1, 1);
	//		draw_vertex_color(i2*scale, j*scale, c2, 1);
	//	}
	//	draw_primitive_end()
	//}
	
	//draw_set_color(c_white);
	//draw_rectangle(1,1,(width-1)*scale,(length-1)*scale,true)
	//drawn = true;
	//surface_reset_target();
	//draw_terrain();
	////draw_surface(terrain_surface, x, y);
	//draw_terrain_surface();
//} else {
	// Draw mode
	//if (draw_mode) {
	//	var si = brush_height >= 0 ? terrain_sp : water_sp, ii = brush_height >= 0 ? brush_height : 0;
	//	var m = mouse_check_button(mb_left);
	//	var m_x = mouse_x, m_y = mouse_y;
	//	var t_pos = terrain.snap(m_x, m_y);
	//	var m_pos = terrain.snap_draw(m_x, m_y);
	//	if (m && terrain.inside(t_pos.x, t_pos.y)) {
	//		//surface_set_target(terrain_surface);
	//		draw_brush(m_pos.x, m_pos.y, t_pos.x, t_pos.y, true, false, true);
	//		draw_terrain();
	//		//surface_reset_target();
	//	}
	//}
	
	//draw_terrain_surface();
	
	//if (draw_mode) {
	//	var si = brush_height >= 0 ? terrain_sp : water_sp, ii = brush_height >= 0 ? brush_height : 0;
	//	if (!terrain.outside_raw(m_x, m_y)) {
	//		var snapped = terrain.snap_draw(m_x, m_y);
	//		var d_x = snapped.x + x, d_y = snapped.y + y;
	//		draw_brush(d_x+scale/2, d_y+scale/2, 0, 0, false, true, false);
	//	}
	//}
//}


// Smart draw
//var directions = array_create(9);
//var d = 0;
//for (var r = 0; r <= 1; ++r) {
//	for (var c = 0; c <= 1; ++c) {
//	    directions[d++] = new cell(r, c);
//	}
//}
//var dirs = array_length(directions);
//for (var i = 0; i < width; ++i) {
//    for (var j = 0; j < length; ++j) {
//		var height = terrain.get(i, j);
//		draw_sprite_ext(contour_sp, 0, i*scale, j*scale, 1, 1, 0, c_white, 1);
//	    //for (d = 0; d < dirs; ++d) {
//		//    var row = i + d.x, col = j + d.y;
//		//	var inside = (row >= 0 && row < width) && (col >= 0 && col < length);
//		//	var height = terrain.get(row, col);
//		//	if (inside) {
//		//		draw_sprite_ext(contour_sp, 0, 
//		//		//var diff = current_height != height;
//		//		//if (diff) {
//		//		//	var l = height > current_height ? 
//		//		//	draw_sprite_part_ext(terrain_sp, height, );
//		//		//} else {
//		//		//	draw_sprite_part_ext();
//		//		//}
//		//	}
//		//}
//	}
//}
