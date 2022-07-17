function outside_room(){
	return x < 0 || x >= room_width || y < 0 || y >= room_height;
}