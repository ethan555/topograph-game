/// @description modulo(number,modulator)
/// @param number
/// @param modulator
function modulo(number_, modulator_) {
	//(a % b + b) % b
	var result = ((number_ mod modulator_) + modulator_) mod modulator_;
	return result;
}
