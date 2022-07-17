/// @description modulo_base(number, modulator, base)
/// @param number
/// @param modulator
function modulo_base(number_, modulator_, base_) {
	//(a % b + b) % b, min base_
	var result = max(base_, ((number_ mod modulator_) + modulator_) mod modulator_);
	return result;
}
