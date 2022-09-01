/// @description Draw terrain surface

terrain.draw_terrain_surface();
if (draw_contour_map) {
	terrain.draw_terrain_contour_surface();
}

// Draw to Sight Surface
if (!surface_exists(sight_surface)) {
	sight_surface = surface_create(terrain.width * FOG_SCALE, terrain.length * FOG_SCALE);
}

// Draw all dummies
with(dummy) {
	draw_self();
}

var unit_count = instance_number(unit);
surface_set_target(sight_surface);
draw_surface_ext(terrain_surface,0,0,FOG_SCALE,FOG_SCALE,0,c_white,1);
gpu_set_blendmode(bm_subtract);
//draw_clear_alpha(c_black, 1);
for (var i = 0; i < unit_count; ++i) {
    var u = instance_find(unit, i);
	if (u.faction != FACTION_PLAYER) {
		continue;
	}
	with (u) {
		// Draw sight orb
		var r1 = max(1,sight_radius-SIGHT_EDGE_RADIUS)*FOG_SCALE, r2 = sight_radius*FOG_SCALE;
		var ratio = FOG_SCALE / GRID_SCALE;
		//draw_set_color(c_white);
		////draw_circle(x,y,r1,false);
		//draw_circle_color(x*ratio,y*ratio,r2,c_black,c_white,false);
		draw_primitive_begin(pr_trianglestrip); // TODO HELPP
		var degree_increment = 10;
		for (var angle = 0; angle <= 360; angle+=degree_increment) {
			var dx1 = ratio*(x+lengthdir_x(r1,angle)),
				dy1 = ratio*(y+lengthdir_y(r1,angle));
			var dx2 = ratio*(x+lengthdir_x(r2,angle)),
				dy2 = ratio*(y+lengthdir_y(r2,angle));
		    draw_vertex_color(dx1,dy1,c_black,1);
		    draw_vertex_color(dx2,dy2,c_white,.5);
		}
		draw_primitive_end();
		draw_primitive_begin(pr_trianglestrip);
		for (var angle = 0; angle <= 360; angle+=degree_increment) {
			var dx1 = ratio*(x+lengthdir_x(r1,angle)),
				dy1 = ratio*(y+lengthdir_y(r1,angle));
			var dx2 = ratio*(x);//+lengthdir_x(r2,angle)),
				dy2 = ratio*(y);//+lengthdir_y(r2,angle));
		    draw_vertex_color(dx1,dy1,c_black,1);
		    draw_vertex_color(dx2,dy2,c_black,1);
		}
		draw_primitive_end();
	}
}
gpu_set_blendmode(bm_normal);

surface_reset_target();

// Draw units
for (var i = 0; i < unit_count; ++i) {
    var u = instance_find(unit, i);
	with (u) {
		if (focused_unit != id) {
			// Unfocused unit
			draw_unit(faction_color);
		} else {
			// Focused unit, draw outline
			draw_unit_outline(faction_color);
		}
	}
}

// Draw Fog of War surface
draw_surface_ext(sight_surface,0,0,GRID_SCALE / FOG_SCALE,GRID_SCALE / FOG_SCALE,0,c_gray,1);

// Draw path range
if (!ds_map_empty(pathfind_map)) {
	if (!surface_exists(path_surface)) {
		path_surface = surface_create(terrain.width, terrain.length);
	}
	if (!path_drawn) {
		surface_set_target(path_surface);
		draw_clear_alpha(c_white,0);
		var pathfind_map_cells = ds_map_keys_to_array(pathfind_map);
		var pathfind_map_length = ds_map_size(pathfind_map);
		for (var i = 0; i < pathfind_map_length; ++i) {
		    var pathfind_cell_id = pathfind_map_cells[i];
			var cell = pathfind_map[? pathfind_cell_id];
			//var cell = pathfind_cell;
			var cell_alpha = clamp(power(cell.cost / terrain.cell_cost_max, 2), 0, 1);
			draw_sprite_ext(rectangle_sp,0,cell.x,cell.y,1,1,0,c_white,cell_alpha);
		}
		surface_reset_target();
		path_drawn = true;
	}
	draw_surface_ext(path_surface,0,0,GRID_SCALE,GRID_SCALE,0,c_white,.25);
}

draw_mouse_pointer();

if (debug) {
	if (!surface_exists(debug_surface)) {
		debug_surface = surface_create(terrain.width, terrain.length);
	}
	if (!terrain.debug_drawn) {
		surface_set_target(debug_surface);
		draw_clear_alpha(c_white,0);
		var min_value = 0, max_value = 0;
		switch(debug_type) {
			case 0:
				min_value = 0;
				max_value = terrain.cell_cost_max;
				break;
			case 1:
				min_value = 0;
				max_value = terrain.cell_heuristic_max;
				break;
			case 2:
				min_value = terrain.cell_score_min;
				max_value = terrain.cell_score_max;
				break;
		}
		for (var i = 0; i < terrain.width; ++i) {
		    for (var j = 0; j < terrain.length; ++j) {
				var c = terrain.get(i,j);
				if (!c.visited) continue;
				var cc = 0;
				switch(debug_type) {
					case 0:
						cc = c.cost;
						break;
					case 1:
						cc = c.heuristic_value;
						break;
					case 2:
						cc = c.cost+c.heuristic_value;
						break;
				};
				var dc = make_color_hsv(0,255 * (cc - min_value) / (max_value - min_value),255);
				draw_sprite_ext(rectangle_sp,0,i,j,1,1,0,dc,1);
			}
		}
		surface_reset_target();
		terrain.debug_drawn = true;
	}
	draw_surface_ext(debug_surface,0,0,GRID_SCALE,GRID_SCALE,0,c_white,.5);
}
