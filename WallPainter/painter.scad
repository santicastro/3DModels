use <pulley.scad>
use <parametric_involute_gear_v5.0.scad>

$fn=20;

//pulley(10);
//echo("proba", pulley_radius(10), "  ");

// TESTING BEVEL GEARS
difference(){
bevel_gear_pair(gear1_teeth = 21,
	gear2_teeth = 8,outside_circular_pitch=500, on_plate=true);
cube([100,100,25], center=true);
}
//cylinder(d=5, h=100);