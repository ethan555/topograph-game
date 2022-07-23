/// @description Draw terrain surface

terrain.draw_terrain_surface();
draw_mouse_pointer();
if (debug) {
	if (!surface_exists(debug_surface)) {
		debug_surface = surface_create(terrain.width, terrain.length);
	}
	if (!terrain.debug_drawn) {
		surface_set_target(debug_surface);
		draw_clear_alpha(c_white,0);
		var min_value = 0, max_value = 0;
		switch(debug_type) {
			case 0:
				min_value = 0;
				max_value = terrain.cell_cost_max;
				break;
			case 1:
				min_value = 0;
				max_value = terrain.cell_heuristic_max;
				break;
			case 2:
				min_value = terrain.cell_score_min;
				max_value = terrain.cell_score_max;
				break;
		}
		for (var i = 0; i < terrain.width; ++i) {
		    for (var j = 0; j < terrain.length; ++j) {
				var c = terrain.get(i,j);
				if (!c.visited) continue;
				var cc = 0;
				switch(debug_type) {
					case 0:
						cc = c.visited_cost;
						break;
					case 1:
						cc = c.heuristic_value;
						break;
					case 2:
						cc = c.visited_cost+c.heuristic_value;
						break;
				};
				var dc = make_color_hsv(0,255 * (cc - min_value) / (max_value - min_value),255);
				draw_sprite_ext(rectangle_sp,0,i,j,1,1,0,dc,1);
			}
		}
		surface_reset_target();
		terrain.debug_drawn = true;
	}
	draw_surface_ext(debug_surface,0,0,GRID_SCALE,GRID_SCALE,0,c_white,.5);
}
