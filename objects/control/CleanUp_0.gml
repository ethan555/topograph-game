/// @description Clean up

turn_manager.cleanup();
delete turn_manager

ds_map_destroy(pathfind_map);
ds_list_destroy(target_units);

if (surface_exists(terrain_surface)) surface_free(terrain_surface);
if (surface_exists(contour_surface)) surface_free(contour_surface);
if (surface_exists(debug_surface)) surface_free(debug_surface);
if (surface_exists(path_surface)) surface_free(path_surface);
if (surface_exists(fog_surface)) surface_free(fog_surface);
if (surface_exists(sight_surface)) surface_free(sight_surface);
