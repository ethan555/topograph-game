function turn_manager_struct() constructor {
	turn_list = noone;
	faction_last_units = noone;
	
	
	function cleanup() {
		if (turn_list != noone) turn_list.cleanup();
		if (faction_last_units != noone) ds_map_destroy(faction_last_units);
	}
	
	function new_map(faction_array) {
		cleanup();
		turn_list = new turn_list_struct(faction_array);
		faction_last_units = init_faction_last_units(faction_array);
	}
	
	function init_faction_last_units(faction_array) {
		var faction_last_units = ds_map_create();
		var length = array_length(faction_array);
		for (var i = 0; i < length; ++i) {
		    ds_map_add(faction_last_units, faction_array[i], noone);
		}
		return faction_last_units;
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
	
	function get_next() {
		var next_faction = list[index];
		index = modulo(index+1, ds_list_size(list));
		return next_faction;
	}
	
	function kill_faction(faction) {
		var faction_index = ds_list_find_index(list, faction);
		if (faction_index != -1) {
			ds_list_delete(list, faction_index);
		}
	}
}

function faction_struct(color_, energy_) constructor {
	color = color_;
	energy_max = energy_;
	energy = energy_;
}
