function vector2(x_, y_) constructor {
	x = x_;
	y = y_;
	function equals(other_) {
		return x == other_.x && y == other_.y;
	}
}

function cell_struct(x_, y_, height_, free_) : vector2(x_, y_) constructor {
	free = free_;
	height = height_;
	parent = noone;
	visited = false;
	visited_cost = 0;
	
	function get_vector() {
		return new vector2(x, y);
	};
}

function terrain_struct(x_, y_, width_, length_, height_, scale_) constructor {
	x = x_;
	y = y_;
	width = width_;
	length = length_;
	height = height_;
	scale = scale_;
	terrain_grid = noone;
	
	function initialize() {
		cleanup()
		terrain_grid = ds_grid_create(width,length);
		for (var r = 0; r < width; ++r) {
		    for (var c = 0; c < length; ++c) {
				terrain_grid[# r, c] = new cell_struct(r,c,height,true);
			}
		}
	}
	function cleanup() {
		if (ds_exists(terrain_grid, ds_type_grid)) {
			ds_grid_destroy(terrain_grid);
		}
	}
	
	function snap(x_, y_) {
		var tx = floor((x_ - x) / scale), ty = floor((y_ - y) / scale);
		return new vector2(tx, ty);
	}
	
	function snap_draw(x_, y_) {
		var snapped = snap(x_, y_);
		snapped.x *= scale;
		snapped.y *= scale;
		return snapped;
	}
	
	function outside_raw(x_, y_) {
		var snapped = snap(x_, y_);
		return outside(snapped.x, snapped.y);
	}
	
	function outside(x_, y_) {
		return x_ < 0 || x_ >= width || y_ < 0 || y_ >= length;
	}
	function inside_raw(x_, y_) {
		return !outside_raw(x_, y_);
	}
	function inside(x_, y_) {
		return !outside(x_, y_);
	} 
	
	function get_free_raw(x_, y_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			return terrain_grid[# snapped.x, snapped.y].free;
		} else {
			return -1;
		}
	}
	function get_height_raw(x_, y_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			return terrain_grid[# snapped.x, snapped.y].height;
		} else {
			return -1;
		}
	}
	function get_raw(x_, y_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			return terrain_grid[# snapped.x, snapped.y];
		} else {
			return -1;
		}
	}
	function get_free(x_, y_) {
		return terrain_grid[# x_, y_].free;
	}
	function get_height(x_, y_) {
		return terrain_grid[# x_, y_].height;
	}
	function get_unsafe(x_, y_) {
		if (!inside(x_, y_)) {
			return -1;
		}
		return get(x_, y_);
	}
	function get(x_, y_) {
		return terrain_grid[# x_, y_];
	}
	function set_raw(x_, y_, z_, free_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			terrain_grid[# snapped.x, snapped.y].height = z_;
			terrain_grid[# snapped.x, snapped.y].free = free_;
		}
	}
	function set_height_raw(x_, y_, z_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			terrain_grid[# snapped.x, snapped.y].height = z_;
		}
	}
	function set_free_raw(x_, y_, free_) {
		var snapped = snap(x_, y_);
		if (!outside(snapped.x, snapped.y)) {
			terrain_grid[# snapped.x, snapped.y].free = free_;
		}
	}
	function set(x_, y_, z_, free_) {
		terrain_grid[# x_, y_].height = z_;
		terrain_grid[# x_, y_].free = free_;
	}
	function set_height(x_, y_, z_) {
		terrain_grid[# x_, y_].height = z_;
	}
	function set_height_unsafe(x_, y_, z_) {
		if (inside(x_, y_)) {
			set_height(x_, y_, z_);
		}
	}
	function set_free(x_, y_, free_) {
		terrain_grid[# x_, y_].free = free_;
	}
	function set_rectangle(x1, y1, x2, y2, z_, free_) {
		for (var i = x1; i <= x2; ++i) {
		    for (var j = y1; j <= y2; ++j) {
			    if (!outside(i, j)) {
					terrain_grid[# i, j].free = free_;
					terrain_grid[# i, j].height = z_;
				}
			}
		}
	}
	function set_free_rectangle(x1, y1, x2, y2, free_) {
		for (var i = x1; i <= x2; ++i) {
		    for (var j = y1; j <= y2; ++j) {
			    if (!outside(i, j)) {
					terrain_grid[# i, j].free = free_;
				}
			}
		}
	}
	function set_height_rectangle(x1, y1, x2, y2, z_) {
		for (var i = x1; i <= x2; ++i) {
		    for (var j = y1; j <= y2; ++j) {
			    if (!outside(i, j)) {
					terrain_grid[# i, j].height = z_;
				}
			}
		}
	}
	
	#region Pathfinding
	path = ds_list_create();
	
	function init_pathfinding() {
		for (var r = 0; r < width; ++r) {
		    for (var c = 0; c < length; ++c) {
				var cell = terrain_grid[# r, c];
				cell.visited = false;
				cell.visited_cost = 0;
				cell.parent = noone;
			}
		}
		ds_list_clear(path);
	};
	
	function heuristic(x1, y1, x2, y2) {
		return power(point_distance(x1, y1, x2, y2)/(GRID_SCALE), 2);
	}
	function cell_heuristic(a, b) {
		return heuristic(a.x, a.y, b.x, b.y);
	}
	function vector2_to_world(v2) {
		return new vector2(v2.x*GRID_SCALE+x, v2.y*GRID_SCALE+y);
	}
	function build_path(path_, a, b) {
		var pointer = b;
		while(!pointer.equals(a)) {
			ds_list_add(path_, vector2_to_world(pointer));
			pointer = pointer.parent;
		}
		ds_list_add(path_, vector2_to_world(pointer));
	}
	function get_path(x1_, y1_, x2_, y2_, mobility_) {
		var vec2 = snap(x1_, y1_);
		var x1 = vec2.x, y1 = vec2.y;
		var cell1 = get_unsafe(x1, y1);
		if (cell1 == -1) return -1;
		vec2 = snap(x2_, y2_);
		var x2 = vec2.x, y2 = vec2.y;
		var cell2 = get_unsafe(x2, y2);
		if (cell2 == -1) return -1;
		if (!cell1.free || !cell2.free) return -1;
		init_pathfinding();
		cell1.visited = true;
		
		// Do the magic
		var current_cell = cell1;
		var pathfinder = ds_priority_create();
		var directions = [
			new vector2(0, -1), new vector2(-1, 0), new vector2(1, 0), new vector2(0, 1),
			new vector2(-1, -1), new vector2(-1, 1), new vector2(1, -1), new vector2(1, 1)
		];
		var iterations = 0;
		while (!current_cell.equals(cell2) && iterations < 10000) {
			for (var i = 0; i < 8; ++i) {
				var move_cost = i < 4 ? 1 : DIAGONAL_COST;
				var neighbor_vector = directions[i];
				var neighbor = get_unsafe(current_cell.x + neighbor_vector.x, current_cell.y + neighbor_vector.y);
				if (neighbor == -1) continue;
				
				if (neighbor.visited || !neighbor.free) continue;
				if (mobility_ == MOB_LAND && neighbor.height < 0) continue;
				if (mobility_ == MOB_WATER && neighbor.height >= 0) continue;
				var move_cost = 0;
				if (mobility_ == MOB_LAND) {
					move_cost = HEIGHT_COST * max(0, neighbor.height - current_cell.height);
				}
				var neighbor_cost = move_cost + current_cell.visited_cost;
				neighbor.parent = current_cell;
				neighbor.visited_cost = neighbor_cost;
				neighbor.visited = true;
				
				var neighbor_score = neighbor_cost + cell_heuristic(neighbor, cell2);
			    ds_priority_add(pathfinder, neighbor, neighbor_score);
			}
			if (ds_priority_size(pathfinder) > 0) {
				current_cell = ds_priority_delete_min(pathfinder);
				++iterations;
			} else {
				break;
			}
		}
		build_path(path, cell1, current_cell);
		ds_priority_destroy(pathfinder);
		
		var path_array = list_to_array_reverse(path);
		return path_array;
	};
	#endregion
}

function terrain_map_struct(terrain_sprite_, contour_sprite_, left_, top_, width_, length_, min_height_, max_height_, water_ratio_, color_min_, color_max_, color_water_) : terrain_struct(0.5, 0.5, 1, 1, 1, 4) constructor {
	terrain_sprite = terrain_sprite_;
	contour_sprite = contour_sprite_;
	left = left_;
	top = top_;
	width = width_; // sprite_get_width(terrain_sprite_);
	length = length_; // sprite_get_height(terrain_sprite_);
	terrain_width = sprite_get_width(terrain_sprite);
	terrain_length = sprite_get_height(terrain_sprite);
	min_height = min_height_;
	max_height = max_height_;
	water_ratio = water_ratio_;
	
	color_min = color_min_;
	color_max = color_max_;
	color_water = color_water_;
	
	terrain_surface = noone;
	
	if (left < 0 or width > terrain_width or top < 0 or length > terrain_length
		or width < 1 or length < 1
		or left + width > terrain_width or top + length > terrain_length) {
		throw ("Invalid map: dimensions don't fit provided terrain image");
	}
	
	function cleanup() {
		if (ds_exists(terrain_grid, ds_type_grid)) {
			ds_grid_destroy(terrain_grid);
		}
		if (surface_exists(terrain_surface)) {
			surface_free(terrain_surface);
		}
	}
	function draw_terrain() {
		surface_set_target(terrain_surface);
		
		shader_set(terrain_2_color_sh);
		
		shader_set_uniform_f(u_ratioWater, water_ratio);
		var c1_r = color_get_red(color_min)/255,
			c1_g = color_get_green(color_min)/255,
			c1_b = color_get_blue(color_min)/255,
			c1_a = 1;
		shader_set_uniform_f(u_color1, c1_r, c1_g, c1_b, c1_a);
		var c2_r = color_get_red(color_max)/255,
			c2_g = color_get_green(color_max)/255,
			c2_b = color_get_blue(color_max)/255,
			c2_a = 1;
		shader_set_uniform_f(u_color2, c2_r, c2_g, c2_b, c2_a);
		var cw_r = color_get_red(color_water)/255,
			cw_g = color_get_green(color_water)/255,
			cw_b = color_get_blue(color_water)/255,
			cw_a = 1;
		shader_set_uniform_f(u_colorWater, cw_r, cw_g, cw_b, cw_a);
		
		draw_sprite_part(terrain_sprite,0,left,top,width,length,0,0);
		shader_reset();
		surface_reset_target();
	}
	function draw_terrain_surface() {
		if (!surface_exists(terrain_surface)) {
			terrain_surface = surface_create(width,length);
			draw_terrain();
		}
		draw_surface_ext(terrain_surface,x,y,4,4,0,c_white,1);
		//draw_sprite_part_ext(contour_sprite,0,left,top,width,length,x,y,4,4,c_white,.5);
	}
	function initialize() {
		cleanup()
		terrain_grid = ds_grid_create(width,length);
		terrain_surface = surface_create(width,length);
		
		surface_set_target(terrain_surface);
		//shader_set(terrain_2_color_sh);
		draw_sprite_part(terrain_sprite,0,left,top,width,length,0,0);
		//shader_reset();
		surface_reset_target();
		
		for (var r = 0; r < width; ++r) {
		    for (var c = 0; c < length; ++c) {
				var color_value = surface_getpixel(terrain_surface, r, c);
				var height_ratio = color_get_red(color_value);
				var is_water = height_ratio < water_ratio;
				var h = is_water ? 0 : lerp(min_height, max_height, height_ratio);
				terrain_grid[# r, c] = new cell_struct(r,c,h,true);
			}
		}
		
		draw_terrain();
		draw_terrain_surface();
	}
}