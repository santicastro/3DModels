use <pulley.scad>
use <common.scad>
use <parametric_involute_gear_v5.0.scad>

	gear1_teeth = 25;
	gear2_teeth = 7;
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

	rotate([0,0,90])
	translate ([0,0,pitch_apex1+20])
	{
		translate([0,0,-pitch_apex1])
		intersection(){
		bevel_gear (
			number_of_teeth=gear1_teeth,
			cone_distance=cone_distance,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch);
		cylinder(r=28, h=20);
		}
	
		translate([0, 0, -50]) mirror([0, 0, 1]) {
			half_pulley(ball_count, pulley_thickness);
			mirror([0, 0, 1])half_pulley(ball_count, pulley_thickness);
		}

		rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([0,0,-pitch_apex2])
		union(){
		bevel_gear (
			number_of_teeth=gear2_teeth,
			cone_distance=cone_distance,
			pressure_angle=30,
			outside_circular_pitch=outside_circular_pitch);
		#translate([0,0,-38]) nema17();
		}
	}
