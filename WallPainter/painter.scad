use <pulley.scad>
use <mendel_misc.inc>
use <parametric_involute_gear_v5.0.scad>

$fn = 80;
hideDetails = false;
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

//translate([50, 0, 0]) half_pulley(10, 7);
//translate([100, 0, 0]) half_pulley(8, 7);

teethL = 38;
teethS = 19;

pulley_thickness = 6.6;
ball_count = 10;

showL = false;
showS = true;
showHalfPulley = false;

separated = true;

if(showL && showS){
	if(separated){
		translate([-50,0,0]) rotate([0,0,360/teethL/2]) WadesS();
	}else{
		translate([-45,0,0]) rotate([0,0,360/teethL/2]) WadesS();
	}
}else if(showS){
	mirror([1,0,0])WadesS();
}
if(showL){
	mirror([1,0,0])WadesL();
}
if(showHalfPulley){
translate([0, 75,0])
	difference(){
	half_pulley(ball_count, pulley_thickness);
	translate([0, 0, -5])cylinder(r = 4.1, h = 80);
	  for ( i = [0 : 3] ){ // screw hole
	    rotate([0,0,90*i]) translate([11, 0, -pulley_thickness]) color("blue") 
	      union(){
	        cylinder(d=3, h=pulley_thickness);
			translate([0, 0, ])sphere(r=4);
	      }
	  }
	}
}

module WadesL(){
	twist = 160;
	pressure_angle = 30;
	pulleys_distance = 28;
	hole_radius = 6;

	//Large WADE's Gear
	difference(){
		union(){
			gear (number_of_teeth=teethL,
				circular_pitch=268,
				gear_thickness = 0,
				rim_thickness = 4,
				rim_width = 3,
				hub_thickness = 0,
				hub_diameter = 16,
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
				hub_diameter = 16,
				bore_diameter = 5.2,
				circles=6,
				pressure_angle=pressure_angle,
				twist=twist/teethL);
			translate([0, 0, pulleys_distance]) half_pulley(ball_count, pulley_thickness);
		 	color("red") cylinder(r = 9, h = pulleys_distance);
			if(!hideDetails){
				cylinder_round(-9, 1, 1);
				cylinder_round(23.6, 1.6, 1.6);
			}
			translate([0, 0, pulleys_distance-3.3])
			difference(){
				rotate_extrude(convexity = 10) //ball pulley support
				polygon(points=[[0, 0],
					[pulley_external_radius(ball_count),0],
					[0, -pulley_external_radius(ball_count)*1.25]
				]);
				difference(){ // internal hole
					rotate_extrude(convexity = 10)
					translate([10, -6.5, 0]) rotate([0, 0, 45])
					square(4.5);
					cube([100, 2, 100], center=true);
					rotate([0, 0, 90]) cube([100, 2, 100], center=true);
				}
			}
		}
		union(){ // view inside% cube([200,200,200]);
			translate([0, 0, -5])cylinder(r = 4.1, h = 80);
			translate([0, 0, -4])
			rotate_extrude(convexity = 10)
			polygon(points=[[0, 0], 
				[0, 4+pulleys_distance],
				[hole_radius, 4+pulleys_distance-hole_radius*1.25],
				[hole_radius, hole_radius*1.25]
				]);
		}
		translate([0, 0, pulleys_distance])
  		for ( i = [0 : 3] ){ // screw hole
  		  rotate([0,0,90*i]) translate([11, 0, -pulley_thickness]) color("blue") 
      		union(){
        			cylinder(d=3, h=pulley_thickness);
     		}
  		}
	}
}

module WadesS(){
twist=200;
pressure_angle=30;
	//small WADE's Gear
	difference(){
	union(){
		gear (number_of_teeth=teethS,
			circular_pitch=268,
			gear_thickness = 5,
			rim_thickness = 5,
			hub_thickness = 11.5,
			hub_diameter = 20,
			bore_diameter = 5.4,
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
			bore_diameter = 5.4,
			circles=0,
			pressure_angle=pressure_angle,
			twist=twist/teethS);
		
	}
	// screw
		translate([0,-5.4,10.5])cube([6,2.4,12.5],center = true);
		translate([0,0,8])rotate([0,90,-90])cylinder(r=1.6,h=20);
	}
}
