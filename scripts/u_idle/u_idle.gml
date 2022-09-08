function u_idle() {

}

//function finish_action(energy_cost) {
//	energy -= energy_cost;
//	if (energy < 1) {
//		if (focused_unit == id) select_unit(noone);
//		state = U_DONE;
//	} else {
//		state = U_IDLE;
//		//if (focused_unit == id) unit_get_path();
//	}
//}

function change_state(new_state) {
	state = new_state;
	--energy;
	// Take energy for action
	//switch(new_state) {
	//	case U_MOVING:
	//		// 
	//		break;
	//	//case U_IDLE:
	//	//case U_DONE:
	//	//	break;
	//}
}

function finish_action() {
	if (energy < 1) {
		if (focused_unit == id) select_unit(noone);
		state = U_DONE;
	} else {
		if (focused_unit == id) reset_unit(id);
		state = U_IDLE;
	}
}