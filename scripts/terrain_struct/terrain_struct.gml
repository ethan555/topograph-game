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
	heuristic_value = 0;
	
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
	
	pathfinding_type = 0; // 0 = adjacent, 1 = adj. with longs, 2 = longs
	
	cell_cost_max = 0;
	cell_heuristic_max = 0;
	cell_score_min = 1000000000;
	cell_score_max = 0;
	debug_drawn = false;
	
	static directions = -1;
	switch (pathfinding_type) {
		case 0:
			directions = [
				// up down right left, <4
				new vector2(0, -1), new vector2(-1, 0), new vector2(1, 0), new vector2(0, 1),
				// diagonal, 4 <= i < 8
				new vector2(-1, -1), new vector2(-1, 1), new vector2(1, -1), new vector2(1, 1)
			];
			break;
		case 1:
			directions = [
				// up down right left, <4
				new vector2(0, -1), new vector2(-1, 0), new vector2(1, 0), new vector2(0, 1),
				// diagonal, 4 <= i < 8
				new vector2(-1, -1), new vector2(-1, 1), new vector2(1, -1), new vector2(1, 1),
				// long, 8 <= i < 12
				//new vector2(0, -2), new vector2(-2, 0), new vector2(2, 0), new vector2(0, 2),
				// far, 12 <= i < 20
				new vector2(-1, -2), new vector2(1, -2),
				new vector2(-2, -1), new vector2(2, -1), new vector2(-2, 1), new vector2(2, 1),
				new vector2(-1, 2), new vector2(1, 2)
			];
			break;
		case 2:
			directions = [
				// 0 <= i < 4, straight lines
				new vector2(0, -2), new vector2(-2, 0), new vector2(2, 0), new vector2(0, 2),
				// 4 <= i < 12, slight diagonal
				new vector2(-1, -2), new vector2(1, -2), 
				new vector2(-2, -1), new vector2(2, -1),
				new vector2(-2, 1), new vector2(2, 1),
				new vector2(-1, 2), new vector2(1, 2),
				// 12 <= i < 16, diagonal
				new vector2(-2, -2), new vector2(2, -2), new vector2(-2, 2),new vector2(2, 2)
			];
			break;
	}
	
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
		debug_drawn = false;
		cell_cost_max = 0;
		cell_heuristic_max = 0;
		cell_score_min = 1000000000;
		cell_score_max = 0;
		for (var r = 0; r < width; ++r) {
		    for (var c = 0; c < length; ++c) {
				var cell = terrain_grid[# r, c];
				cell.visited = false;
				cell.visited_cost = 0;
				cell.heuristic_value = 0;
				cell.parent = noone;
			}
		}
		ds_list_clear(path);
	};
	
	function heuristic(x1, y1, x2, y2, h1, h2) {
		//var dist = point_distance(x1, y1, x2, y2);
		var hd1 = min(h1, h2);
		var dist = point_distance_3d(x1, y1, hd1, x2, y2, h2);
		var dist_heuristic = power(dist, HEURISTIC_POWER);
		//var height_diff = max(0, h2 - h1);
		//var height_heuristic = power(height_diff, HEURISTIC_HEIGHT_POWER);
		//var value = dist_heuristic + height_heuristic;
		var value = dist_heuristic;
		return value;
	}
	function cell_heuristic(a, b) {
		return heuristic(a.x, a.y, b.x, b.y, a.height, b.height);
	}
	function vector2_to_world(v2) {
		return new vector2(v2.x*GRID_SCALE+x+GRID_SCALE/2, v2.y*GRID_SCALE+y+GRID_SCALE/2);
	}
	function build_path(path_, a, b) {
		var pointer = b;
		while(!pointer.equals(a)) {
			ds_list_add(path_, vector2_to_world(pointer));
			pointer = pointer.parent;
		}
		ds_list_add(path_, vector2_to_world(pointer));
	}
	function get_direction_cost(index) {
		switch(pathfinding_type) {
			case 0:
			case 1:
				if (index < 4) {
					return MOVE_COST;
				} else if (index < 8) {
					return DIAGONAL_COST;
				//} else if (index < 12) {
				//	return LONG_COST;
				} else if (index < 20) {
					return FAR_COST;
				}
				break;
			case 2:
				if (index < 4) {
					return MOVE_COST * 2;
				} else if (index < 12) {
					return FAR_COST;
				//} else if (index < 12) {
				//	return LONG_COST;
				} else if (index < 20) {
					return DIAGONAL_COST * 2;
				}
		}
	}
	function get_unsafe_cell(x_, y_) {
		var vec2 = snap(x_, y_);
		var xs = vec2.x, ys = vec2.y;
		var cell = get_unsafe(xs, ys);
		return cell
	}
	function get_move_cost(current_cell, neighbor, direction_index, mobility_type, mobility_cost) {
		var move_cost = get_direction_cost(direction_index);
		if (mobility_type == MOB_LAND && neighbor.height < 0) return -1;
		if (mobility_type == MOB_WATER && neighbor.height >= 0) return -1;
		if (mobility_type == MOB_LAND) {
			// Only care about going uphill
			var height_difference = max(0, neighbor.height - current_cell.height);
			var move_height_cost = power(mobility_cost * HEIGHT_COST * height_difference, HEIGHT_POWER);
			move_cost = move_cost + move_height_cost;
		}
		return move_cost;
	}
	function get_path(x1_, y1_, x2_, y2_, mobility_cost_, mobility_type_) {
		// Snap coordinates to grid, find starting cell
		var cell1 = get_unsafe_cell(x1_, y1_);
		if (cell1 == -1) return noone;
		var cell2 = get_unsafe_cell(x2_, y2_);
		if (cell2 == -1) return noone;
		if (!cell1.free || !cell2.free) return -1;
		if (cell1.equals(cell2)) return -1;
		// Init cells
		init_pathfinding();
		cell1.visited = true;
		cell1.visited_cost = 0;
		cell1.heuristic_value = cell_heuristic(cell1, cell2);
		
		// Do the magic
		var current_cell = cell1;
		var pathfinder = ds_priority_create();
		var iterations = 0;
		var direction_number = array_length(directions);
		while (!current_cell.equals(cell2)) {
			// Limit to 20k iterations of search
			if (iterations > ITERATION_LIMIT) {
				show_debug_message("Iteration limit exceeded");
				return noone;
			}
			for (var i = 0; i < direction_number; ++i) {
				var neighbor_vector = directions[i];
				var neighbor = get_unsafe(current_cell.x + neighbor_vector.x, current_cell.y + neighbor_vector.y);
				if (neighbor == -1) continue;
				
				if (neighbor.visited || !neighbor.free) continue;
				
				//var move_cost = get_direction_cost(i);
				//if (mobility_type_ == MOB_LAND && neighbor.height < 0) continue;
				//if (mobility_type_ == MOB_WATER && neighbor.height >= 0) continue;
				//if (mobility_type_ == MOB_LAND) {
				//	move_cost = move_cost + mobility_cost_ * HEIGHT_COST * max(0, neighbor.height - current_cell.height);
				//}
				//var neighbor_cost = move_cost + current_cell.visited_cost;
				var move_cost = get_move_cost(current_cell, neighbor, i, mobility_type_, mobility_cost_);
				if (move_cost < 0) {
					neighbor.visited = true;
					continue;
				}
				var neighbor_cost = current_cell.visited_cost + move_cost;
				var neighbor_heuristic = cell_heuristic(neighbor, cell2);
				neighbor.parent = current_cell;
				neighbor.visited_cost = neighbor_cost;
				neighbor.heuristic_value = neighbor_heuristic;
				neighbor.visited = true;
				
				var neighbor_score = neighbor_cost + neighbor_heuristic;
				
				cell_cost_max = max(neighbor_cost, cell_cost_max);
				cell_heuristic_max = max(neighbor_heuristic, cell_heuristic_max);
				cell_score_min = min(neighbor_score, cell_score_min);
				cell_score_max = max(neighbor_score, cell_score_max);
				
			    ds_priority_add(pathfinder, neighbor, neighbor_score);
			}
			if (ds_priority_size(pathfinder) > 0) {
				// Find neighbor cell with lowest score (lowest cost, lowest distance to target)
				current_cell = ds_priority_delete_min(pathfinder);
				++iterations;
			} else {
				break;
			}
		}
		show_debug_message("Iterations: " + string(iterations));
		build_path(path, cell1, current_cell);
		ds_priority_destroy(pathfinder);
		
		var path_array = list_to_array_reverse(path);
		return path_array;
	};
	function flood_fill(x1_, y1_, speed_, mobility_cost_, mobility_type_) {
		// Ensure no shenanigans
		if (speed_ < 1 or mobility_type_ < 0 or mobility_type_ > MOB_AIR) {
			show_debug_message("Invalid speed or mobility type");
			return noone;
		}
		// Get starting cell
		var cell1 = get_unsafe_cell(x1_, y1_);
		cell1.visited = true;
		cell1.visited_cost = 0;
		var pathfinder = ds_queue_create();
		var cells_visited = ds_list_create();
		ds_queue_enqueue(pathfinder, cell1);
		ds_list_add(cells_visited, cell1);
		var direction_number = array_length(directions);
		// Flood fill all possible paths from this point
		while (ds_queue_size(pathfinder) > 0) {
			var current_cell = ds_queue_dequeue(pathfinder);
			ds_list_add(cells_visited, current_cell);
			for (var i = 0; i < direction_number; ++i) {
				// Get neighbor
				var neighbor_vector = directions[i];
				var neighbor = get_unsafe(current_cell.x + neighbor_vector.x, current_cell.y + neighbor_vector.y);
				if (neighbor == -1 or neighbor.visited or !neighbor.free) continue;
				if (mobility_type_ == MOB_LAND && neighbor.height < 0) continue;
				if (mobility_type_ == MOB_WATER && neighbor.height >= 0) continue;
				
				var move_cost = get_direction_cost(i);
				if (mobility_type_ == MOB_LAND) {
					move_cost = move_cost + mobility_cost_ * HEIGHT_COST * max(0, neighbor.height - current_cell.height);
				}
				var neighbor_cost = move_cost + current_cell.visited_cost;
				// If neighbor cost is greater than speed, is outside our range
				if (neighbor_cost > speed_) continue;
				
				// Neighbor is worth visiting, mark it and add to queue
				neighbor.parent = current_cell;
				neighbor.visited_cost = neighbor_cost;
				neighbor.visited = true;
				ds_queue_enqueue(neighbor);
				
				//var neighbor_score = neighbor_cost + cell_heuristic(neighbor, cell2);
				//ds_priority_add(pathfinder, neighbor, neighbor_score);
			}
		}
		ds_queue_destroy(pathfinder);
		ds_list_destroy(cells_visited);
	}
	#endregion
}

function terrain_map_struct(
	terrain_sprite_, contour_sprite_, left_, top_, width_, length_,
	min_height_, max_height_, water_ratio_, color_min_, color_max_, color_water_
) : terrain_struct(0, 0, 1, 1, 1, GRID_SCALE) constructor {
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
		draw_surface_ext(terrain_surface,x,y,GRID_SCALE,GRID_SCALE,0,c_white,1);
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
				var height_ratio = color_get_red(color_value) / 255;
				var is_water = height_ratio < water_ratio;
				var h = is_water ? -1 : lerp(min_height, max_height, height_ratio);
				terrain_grid[# r, c] = new cell_struct(r,c,h,true);
			}
		}
		
		draw_terrain();
		draw_terrain_surface();
	}
}