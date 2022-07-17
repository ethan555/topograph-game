function approach_angle(a, b, turn_rate){
	var angle_result = a;
	var angle_diff = angle_difference(b, angle_result);
	if (abs(angle_diff) <= turn_rate) return b;
	angle_result += sign(angle_diff) * turn_rate;
	return angle_result;
}