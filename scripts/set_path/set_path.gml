function set_path(unit_, cell_) {
	with (unit_) {
		path = terrain_control.terrain.build_path_flood(cell_);
		path_step = 0;
		state = U_MOVING;
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
}