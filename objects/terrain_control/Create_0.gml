/// @description Generate terrain

terrain = new terrain_map_struct(terrain_sprite,contour_sprite,left,top,width,length,height_min,height_max,water_ratio,color1,color2,color_water);
terrain.initialize();

function draw_mouse_pointer() {
	var mx = mouse_x, my = mouse_y;
	var mpos = terrain.snap_draw(mx, my);
	draw_set_color(c_white);
	draw_rectangle(mpos.x,mpos.y,mpos.x+scale,mpos.y+scale,true);
}
