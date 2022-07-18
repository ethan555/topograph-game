/// @description Generate terrain

terrain = new terrain_map_struct(terrain_sprite,contour_sprite,128,128,128,128,height_min,height_max,water_ratio,color1,color2,color_water);
terrain.initialize();

dirs = [
	new vector2(0,-1), new vector2(-1,0), new vector2(1,0), new vector2(0, 1),
	new vector2(-1,-1), new vector2(1,-1), new vector2(-1,1), new vector2(1, 1),
	new vector2(-1,-2), new vector2(1,-2), new vector2(-2,-1), new vector2(2, -1), new vector2(-2,1), new vector2(2,1), new vector2(-1,2), new vector2(1, 2)
];

function draw_terrain_surface() {
	with (terrain) {
		draw_terrain_surface();
	}
}

function draw_mouse_pointer() {
	var mx = mouse_x, my = mouse_y;
	var mpos = terrain.snap_draw(mx, my);
	draw_set_color(c_white);
	draw_rectangle(mpos.x,mpos.y,mpos.x+scale,mpos.y+scale,true);
}
