function approach(a, b, rate){
	var result = a;
	var diff = b - result;
	if (abs(diff) <= rate) return b;
	result += sign(diff) * rate;
	return result;
}

function approach_vector(x1, y1, x2, y2, speed_) {
	var dir = point_direction(x1,y1,x2,y2);
	var dist = min(point_distance(x1,y1,x2,y2), speed_);
	return new vector2(x1 + lengthdir_x(dist, dir), y1 + lengthdir_y(dist, dir));
}
