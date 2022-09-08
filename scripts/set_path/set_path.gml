//function set_path(unit_, cell_) {
function set_path(cell_) {
	path = terrain_control.terrain.build_path_flood(cell_);
	path_step = 0;
	get_path_if_idle();
	var dpos = terrain_control.terrain.vector2_to_world(cell_);
	dummy_ref = instance_create_depth(
		dpos.x,dpos.y,
		DUMMY_DEPTH, dummy
	);
	with (dummy_ref) {
		// TODO CHANGE UNIT FACTION FROM INDEX TO FACTION STRUCT
		faction = turn_manager.get_faction_from_index(other.faction);
		image_blend = faction.color;
		mobility_type = other.mobility_type;
	}
}

function unit_get_path() {
	ds_map_clear(pathfind_map);
	if (instance_exists(terrain_control)) {
		terrain_control.terrain.flood_fill(x,y,mobility_speed,mobility_type,mobility_cost);
	}
	path_drawn = false;
}