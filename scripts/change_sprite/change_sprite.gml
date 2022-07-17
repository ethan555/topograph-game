/// @description change_sprite(sprite_array_index, index, ispd)
/// @param sprite_index_
/// @param index
/// @param ispd
function change_sprite(sprite_index_, index, ispd) {
	if (sprite_index_ != -1)
		sprite_index = sprite_index_;
	if (index != -1)
	    image_index = index;
	if (ispd != -1)
	    image_speed = ispd;
}
