/// @description Handle Input

if (keyboard_check_pressed(vk_backspace)) {
	// End Turn
	turn_manager.end_turn();
}

if (keyboard_check_pressed(vk_f11)) {
	debug = !debug;
}
	
if (keyboard_check_pressed(vk_f10)) {
	draw_contour_map = !draw_contour_map;
}

if (turn_manager.current_faction.index == FACTION_PLAYER) {
	if (keyboard_check_pressed(vk_tab)) {
		// Switch to next unit
		var switch_friendly = true;
		if (focused_unit != noone) {
			// Check if switching targeting
			if (focused_unit.state == U_TARGET) {
				switch_friendly = false;
			}
		}
	
		if (switch_friendly) {
			var new_focus = turn_manager.get_next_focus();
			select_unit(new_focus);
		} else {
			var target_number = ds_list_size(target_units);
			if (target_number > 0) {
				target_index = modulo(target_index+1, target_number);
				target_unit = target_units[| target_index];
			}
		}
	}
	
	if (mouse_check_button_pressed(mb_left)) {
		// Check GUI first
	
		// Check Units second
		var mpos = terrain_control.terrain.snap_center(mouse_x,mouse_y);
		var select_list = ds_list_create();
		var select_list_length = collision_point_list(mpos.x,mpos.y,unit,false,true,select_list,true);
		var new_focus = noone;
		if (select_list_length > 0) {
			for (var i = 0; i < select_list_length; ++i) {
			    // Select unit if viable
				var potential_focus = select_list[| i];
				var unit_selectable = focused_unit != potential_focus &&
					potential_focus.state == U_IDLE &&
					potential_focus.faction == turn_manager.current_faction.index; // && !potential_focus.moving;
				if (unit_selectable) {
					new_focus = potential_focus;
					break;
				}
			}
		}
		select_unit(new_focus);
		
		ds_list_destroy(select_list);
	}

	if (mouse_check_button_pressed(mb_right)) {
		if (!ds_map_empty(pathfind_map) && instance_exists(focused_unit) && focused_unit.state == U_IDLE) {
			var cell = terrain_control.terrain.get_unsafe_cell(mouse_x, mouse_y);
			var cpos = terrain_control.terrain.snap(focused_unit.x, focused_unit.y);
			if (!cell.equals(cpos) && ds_map_exists(pathfind_map, cell)) {
				set_path(focused_unit, cell);
				// ENSURE NO ONE ELSE CAN MOVE HERE
				//path = terrain_control.terrain.get_path(x, y, mouse_x, mouse_y, mobility_type, mobility_cost);
				//path_step = 0;
				ds_map_clear(pathfind_map);
				//focused_unit = noone;
			}
		}
	}

	if (instance_exists(focused_unit) and focused_unit.actions != noone) {
		var actions = focused_unit.actions;
		var actions_length = array_length(actions);
		for (var i = 0; i < 10; ++i) {
		    var key = ord(string(i));
			var key_number = i == 0 ? 10 : i;
			var action_number = key_number - 1;
			if (action_number > actions_length) continue;
			if (keyboard_check_pressed(key)) {
				// Execute action init
				var action = actions[action_number];
			}
		}
	}
}


