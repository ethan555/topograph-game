function lerp_angle(a, b, value) {
	var diff = angle_difference(b, a);
	return a + diff * value;
}