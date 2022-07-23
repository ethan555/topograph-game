/// @description Handle player input
// Zoom in and out
zoom = clamp(zoom + (((mouse_wheel_down() - mouse_wheel_up())) * zoom_rate), zoom_min, zoom_max);
	
// Handle screenshake
var screenshake_x = 0, screenshake_y = 0;
if (screenshake_time > 0) {
	screenshake_x = random_gauss(0,sqrt(screenshake_amount * zoom));
	screenshake_y = random_gauss(0,sqrt(screenshake_amount * zoom));
	screenshake_time = max(0, screenshake_time - 1);
} else {
	screenshake_amount = 0;
}
	
// Cursor control
//var mx = cursor.x;
//var my = cursor.y;
var mx = mouse_x, my = mouse_y;
var dw = zoom * start_width/2 - move_margin;
var dh = zoom * start_height/2 - move_margin;
	
var move_speed = move_rate * zoom;
if (
	mx <= x - dw or
	mx >= x + dw
) {
	var s_x = sign(mx - x);
	target_x += s_x * move_speed;
}
if (
	my <= y - dh or
	my >= y + dh
) {
	var s_y = sign(my - y);
	target_y += s_y * move_speed;
}
	
// WASD
var up = keyboard_check(keybindings.up),
	down = keyboard_check(keybindings.down),
	left = keyboard_check(keybindings.left),
	right = keyboard_check(keybindings.right);
	
var mv = -up + down, mh = -left + right;
target_x += mh * move_speed;
target_y += mv * move_speed;
	
var r = keyboard_check_pressed(keybindings.reset);
if (r) {
	zoom = zoom_start;
	target_x = start_width / 2;
	target_y = start_height / 2;
}

// Bind target position
target_x = clamp(target_x,x_min,x_max);
target_y = clamp(target_y,y_min,y_max);
	
var t_x = lerp(x, target_x, lerp_rate), t_y = lerp(y, target_y, lerp_rate);
	
var xx = t_x + screenshake_x,
	yy = t_y + screenshake_y;
	
var view_w = camera_get_view_width(view_camera[0]);
var view_h = camera_get_view_height(view_camera[0]);
	
//Get new sizes by interpolating current and target zoomed size
var new_w = lerp(view_w, zoom * start_width, zoom_lerp_rate);
var new_h = lerp(view_h, zoom * start_height, zoom_lerp_rate);
	
//Apply the new size
camera_set_view_size(view_camera[0], new_w, new_h);
	
// Find new camera coordinates
var cam_w = new_w * .5;
var cam_h = new_h * .5;
	
var new_x = xx - cam_w;
var new_y = yy - cam_h;
x = xx;
y = yy;
	
// Update view position
camera_set_view_pos(view_camera[0], new_x, new_y);
