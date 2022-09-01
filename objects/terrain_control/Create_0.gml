/// @description Generate terrain

terrain = new terrain_map_struct(
	terrain_sprite,left,top,width,length,
	height_min,height_max,water_ratio,
	color1,color2,color_water,color_value,
	terrace_number,contour_color
);
terrain.initialize();

function draw_mouse_pointer() {
	var mx = mouse_x, my = mouse_y;
	var mpos = terrain.snap_draw(mx, my);
	var mcell = terrain.get_unsafe_cell(mx, my);
	if (!ds_map_empty(pathfind_map)) {
		var mcell_in = ds_map_exists(pathfind_map, mcell);
		if (mcell != noone && mcell_in) {
			var ccell = pathfind_map[? mcell];
			// Draw path back to parent
			var pcell = mcell.parent;
			var stop = 0;
			while (pcell != noone) {
				stop += 1;
				if (stop > 1000) {
					show_debug_message("PATH DRAW DEPTH EXCEEDED 1000");
					break;
				}
				var cpos = terrain.vector2_to_world(ccell);
				var ppos = terrain.vector2_to_world(pcell);
				var pdir = point_direction(cpos.x, cpos.y, ppos.x, ppos.y);
				var pdist = point_distance(cpos.x, cpos.y, ppos.x, ppos.y);
				draw_sprite_ext(rectangle_sp, 0, cpos.x, cpos.y,
					pdist, 1, pdir, c_white, 1);
				ccell = ccell.parent;
				//mcell = mcellpathfind;
				pcell = ccell.parent;
			}
		}
	}
	draw_set_color(c_white);
	draw_rectangle(mpos.x,mpos.y,mpos.x+scale-1,mpos.y+scale-1,true);
}
