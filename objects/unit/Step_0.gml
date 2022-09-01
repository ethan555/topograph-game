/// @description Handle Movement
switch(state) {
	case U_DONE:
		// Do nothing
	case U_IDLE:
		// Wait for input
		break;
	case U_MOVING:
		//get_path_if_idle();
		move();
		break;
	case U_ACTION:
		// Perform action
		break;
	case U_DEATH:
		// Perform death animation
		break;
}
