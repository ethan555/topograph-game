function screenshake_add(amount_, time_){
	if (instance_exists(view_control)) {
		with (view_control) {
			if (screenshake_amount < amount_) {
				screenshake_amount = max(screenshake_amount, amount_);
				screenshake_time = max(screenshake_time, time_);
			}
		}
	}
}