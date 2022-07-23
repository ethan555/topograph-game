/// @description Draw Debug GUI
if (debug) {
	draw_set_font(display_font);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var debug_view_text = "";
	switch(debug_type) {
		case 0:
			debug_view_text = "Current view: Visited Cell Cost";
			break;
		case 1:
			debug_view_text = "Current view: Visited Cell Heuristic to Destination";
			break;
		case 2:
			debug_view_text = "Current view: Visited Cell Score";
			break;
	}
			
	draw_text(5,5,debug_view_text);
	draw_text(5,15,"Max visited cost: " + string(terrain.cell_cost_max));
	draw_text(5,25,"Max calculated heuristic: " + string(terrain.cell_heuristic_max));
	draw_text(5,35,"Min cell score: " + string(terrain.cell_score_min));
	draw_text(5,45,"Max cell score: " + string(terrain.cell_score_max));
}
