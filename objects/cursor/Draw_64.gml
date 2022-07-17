/// @description Draw cursor
var cx = camera_get_view_x(view_camera[0]), cy = camera_get_view_y(view_camera[0]);
var cw = camera_get_view_width(view_camera[0]), ch = camera_get_view_height(view_camera[0]);
var dx = x - cx, dy = y - cy;
var dpx = dx / cw, dpy = dy / ch;

var drawx = dpx * display_get_gui_width(), drawy = dpy * display_get_gui_height();

draw_sprite(sprite_index,image_index,drawx,drawy);
