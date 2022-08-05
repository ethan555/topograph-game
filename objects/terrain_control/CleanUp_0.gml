/// @description Clean up resources
with (terrain) {
	cleanup();
}
if (surface_exists(terrain_surface)) {
	surface_free(terrain_surface);
}
if (surface_exists(path_surface)) {
	surface_free(path_surface);
}
if (surface_exists(debug_surface)) {
	surface_free(debug_surface);
}