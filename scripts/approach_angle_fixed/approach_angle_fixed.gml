function approach_angle_fixed(a, b, turn_rate, angle_origin) {
	var angle_result = a;
	var angle_diff = angle_difference(b, angle_result);
	if (abs(angle_diff) <= turn_rate) return b;
	var angle_change = sign(angle_diff);
	var a_origin = angle_difference(angle_origin,a);
	var b_origin = angle_difference(b,angle_origin);
	var angle_good = abs(a_origin + b_origin) < 180;
	if (!angle_good) angle_change = sign(a_origin);
	angle_result += angle_change * turn_rate;
	return angle_result;
}