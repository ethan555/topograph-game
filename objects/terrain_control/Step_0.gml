/// @description Inputs
if (keyboard_check_pressed(220)) { // "\"
	debug_type = modulo(debug_type + 1, debug_types);
	terrain.debug_drawn = false;
}
