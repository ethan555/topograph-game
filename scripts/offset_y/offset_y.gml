function offset_y(y_,x_offset_,y_offset,angle_) {
	return y_ + lengthdir_y(x_offset_, angle_) + lengthdir_y(y_offset, 270+angle_);
}