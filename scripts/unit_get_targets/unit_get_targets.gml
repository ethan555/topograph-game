function target_struct(instance_, hit_chance_) constructor {
	instance = instance_;
	hit_chance = hit_chance_;
}

function unit_get_targets() {
	// Get the list of targets
	ds_list_clear(target_units);
	var unit_list = ds_list_create();
	var target_priority_list = ds_priority_create();
	var cover_list = ds_list_create();
	
	var height = terrain_control.terrain.get_height_raw(x,y);
	
	var unit_number = collision_circle_list(x,y,sight_radius*FOG_SCALE,unit,false,true,unit_list,false);
	for (var i = 0; i < unit_number; ++i) {
	    var u = unit_list[| i];
		// Check unit is not a friendly
		if (u.faction == faction) continue;
		var distance = point_distance(x,y,u.x,u.y) / FOG_SCALE;
		if (distance > sight_radius) continue;
		// Check unit not blocked by wall
		if (collision_line(x,y,u.x,u.y,wall,false,true)) continue;
		
		// Calculate chance to hit
		var target_height = terrain_control.terrain.get_height_raw(u.x,u.y);
		var height_bonus = clamp(height - target_height, 0, HEIGHT_BONUS_MAX);
		// Get max cover
		ds_list_clear(cover_list);
		var cover_number = collision_line_list(x,y,u.x,u.y,cover,false,true,cover_list,false);
		var max_cover = 0;
		for (var j = 0; j < cover_number; ++j) {
		    var c = cover_list[| c];
			max_cover = max(max_height, c.height);
		}
		// Get range bonus
		var range_bonus = 4*(aim_range - distance);
		
		var hit_score = aim + range_bonus + height_bonus - u.defence;
		
		var hit_chance = clamp(hit_score,0,100);
		
		var target = new target_struct(u, hit_chance);
		ds_priority_add(target_priority_list, target, hit_chance);
	}
	
	var target_number = ds_priority_size(target_priority_list);
	for (var i = 0; i < target_number; ++i) {
		var t = ds_priority_delete_max(target_priority_list);
	    ds_list_add(target_units,t);
	}
	
	ds_list_destroy(unit_list);
	ds_priority_destroy(target_priority_list);
	ds_list_destroy(cover_list);
}