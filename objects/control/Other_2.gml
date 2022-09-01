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

globalvar focus_color, target_color;
focus_color = c_white;
target_color = c_red;

// Outline draw setup
globalvar outline_surface, outline_texture, texel_width, texel_height,
	u_outline_color, u_pixel_width, u_pixel_height;
outline_surface = noone;
outline_texture = noone;
texel_width = 1;
texel_height = 1;
u_outline_color = shader_get_uniform(outline_border_sh, "outline_color");
u_pixel_width = shader_get_uniform(outline_border_sh, "pixel_width");
u_pixel_height = shader_get_uniform(outline_border_sh, "pixel_height");

// Contour map setup
globalvar u_terrace_number, u_contour_color, u_contour_texel_width, u_contour_texel_height;
u_terrace_number = shader_get_uniform(terrain_terrace_contour_sh, "terrace_number");
u_contour_color = shader_get_uniform(terrain_terrace_contour_sh, "contour_color");
u_contour_texel_width = shader_get_uniform(terrain_terrace_contour_sh, "pixel_width");
u_contour_texel_height = shader_get_uniform(terrain_terrace_contour_sh, "pixel_height");

// Terrain surfaces
globalvar terrain_surface, contour_surface, debug_surface, path_surface, fog_surface, sight_surface;
terrain_surface = noone;
contour_surface = noone;
debug_surface = noone;
path_surface = noone;
fog_surface = noone;
sight_surface = noone;

globalvar draw_contour_map, contour_map_alpha;
draw_contour_map = false;
contour_map_alpha = .5;

globalvar turn_manager, turn_order, focused_unit, target_unit, target_index,
	target_units, pathfind_map, path_drawn;
turn_manager = new turn_manager_struct();
pathfind_map = ds_map_create();
focused_unit = noone;
target_unit = noone;
target_index = 0;
target_units = ds_list_create();

//globalvar control_state, control_targets;
//control_targets = ds_list_create();
//control_state = C_IDLE;

//globalvar action_icons;
//action_icons = array_create();
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
