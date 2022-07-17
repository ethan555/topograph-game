/// @description init_particles Initialize the particle systems
function init_particles() {

	globalvar part_system;
	part_system = part_system_create();
	//part_system_depth(part_system,EFFECT_DEPTH);

	globalvar part_spark,
		part_dust,
		part_dust_large,
		part_smoke,
		part_charge;
		//part_explosion1,
		//part_explosion2,
		//part_explosion3,
		//part_explosion4,
		//part_explosion5,
		//part_explosion6,
		//part_explosion7,
		//part_explosion8,
		//part_shieldhit,
		//part_armorhit,
		//part_scrap,
		//part_asteroid;

	part_spark = part_type_create();
	part_type_shape(part_spark,pt_shape_line);
	//part_type_sprite(part_spark,spark_sp,false,false,false);
	part_type_alpha3(part_spark,1,1,0);
	part_type_color_hsv(part_spark,0,0,0,0,240,255);
	part_type_direction(part_spark,0,360,.01,0);
	part_type_orientation(part_spark,0,0,0,0,true);
	part_type_size(part_spark,.2,.4,.05,0);
	part_type_speed(part_spark,5,10,-.25,0);
	//part_type_gravity(part_spark,.05,270);
	part_type_life(part_spark,seconds_to_frames(.1),seconds_to_frames(.3));
	//part_type_step(part_spark,1,part_trail);

	part_dust = part_type_create();
	part_type_shape(part_dust,pt_shape_cloud);
	part_type_size(part_dust,.1,.25,-.01,0);
	part_type_alpha2(part_dust,1,0);
	part_type_color_hsv(part_dust,0,0,0,0,240,255);
	part_type_direction(part_dust,0,359,.01,0);
	part_type_orientation(part_dust,0,359,.01,0,false);
	part_type_speed(part_dust,0,1,.01,0);
	part_type_gravity(part_dust,.01,270);
	part_type_life(part_dust,seconds_to_frames(.5),seconds_to_frames(1));

	part_dust_large = part_type_create();
	part_type_shape(part_dust_large,pt_shape_cloud);
	part_type_size(part_dust_large,.5,1,-.01,0);
	part_type_alpha2(part_dust_large,1,0);
	part_type_color_hsv(part_dust_large,0,0,0,0,240,255);
	part_type_direction(part_dust_large,0,359,.01,0);
	part_type_orientation(part_dust_large,0,359,.01,0,false);
	part_type_speed(part_dust_large,2,4,-.25,0);
	part_type_gravity(part_dust_large,.01,270);
	part_type_life(part_dust_large,seconds_to_frames(.4),seconds_to_frames(.5));

	part_charge = part_type_create();
	part_type_shape(part_charge,pt_shape_disk);
	part_type_size(part_charge,.03,.07,0,0);
	part_type_color_hsv(part_charge,0,0,0,0,255,255);
	part_type_direction(part_charge,90,90,0,0);
	part_type_speed(part_charge,1,5,.01,0);
	part_type_gravity(part_charge,0.01,90);
	part_type_life(part_charge,seconds_to_frames(.15),seconds_to_frames(.35));
	part_type_alpha2(part_charge,1,0);
	
	//part_explosion1 = part_type_create();
	//init_explosion(part_explosion1,explosion_1_sp);
	//part_explosion2 = part_type_create();
	//init_explosion(part_explosion2,explosion_2_sp);
	//part_explosion3 = part_type_create();
	//init_explosion(part_explosion3,explosion_3_sp);
	//part_explosion4 = part_type_create();
	//init_explosion(part_explosion4,explosion_4_sp);
	//part_explosion5 = part_type_create();
	//init_explosion(part_explosion5,explosion_5_sp);
	//part_explosion6 = part_type_create();
	//init_explosion(part_explosion6,explosion_6_sp);
	//part_explosion7 = part_type_create();
	//init_explosion(part_explosion7,explosion_7_sp);
	//part_explosion8 = part_type_create();
	//init_explosion(part_explosion8,explosion_8_sp);
	
	//part_shieldhit = part_type_create();
	//part_type_sprite(part_shieldhit,shield_hit_sp,true,true,false);
	//part_type_size(part_shieldhit,.9,1.1,0,0);
	////part_type_color_hsv(part_shieldhit,0,255,50,50,255,255);
	//part_type_direction(part_shieldhit,0,359,0,0);
	//part_type_orientation(part_shieldhit,0,359,0,0,false);
	//part_type_speed(part_shieldhit,0,.01,-.001,0);
	//part_type_alpha3(part_shieldhit,1,1,0);
	//part_type_life(part_shieldhit,10,10);
	
	//part_armorhit = part_type_create();
	//part_type_sprite(part_armorhit,armor_hit_sp,true,true,false);
	//part_type_size(part_armorhit,.8,1.2,0,0);
	////part_type_color_hsv(part_armorhit,0,255,50,50,255,255);
	//part_type_direction(part_armorhit,0,359,0,0);
	//part_type_orientation(part_armorhit,0,359,0,0,false);
	//part_type_speed(part_armorhit,0,.1,-.001,0);
	//part_type_alpha3(part_armorhit,1,1,0);
	//part_type_life(part_armorhit,30,30);
	
	//part_scrap = part_type_create();
	//part_type_sprite(part_scrap,scrap_small_sp,false,false,true);
	//part_type_size(part_scrap,1,5,0,0);
	////part_type_color_hsv(part_scrap,0,255,50,50,255,255);
	//part_type_direction(part_scrap,0,359,0,0);
	//part_type_orientation(part_scrap,0,359,0,0,false);
	//part_type_speed(part_scrap,5,10,-.01,0);
	//part_type_alpha3(part_scrap,1,1,0);
	//part_type_life(part_scrap,32,32);
	
	//part_asteroid = part_type_create();
	//part_type_sprite(part_asteroid,asteroid_small_sp,false,false,false);
	//part_type_size(part_asteroid,.25,.5,0,0);
	////part_type_color_hsv(part_asteroid,0,255,50,50,255,255);
	//part_type_direction(part_asteroid,0,359,0,0);
	//part_type_orientation(part_asteroid,0,359,0,0,false);
	//part_type_speed(part_asteroid,5,10,-.01,0);
	//part_type_alpha3(part_asteroid,1,1,0);
	//part_type_life(part_asteroid,32,32);
}
