/// @description Draw control gui

if (instance_exists(focused_unit)) {
	// Draw focused unit actions
	//if (focused_unit.modules != noone and array_length(focused_unit.modules) > 0) {
	//	var module_length = array_length(focused_unit.modules);
	//	var half = module_length / 2;
	//	for (var i = 0; i < module_length; ++i) {
	//		var module = focused_unit.modules[i];
	//		var actions = module.actions;
	//		var actions_length = array_length(actions);
	//	    // Draw action icons
	//		for (var a = 0; a < actions_length; ++a) {
	//			var action = actions[a];
	//		    draw_sprite(action,)
	//		}
	//		draw_sprite()
	//	}
	//}
	var actions = focused_unit.actions;
	if (actions != noone and array_length(actions) > 0) {
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		var draw_x = display_get_gui_width() / 2;
		var draw_y = display_get_gui_height() - 24;
		var spacing = 24;
		var actions_length = array_length(actions);
		var half = (actions_length-1) / 2;
		for (var i = 0; i < actions_length; ++i) {
		    // Draw action icons
			var action = actions[i];
			var icon_x = draw_x + spacing * (i - half);
			draw_sprite(action.icon, 0, icon_x, draw_y);
			draw_text(icon_x, draw_y+1,string(i+1));
		}
	}
}

