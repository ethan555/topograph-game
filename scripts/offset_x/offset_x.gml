function offset_x(x_,x_offset_,y_offset,angle_){
	return x_ + lengthdir_x(x_offset_, angle_) + lengthdir_x(y_offset, 270+angle_);
}