/// @description Debug mode

if (keyboard_check_pressed(vk_f11)) {
	debug = !debug;
}

if (keyboard_check_pressed(vk_tab)) {
	draw_contour_map = !draw_contour_map;
}

if (mouse_check_button_pressed(mb_left)) {
	// Check GUI first
	
	// Check Units second
	var select_list = ds_list_create();
	var select_list_length = collision_point_list(mouse_x,mouse_y,unit,false,true,select_list,true);
	if (select_list_length > 0) {
		//for (var i = 0; i < select_list_length; ++i) {
		focused_unit = select_list[| 0];
		with (focused_unit) {
			terrain_control.terrain.flood_fill(x,y,mobility_speed,mobility_type,mobility_cost);
			path_drawn = false;
		//}
		}
	}
	ds_list_destroy(select_list);
}
