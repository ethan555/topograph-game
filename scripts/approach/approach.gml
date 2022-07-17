function approach(a, b, rate){
	var result = a;
	var diff = b - result;
	if (abs(diff) <= rate) return b;
	result += sign(diff) * rate;
	return result;
}