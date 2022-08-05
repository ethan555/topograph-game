// WHY WAS THIS NOT A FUNCTION ALREADY?????
function list_to_array(ind) {
	var length = ds_list_size(ind);
	var array = array_create(length);
	for (var i = 0; i < length; ++i) {
	    array[i] = ind[| i];
	}
	return array;
}

function list_to_array_reverse(ind) {
	var length = ds_list_size(ind);
	var start_index = length - 1;
	var array = length;
	for (var i = start_index, j = 0; i >= 0; --i) {
		var cell = ind[| i];
	    array[j++] = cell;
	}
	return array;
}

function array_to_list(array) {
	var list = ds_list_create();
	var length = array_length(array);
	for (var i = 0; i < length; ++i) {
	    ds_list_add(list, array[i]);
	}
	return list;
}