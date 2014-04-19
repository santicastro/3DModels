use <pulley.scad>
use <mendel_misc.inc>
use <parametric_involute_gear_v5.0.scad>

$fn=30;

//pulley(10);
//echo("proba", pulley_radius(10), "  ");
/*
// TESTING BEVEL GEARS
difference(){
bevel_gear_pair(gear1_teeth = 21,
	gear2_teeth = 8,outside_circular_pitch=500, on_plate=true);
cube([100,100,25], center=true);
}
*/

//half_pulley(12, 7);
//translate([50, 0, 0]) half_pulley(10, 7);
//translate([100, 0, 0]) half_pulley(8, 7);





teethL = 38;
teethS = 15;

showL = true;
showS = true;

separated = true;

if(showL && showS){
	if(separated){
		translate([-50,0,0]) rotate([0,0,360/teethL/2]) WadesL();
	}else{
		translate([-45,0,0]) rotate([0,0,360/teethL/2]) WadesL();
	}
}else if(showL){
	WadesL();
}
if(showS){
	WadesS();
}

module WadesL(){
twist=160;
pressure_angle=30;
	//Large WADE's Gear
	difference(){
		union(){
		gear (number_of_teeth=teethL,
			circular_pitch=268,
			gear_thickness = 3.5,
			rim_thickness = 4,
			rim_width = 3,
			hub_thickness = 13,
			hub_diameter = 20,
			bore_diameter = 5.2,
			circles=6,
			pressure_angle=pressure_angle,
			twist=twist/teethL);
		mirror([0,0,1])
		gear (number_of_teeth=teethL,
			circular_pitch=268,
			gear_thickness = 4,
			rim_thickness = 4,
			rim_width = 3,
			hub_thickness = 0,
			hub_diameter = 20,
			bore_diameter = 5.2,
			circles=6,
			pressure_angle=pressure_angle,
			twist=twist/teethL);
		}
		translate([0,0,-5])cylinder(r=4.1,h=30);
	}
}

module WadesS(){
twist=-200;
pressure_angle=30;
	//small WADE's Gear
	difference(){
	union(){
		gear (number_of_teeth=teethS,
			circular_pitch=268,
			gear_thickness = 5,
			rim_thickness = 5,
			hub_thickness = 15,
			hub_diameter = 20,
			bore_diameter = 5.2,
			circles=0,
			pressure_angle=pressure_angle,
			twist=twist/teethS);
		mirror([0,0,1])
		gear (number_of_teeth=teethS,
			circular_pitch=268,
			gear_thickness = 5,
			rim_thickness = 5,
			hub_thickness = 0,
			hub_diameter = 20,
			bore_diameter = 5.2,
			circles=0,
			pressure_angle=pressure_angle,
			twist=twist/teethS);
		
	}
	// screw
		translate([0,-5,10.5])cube([5.8,2.3,9.5],center = true);
		translate([0,0,11])rotate([0,90,-90])cylinder(r=1.7,h=20);
	}
}
