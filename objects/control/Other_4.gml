/// @description Create view
//play_on = false;
if (!instance_exists(view_control)) {
	instance_create_depth(x,y,0,view_control);
}
//if (!instance_exists(cursor)) {
//	instance_create_depth(x,y,0,cursor);
//}
//play_on = true;
//set_turn_order();
//var first = turn_order.dequeue();
//with (first.id) {
//	active = true;
//	actions = max_actions;
//	spd = max_spd;
//	grid_control.grid.get_flood_cells(selectable_cells, x, y, actions);
//}