use <pulley.scad>
use <common.scad>
use <parametric_involute_gear_v5.0.scad>

show_gears=true;

	gear1_teeth = 25;
	gear2_teeth = 8;
	axis_angle = 45;
    bore_diameter = 5.25;
	outside_circular_pitch=400;

	pulley_thickness = 6.6;
	ball_count = 10;

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

	if(show_gears){
		// GEARS
		rotate([0,0,90])
		translate ([0,0,pitch_apex1+20])
		{
			// BIG GEAR
			translate([0,0,-pitch_apex1])
			intersection(){
			bevel_gear (
				number_of_teeth=gear1_teeth,
				cone_distance=cone_distance,
				pressure_angle=30,
				bore_diameter=8,
				outside_circular_pitch=outside_circular_pitch);
			cylinder(r1=27, r2=47, h=20);
			}
			translate([0, 0, -50])cylinder(r1=21, r2=21, h=10);
			translate([0, 0, -53]) mirror([0, 0, 1]) {
				half_pulley(ball_count, pulley_thickness);
				mirror([0, 0, 1])half_pulley(ball_count, pulley_thickness);
			}
			
			//SMALL GEAR
			rotate([0,(pitch_angle1+pitch_angle2),0])
			translate([0,0,-pitch_apex2])
			{
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
			#translate([0,0,-42.2]) {nema17(true, true, true);}
			}
		}

	}
wall_thick = 1.5;
// chassis
	translate([0, 0, -17])
	{
		difference(){
			cylinder(r=7, h=22.3);
			translate([0, 0, 1.2])
			cylinder(r=4.1, h=23);
		}
		cylinder_round(-7, 4, 1);
		//#semiarc(21.5, 30, wall_thick, 0, 360);
		
	}
