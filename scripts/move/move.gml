function get_path_next_step() {
	if (path != noone) {
		// If path is set, follow it
		if (path_step < array_length(path)) {
			// Have not traversed entire path
			var next_cell = path[path_step];
			dest_x = next_cell.x;
			dest_y = next_cell.y;
			//moving = true;
			path_step ++;
			return true;
		} else {
			// Have finished path, reset
			path_step = 0;
			delete path;
			path = noone;
			return false;
		}
	}
}

//function get_path_if_idle() {
//	// If not moving, check if path is set
//	if (!moving) {
//		moving = get_path_next_step();
//	}
//}

function get_path_if_idle() {
	// If not moving, check if path is set
	var moving = get_path_next_step();
	if (!moving) {
		//finish_action(1);
		finish_action();
	}
}

//function move() {
//	// If path defined, follow
//	if (moving) {
//		var move_dir = point_direction(x,y,dest_x,dest_y);
//		image_angle = approach_angle(image_angle, move_dir, turn_rate);
//		var move_vector = approach_vector(x,y,dest_x,dest_y,spd);
//		x = move_vector.x;
//		y = move_vector.y;
//		delete move_vector;
//		if (x == dest_x && y == dest_y) {
//			moving = get_path_next_step();
//		}
//		return true;
//	}
//	return false;
//}

function set_moving(destination_cell) {
	//var cell = terrain_control.terrain.get_unsafe_cell(mouse_x, mouse_y);
	//var cpos = terrain_control.terrain.snap(focused_unit.x, focused_unit.y);
	var cpos = terrain_control.terrain.snap(x, y);
	if (!destination_cell.equals(cpos) && ds_map_exists(pathfind_map, destination_cell)) {
		change_state(U_MOVING);
		set_path(destination_cell);
		// ENSURE NO ONE ELSE CAN MOVE HERE
		//path = terrain_control.terrain.get_path(x, y, mouse_x, mouse_y, mobility_type, mobility_cost);
		//path_step = 0;
		//ds_map_clear(pathfind_map);
		//focused_unit = noone;
		reset_none();
	}
}

function move() {
	// If path defined, follow
	var moving = true;
	var move_dir = point_direction(x,y,dest_x,dest_y);
	draw_angle = approach_angle(draw_angle, move_dir, turn_rate);
	var move_vector = approach_vector(x,y,dest_x,dest_y,spd);
	x = move_vector.x;
	y = move_vector.y;
	delete move_vector;
	if (x == dest_x && y == dest_y) {
		moving = get_path_next_step();
	}
	if (!moving) {
		if (dummy_ref != noone) {
			instance_destroy(dummy_ref);
		}
		//finish_action(1);
		finish_action();
	}
}