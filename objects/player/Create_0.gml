/// @description Init


// Inherit the parent event
event_inherited();

modules = [
	{
		charge: 3,
		recharge: {
			type: "manual",
			amount: 3
		},
		actions: [
			{
				name: "Shoot",
				icon: shoot_icon_sp,
				range: 30,
				target: "enemy",
				radius: 0,
				damage: 3,
				cost: 1,
				module: noone,
				priority: 0
			}
		]
	}
];
var actions_priority_queue = ds_priority_create();
var modules_length = array_length(modules);
for (var i = 0; i < modules_length; ++i) {
	var module = modules[i];
	var actions_array = module.actions;
	var actions_length = array_length(actions_array);
	
	for (var a = 0; a < actions_length; ++a) {
		var action = actions_array[a];
		action.module = module;
		ds_priority_add(actions_priority_queue, action, action.priority);
	}
}
actions = array_create(ds_priority_size(actions_priority_queue));
var i = 0;
while (ds_priority_size(actions_priority_queue) > 0) {
	actions[i++] = ds_priority_delete_min(actions_priority_queue);
}
ds_priority_destroy(actions_priority_queue);