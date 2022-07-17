function move() {
	if (moving) {
		var move_dir = point_direction(x,y,dest_x,dest_y);
		image_angle = approach_angle(image_angle, move_dir, turn_rate);
		x = approach(x, dest_x, spd);
		y = approach(y, dest_y, spd);
		if (x == dest_x && y == dest_y) {
			moving = false;
		}
		return true;
	}

	if (path != -1) {
		if (path_step < array_length(path)) {
			var next_cell = path[path_step];
			dest_x = next_cell.x;
			dest_y = next_cell.y;
			moving = true;
			path_step ++;
			return true;
		} else {
			path_step = 0;
			delete path;
			path = -1;
			return false;
		}
	}
	return false;
}