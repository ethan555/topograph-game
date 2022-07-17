/// @description Draw self

draw_set_color(c_white);
var offset = 0; // GRID_SCALE/2;
for (var i = 1, len = array_length(path); i < len; ++i) {
  draw_line(path[i-1].x+offset,path[i-1].y+offset,path[i].x+offset,path[i].y+offset);
}
draw_sprite_ext(sprite_index,image_index,x+offset,y+offset,
	image_xscale,image_yscale,image_angle,image_blend,image_alpha);
