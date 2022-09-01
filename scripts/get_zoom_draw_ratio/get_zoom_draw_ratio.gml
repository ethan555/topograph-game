function get_zoom_draw_ratio() {
	var draw_scale = 1;
	if (instance_exists(view_control)) {
		draw_scale = max(1, view_control.zoom_lerped / 2);
	}
	return draw_scale;
}