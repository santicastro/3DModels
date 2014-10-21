use <pulley.scad>
use <common.scad>
use <parametric_involute_gear_v5.0.scad>

$fn=60;

	gear1_teeth = 25;
	gear2_teeth = 8;
	axis_angle = 45;
    bore_diameter = 5.25;
	outside_circular_pitch=400;

	pulley_thickness = 6.6;
	ball_count = 10;

ball_bearing_height = 7 + 0.2;
ball_bearing_diameter = 22 + 0.5;
pulley1_ball_bearing_height = pulley_thickness/2-0.9;
echo("pulley1_ball_bearing_height",pulley1_ball_bearing_height);

pulley2_ball_bearing_height = ball_bearing_height-pulley1_ball_bearing_height;

show_big_pulley = false;
big_pulley_moved = 0; //0 false, 1 true
big_pulley_translation = [50 * big_pulley_moved, 0, -106 * big_pulley_moved];
big_pulley_rotation = [180 * big_pulley_moved, 0, 0];

show_half_pulley = false;
half_pulley_moved = 0; //0 false, 1 true
half_pulley_translation = [100 * half_pulley_moved, 0, 0];
half_pulley_rotation = [0, 0, 0];

show_small_gear = false;
small_gear_moved = 0; //0 false, 1 true
small_gear_translation = [150 * small_gear_moved, 0, 0];
small_gear_rotation = [0, -45 * small_gear_moved, 0];

show_chassis = true;

	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

	// GEARS
	rotate([0,0,90])
	translate ([0,0,pitch_apex1+20])
	{
		difference(){
			union(){
				translate(big_pulley_translation)rotate(big_pulley_rotation) 
				if(show_big_pulley){
					difference(){
						union(){
							// BIG GEAR
							translate([0,0,-pitch_apex1])
							difference(){
								intersection(){
									bevel_gear (
										number_of_teeth=gear1_teeth,
										cone_distance=cone_distance,
										pressure_angle=30,
										bore_diameter=8,
										outside_circular_pitch=outside_circular_pitch);
									cylinder(r1=27, r2=47, h=20);
								}
								translate([0, 0, 15.5-ball_bearing_height]){
									cylinder(d = ball_bearing_diameter, h = ball_bearing_height+1);
									mirror([0, 0, 1])cylinder(d1 = ball_bearing_diameter, d2 = 18, h = ball_bearing_diameter-18);
								}
							}
							difference() {
								union() {
								translate([0, 0, -50])
									difference(){ // PULLEYS UNION
										cylinder(r1=21, r2=21, h=10);
										translate([0, 0, -pulley_thickness + 1.2])cylinder(d = ball_bearing_diameter, h = ball_bearing_height);
									}
				
									translate([0, 0, -53])mirror([0, 0, 1])
									difference(){ // T O P    H A L F   P U L L E Y 
										half_pulley(ball_count, pulley_thickness);
										translate([0,0,-pulley_thickness/2]) cylinder(d=15, h=pulley_thickness/2); //ball bearing
										translate([0,0,-pulley2_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley2_ball_bearing_height); //ball bearing
									}
								}
								translate([0, 0, -53])mirror([0, 0, 1])
								for ( i = [0 : 3] ){ // screw hole
									rotate([0,0,90*i]) translate([14, 0, -10]) color("blue")
									cylinder(d=3, h=10);
								}	
							}
						}
						translate([0,0,-60])cylinder(d=18, h=50);
					}
				}
				if(show_half_pulley){
					translate(half_pulley_translation)rotate(half_pulley_rotation) 
					translate([0, 0, -53]) // B O T T O M    H A L F   P U L L E Y 
					difference(){ 
						half_pulley(ball_count, pulley_thickness);
						translate([0,0,-pulley_thickness/2]) cylinder(d=18, h=pulley_thickness/2); //ball bearing
						translate([0,0,-pulley1_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley1_ball_bearing_height); //ball bearing
						  
						for ( i = [0 : 3] ){ // screw hole with head
							rotate([0,0,90*i]) translate([14, 0, -pulley_thickness/2]) color("blue") 
							union(){
								cylinder(d=3, h=pulley_thickness);
								cylinder(d=3.4, h=0.4);
							}
						}
					}
				}
			}
			
		}

		//SMALL GEAR
		translate(small_gear_translation)rotate(small_gear_rotation)
rotate([0,0,-9]) 
		if(show_small_gear){
			rotate([0,(pitch_angle1+pitch_angle2),0])
			translate([0,0,-pitch_apex2])
			union(){
				bevel_gear (
					number_of_teeth=gear2_teeth,
					cone_distance=cone_distance,
					pressure_angle=30,
					outside_circular_pitch=outside_circular_pitch);
				translate([0,0,-6])
				rotate([0,0,22.5])difference(){
					cylinder(r=11, h=6);
					cylinder(d=bore_diameter, h=6);
					translate([-15,10,0])cube([30,10,6]);
					mirror([0,1,0])translate([-15,10,0])cube([30,10,6]);
					// screws
					translate([0,4,3])rotate([-90,0,0]) m3_hole();
					translate([0,-4,3])rotate([-90,0,180]) m3_hole();
				}
				
				if(small_gear_moved==0) translate([0,0,-42.2]) nema17(true, true, true);
			}
		}
	}
	wall_thick = 1.5;
	// chassis
	if(show_chassis){
		half_chassis();
		translate([61, 0, 0])mirror([1,0, 0])half_chassis();
		//translate([21, -50, 3])rotate([-90, 0, -90]){
		//	difference(){ union(){ cylinder(d=6, h=4); translate([-3, 0, 0])cube([6,5,4]);} cylinder(d=3.2, h=4); }
		//	translate([0, 0, 15]){ difference(){ union(){ cylinder(d=6, h=4); translate([-3, 0, 0])cube([6,5,4]);} cylinder(d=3.2, h=4); }}
		//}
	}
module half_chassis(){
	difference(){
		union(){
			difference(){
				union(){
translate([5,0,0])cube([17, 1.3, 15]);
translate([-22,0,0])cube([17, 1.3, 15]);

					difference(){
						cylinder(r=7, h=21.9);
						translate([0, 0, 1.2])
						cylinder(r=4.18, h=23);
					}
					translate([0, 7.5, 4])cube([8, 5, 10], center=true);
					cylinder_round(-7, 4, 1);
					translate([0,0,18])
						semiarc(21.5+0.8, 30, wall_thick, 180, 225) { 
							double_hole_border(wall_thick);
						};
				}
				translate([0, 5, 6])rotate([90, 0, 180])m3_hole();
			}
			translate([0,0,18])
				semiarc(21.5+0.8, 30, wall_thick, 10, 120) { 
					double_hole_border(wall_thick);
				};
				
			difference() {
				cube_semiarc(21.5, 31.15, wall_thick, 0, 360);
				translate([0,0,21])semiarc(21.5+0.8, 30, wall_thick, 0, 120) { square([pulley_thickness,pulley_thickness]); };
				translate([0,0,21])semiarc(21.5+0.8, 30, wall_thick, 180, 225) { square([pulley_thickness,pulley_thickness]); };
				translate([0, 25, 6])rotate([0,45,0])cube([6, 20, 6], center=true);
			}
			translate([31, 0, 0])
			cube_semiarc(8, 31.15, wall_thick, 90, 180);
			translate([-18.5, -26.7, 0]) color("red")
			cube_semiarc(9.5, 31.15, wall_thick, 55, 180);
		
			difference(){
			rotate([0, 0, -9])translate([0, -63.95, 13.45])
			union() {
				intersection(){
					rotate([-45, 0, 0])translate([2.5,2,17.5])cube([44, 42, 37], center=true);
					union(){
						translate([45/2-1, 11, -17]) difference(){
								cube([4, 8, 70]);
								translate([13, 9, 0]) cylinder(r=12, h=70);
							}
						rotate([-45, 0, 0])translate([0,0,17]) {
							translate([8, -22, 17]){ cube([15, 45, 2]); translate([-31,29,0])cube([35, 17, 2]);}
							difference(){translate([-10, 0, -19]) cube([20.3, 22, 2]); translate([0, 0, -20])cylinder(d=10, h=20);} 
							translate([-23, 21.3, -19]){ cube([46, 1.6, 36]);}
						}
					}
				}
				translate([-10, -0.5, -17])cube([1.2, 16, 16]);
				translate([9, -0.5, -17])cube([1.2, 16, 16]);

				translate([-19.5, 15, -17])cube([1.2, 26, 26]);
				translate([21.5, 11, -17])difference() {cube([1, 30, 26]); rotate([45, 0, 0])translate([0, 8, -2])cube([1, 30, 26]);};
				
			}
			rotate([0, 0, -9])translate([0, -63.95, 13.45])
				rotate([-45, 0, 0])nema17(true, true, true);
			}
			
			// B A C K G R O U N D
			translate([0, 0, -2.4]){
				cylinder(r=21.5+wall_thick, h=2.4);
				translate([31, 0, 0])	cylinder(r=8+wall_thick, h=2.4);
translate([0, -60, 0])
linear_extrude(height = 2.4)
	difference(){
		polygon(points=[
			[32, 60],
			[-8, 60],
			[-28-wall_thick, 36.5],
			[-28-wall_thick, -27],
			[-28-wall_thick, -49],
			[32, -49],
			[32, 20],
			[24, 20],
			[24, 40],
			[32, 40]
		]);
		//circle(r=12);
		polygon(points=[
			[-23, -20],
			[-23, -43],
			[28, -43],
			[28, -20]
		]);
	}
			}
		}
		translate([0, 0, -5-2.4])cube([200, 300, 10], center=true);
translate([0,0,-3])cylinder(r=3, h=5);
	}
}



module hole_border(size){
	translate([0, size, 0]) 
	union(){
		intersection(){
			circle(r=size, center=true);
			square([size,size]);
		}
		polygon(points=[[0, 0],[size, 0],[0, -size]]);
	}
}
module double_hole_border(base_size){
	union(){
		translate([base_size-0.8, 0, 0])hole_border(base_size);
		translate([0, pulley_thickness+base_size-0.8+1.5, 0])	
		hole_border(wall_thick+base_size-0.8);
	}
}