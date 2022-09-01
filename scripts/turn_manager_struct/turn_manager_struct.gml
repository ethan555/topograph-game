function turn_manager_struct() constructor {
	current_faction = noone;
	turn_list = noone;
	faction_units_map = noone;
	unit_index = 0;
	//target_index = 0;
	//current_units = noone;
	//faction_last_units = noone;
	
	
	function cleanup() {
		if (turn_list != noone) turn_list.cleanup();
		if (faction_units_map != noone) {
			// Destroy lists, map
			var faction_keys = ds_map_keys_to_array(faction_units_map);
			var faction_number = array_length(faction_keys);
			for (var i = 0; i < faction_number; ++i) {
				var faction = faction_keys[i];
				var faction_list = faction_units_map[? faction];
			    ds_list_destroy(faction_list);
			}
			ds_map_destroy(faction_units_map);
		}
		//if (faction_last_units != noone) ds_map_destroy(faction_last_units);
	}
	
	function new_map(faction_array) {
		// Initialize factions
		cleanup();
		unit_index = 0;
		turn_list = new turn_list_struct(faction_array);
		faction_units_map = init_faction_units_map(faction_array);
		
		//faction_last_units = init_faction_last_units(faction_array);
		get_next();
	}
	
	function init_faction_units_map(faction_array) {
		// Get list of faction units, init their states
		var faction_last_units = ds_map_create();
		var length = array_length(faction_array);
		for (var i = 0; i < length; ++i) {
			var faction = faction_array[i];
			//var faction_units_list = ds_list_create();
			var faction_units_list = get_unit_list(faction.index);
		    ds_map_add(faction_last_units, faction, faction_units_list);
		}
		return faction_last_units;
	}
	
	function get_unit_list(faction_index) {
		var unit_list = ds_list_create();
		var unit_number = instance_number(unit);
		for (var i = 0; i < unit_number; ++i) {
		    var u = instance_find(unit, i);
			if (u.faction == faction_index) {
				ds_list_add(unit_list, u);
			}
		}
		return unit_list;
		//var unit_array = list_to_array(unit_list);
		//ds_list_destroy(unit_list);
		//return unit_array;
	}
	
	function get_faction_units(next_faction) {
		// Get list of all units per faction
		//var faction_index = next_faction.index;
		var unit_list = faction_units_map[? next_faction];//get_unit_list(faction_index);
		return unit_list;
	}
	
	function end_turn() {
		// Get all current faction units, end their turns
		ds_map_clear(pathfind_map);
		focused_unit = noone;
		var current_faction = turn_list.get_current();
		var faction_index = current_faction.index;
		var unit_list = faction_units_map[? current_faction]; //get_unit_list(faction_index);
		var unit_number = ds_list_size(unit_list);
		for (var i = 0; i < unit_number; ++i) {
		    var u = unit_list[| i];
			end_unit(u);
		}
		get_next();
	}
	
	function end_unit(u) {
		// End unit state, variables
		with (u) {
			state = U_DONE;
			energy = 0;
		}
	}
	
	function ready_unit(u) {
		// Init unit state, variables
		with (u) {
			state = U_IDLE;
			energy = energy_max;
		}
	}
	
	function get_next() {
		//if (ds_list_exists(current_units)) ds_list_destroy(current_units);
		// Activate next turn
		var next_faction = turn_list.get_next();
		current_faction = next_faction;
		var faction_units = get_faction_units(next_faction);
		// Init faction units
		//var faction_unit_number = array_length(faction_units);
		var faction_unit_number = ds_list_size(faction_units);
		for (var i = 0; i < faction_unit_number; ++i) {
		    // Init state
			var u = faction_units[| i];
			ready_unit(u);
		}
		unit_index = 0;
	}
	
	function get_next_focus() {
		var faction_units = faction_units_map[? current_faction];
		var faction_unit_number = ds_list_size(faction_units);
		var current_index = unit_index;
		var next_focus = faction_units[| unit_index];
		unit_index = modulo(unit_index + 1, faction_unit_number);
		// Ensure next focus is selectable
		while (next_focus.state != U_IDLE and unit_index != current_index) {
			next_focus = faction_units[| unit_index];
			unit_index = modulo(unit_index + 1, faction_unit_number);
		}
		if (next_focus.state != U_IDLE) {
			next_focus = noone;
		}
		return next_focus;
	}
	
	function get_faction_from_index(faction_index) {
		return turn_list.get_faction_from_index(faction_index);
	}
}

function turn_list_struct(faction_array) constructor {
	index = 0;
	list = array_to_list(faction_array);
	
	function cleanup() {
		ds_list_destroy(list);
	}
	function initialize(faction_array) {
		cleanup();
		list = array_to_list(faction_array);
	}
	
	function get_current() {
		return list[| index];
	}
	
	function get_next() {
		var next_faction = list[| index];
		index = modulo(index+1, ds_list_size(list));
		return next_faction;
	}
	
	function kill_faction(faction) {
		var faction_index = ds_list_find_index(list, faction);
		if (faction_index != -1) {
			// Destroy all instances
			ds_list_delete(list, faction_index);
		}
	}
	
	function get_faction_from_index(faction_index) {
		var faction_number = ds_list_size(list);
		for (var i = 0; i < faction_number; ++i) {
		    var faction = list[| i];
			if (faction.index == faction_index) {
				return faction;
			}
		}
		return noone;
	}
}

function faction_struct(index_, color_, energy_) constructor {
	index = index_;
	color = color_;
	energy_max = energy_;
	energy = energy_;
}

function select_unit(new_focus) {
	if (focused_unit == new_focus) return;
	focused_unit = new_focus;
	ds_map_clear(pathfind_map);
	if (focused_unit != noone) {
		with (focused_unit) {
			terrain_control.terrain.flood_fill(x,y,mobility_speed,mobility_type,mobility_cost);
			path_drawn = false;
		}
	}
}