function get_path_next_step() {
	if (path != noone) {
		// If path is set, follow it
		if (path_step < array_length(path)) {
			// Have not traversed entire path
			var next_cell = path[path_step];
			dest_x = next_cell.x;
			dest_y = next_cell.y;
			moving = true;
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

function get_path_if_idle() {
	// If not moving, check if path is set
	if (!moving) {
		moving = get_path_next_step();
	}
}

function move() {
	// If path defined, follow
	if (moving) {
		var move_dir = point_direction(x,y,dest_x,dest_y);
		image_angle = approach_angle(image_angle, move_dir, turn_rate);
		var move_vector = approach_vector(x,y,dest_x,dest_y,spd);
		x = move_vector.x;
		y = move_vector.y;
		delete move_vector;
		if (x == dest_x && y == dest_y) {
			moving = get_path_next_step();
		}
		return true;
	}
	return false;
}