function reduce(a, b) {
	var a_sign = sign(a);
	var result = a - b;
	if (sign(result) != a_sign) {
		result = 0;
	}
	return result;
}