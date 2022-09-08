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
	
	// Draw targets
	var target_number = ds_list_size(target_units);
	for (var i = 0; i < target_number; ++i) {
	    var target = target_units[| i];
		var u = target.instance;
		var hit_chance = target.hit_chance;
		
		// Draw sprite
		var dh = display_get_gui_height();
		var cx = camera_get_view_x(view_camera[0]), cy = camera_get_view_y(view_camera[0]);
		var cw = camera_get_view_width(view_camera[0]), ch = camera_get_view_height(view_camera[0]);
		var dx = u.x - cx,
			dy = u.y - cy;
		var dpx = dx / cw, dpy = dy / ch;
		var drawx = dpx * display_get_gui_width(), drawy = dpy * dh;
		
		var scale = 1;
		draw_sprite_ext(target_sp,0,drawx,drawy,scale,scale,0,c_red,1);
		
		// Draw hit chance
		draw_set_font(display_font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		
		var hit_text = string(floor(hit_chance)) + "%";
		var text_y = drawy + 8;
		draw_text_transformed(drawx,text_y,hit_text,.5,.5,0);
		//draw_text(drawx,drawy + 10,string(hit_chance) + "%");
		
		// Draw stylized unit
		var dux = 10 + i * 8, duy = dh - 30;
		draw_sprite_ext(u.sprite_index,0,dux,duy,.5,.5,0,c_red,.75);
	}
	
	// Draw actions
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

