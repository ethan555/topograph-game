function screenshake_distance(amount, time){
	if (instance_exists(player)) {
		var dist_ratio = power(min(1, (camera_get_view_width(view_camera[0]) * .5) / point_distance(x,y,player.x,player.y)), 2);
		var shake_amount = amount * dist_ratio
		var shake_time = time * dist_ratio;
			
		screenshake_add(shake_amount, shake_time);
	}
}