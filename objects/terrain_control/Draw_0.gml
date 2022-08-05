/// @description Draw terrain surface

terrain.draw_terrain_surface();
draw_mouse_pointer();

if (!ds_map_empty(pathfind_map)) {
	if (!surface_exists(path_surface)) {
		path_surface = surface_create(terrain.width, terrain.length);
	}
	if (!path_drawn) {
		surface_set_target(path_surface);
		draw_clear_alpha(c_white,0);
		var pathfind_map_cells = ds_map_keys_to_array(pathfind_map);
		var pathfind_map_length = ds_map_size(pathfind_map);
		for (var i = 0; i < pathfind_map_length; ++i) {
		    var pathfind_cell_id = pathfind_map_cells[i];
			var pathfind_cell = pathfind_map[? pathfind_cell_id];
			var cell = pathfind_cell.cell;
			draw_sprite_ext(rectangle_sp,0,cell.x,cell.y,1,1,0,c_white,1);
		}
		surface_reset_target();
		path_drawn = true;
	}
	draw_surface_ext(path_surface,0,0,GRID_SCALE,GRID_SCALE,0,c_white,.25);
}

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
