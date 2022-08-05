/// @description Draw self

draw_set_color(c_white);
var offset = 0; // GRID_SCALE/2;
for (var i = 1, len = array_length(path); i < len; ++i) {
  draw_line(path[i-1].x+offset,path[i-1].y+offset,path[i].x+offset,path[i].y+offset);
}
var d_scale = 1;
if (instance_exists(view_control)) {
	d_scale = max(1, view_control.zoom_lerped / 2);
}
draw_sprite_ext(sprite_index,0,x+offset,y+offset,
	d_scale,d_scale,image_angle,image_blend,image_alpha);
draw_sprite_ext(sprite_index,1,x+offset,y+offset,
	d_scale,d_scale,image_angle,faction_color,image_alpha);
