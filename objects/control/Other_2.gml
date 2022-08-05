/// @description Init globals

globalvar debug;
debug = false;
if (debug) show_debug_overlay(true);

#region Resolution Setup
globalvar monitorw, monitorh, wmult, hmult;
monitorw = display_get_width();
monitorh = display_get_height();
window_set_size(monitorw, monitorh);
wmult = 1;
hmult = 1;
if (monitorw <= 1920/2 && monitorh <= 1080/2) {
	wmult = 1;
	hmult = 1;
}
surface_resize(application_surface, monitorw / wmult, monitorh / hmult);
display_set_gui_maximize();//monitorw / 2, monitorh / 2);
//window_set_fullscreen(true);
window_set_cursor(cr_none);
cursor_sprite = cursor_sp;
#endregion

#region Audio Setup
//audio_listener_orientation(0,0,1000,0,-1,0);
//audio_falloff_set_model(audio_falloff_linear_distance);
//audio_master_gain(.5);
#endregion

#region Room Control
globalvar room_return;
room_return = room;
#endregion

#region Player Stats
globalvar player_stats;
//player_stats = new player_stats_struct();

globalvar keybindings;
keybindings = new binding_struct();

globalvar in_combat, in_combat_timer;
in_combat = false;
in_combat_timer = 0;
#endregion

#region System Init
globalvar u_ratioWater, u_color1, u_color2, u_colorWater, u_colorValue;
u_ratioWater = shader_get_uniform(terrain_2_color_sh,"ratioWater");
u_color1 = shader_get_uniform(terrain_2_color_sh,"color1");
u_color2 = shader_get_uniform(terrain_2_color_sh,"color2");
u_colorWater = shader_get_uniform(terrain_2_color_sh,"colorWater");
u_colorValue = shader_get_uniform(terrain_2_color_sh,"colorValue");

globalvar draw_contour_map, contour_map_alpha;
draw_contour_map = false;
contour_map_alpha = .5;

globalvar turn_manager, turn_order, focused_unit, pathfind_map, path_drawn;
turn_manager = new turn_manager_struct();
pathfind_map = ds_map_create();
focused_unit = noone;
//turn_order = new turn_list_struct();

init_particles();
globalvar part_emitter;
part_emitter = part_emitter_create(part_system);
draw_set_font(display_font);

//if (!instance_exists(view_control)) {
//	instance_create_depth(x,y,0,view_control);
//}
//if (!instance_exists(grid_control)) {
//	instance_create_depth(x,y,0,grid_control);
//}
//if (!instance_exists(audio_player)) {
//	instance_create_depth(x,y,0,audio_player);
//}
//if (!instance_exists(background_drawer)) {
//	instance_create_depth(x,y,BACKGROUND_DEPTH,background_drawer);
//}
//if (!instance_exists(gui_drawer)) {
//	instance_create_depth(x,y,0,gui_drawer);
//}
#endregion

room_goto_next();
