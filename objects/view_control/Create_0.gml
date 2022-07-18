/// @description Init view
view_enabled = true;
view_set_visible(0, true);
view_set_camera(0, camera_create_view(0, 0, start_width, start_height));

display_set_gui_size(camera_get_view_width(view_camera[0]) / wmult, camera_get_view_height(view_camera[0]) / hmult);

//if (instance_exists(cursor)) {
	//var mx = cursor.x;
	//var my = cursor.y;
	var mx = mouse_x, my = mouse_y;
	var dw = zoom * start_width/2;
	var dh = zoom * start_height/2;
	if (
		mx < x - dw or
		mx > x + dw
	) {
		x = mx
	}
	if (
		my < y - dh or
		my > y + dh
	) {
		y = my
	}
	
	view_offset_x = 0;
	view_offset_y = 0;
	
	//Get new sizes by interpolating current and target zoomed size
	var new_w = zoom * start_width;
	var new_h = zoom * start_height;
	//Apply the new size
	camera_set_view_size(view_camera[0], new_w, new_h);
	
	var cam_w = new_w * .5;
	var cam_h = new_h * .5;
	
	var new_x = x - cam_w;
	var new_y = y - cam_h;
	
	
	camera_set_view_pos(view_camera[0], new_x, new_y);
	camera_apply(view_camera[0]);
//}