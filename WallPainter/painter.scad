use <pulley.scad>
use <common.scad>
use <parametric_involute_gear_v5.0.scad>

$fn = 20;
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
showS = false;
showHalfPulley = false;
showMain = true;

separated = true;

if(showL && showS){
	if(separated){
		translate([-50,0,0]) rotate([0,0,360/teethL/2]) WadesS();
	}else{
		translate([-45,0,0]) rotate([0,0,360/teethL/2]) WadesS();
	}
}else if(showS){
	WadesS();
}
if(showL){
	WadesL();
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
show_motors = false;
wall_thick = 1.5;
if(showMain){
half_chasis();
translate([63,0,0])mirror([1,0,0])half_chasis();
}


module half_chasis(){
	translate([0, 43, 0])
	union(){
		difference(){
			cylinder(r=7, h=10);
			translate([0, 0, 1.2])
			cylinder(r=4.1, h=16);
		}
		cylinder_round(-7, 4, 1);

		translate([32, 0, 0])
			intersection(){
				translate([-9, 0, 0])cube([9, 9, 22.5]);
				cylinder(r=9, h=22.5);
			}
		translate([32, 0, 0])
			cube_semiarc(9, 22.5, wall_thick, 90, 180);
		cube_semiarc(21.5, 22.5, wall_thick, 235, 360);
		translate([-18.5, -26.7, 0]) color("red")
			cube_semiarc(9.5, 22.5, wall_thick, 55, 180);
		translate([-27.9-wall_thick, -26.4-30, 0])
			cube([wall_thick, 30, 22.5]);
	}
	if(show_motors){
	%	nema14();
	}
	color("blue")
	difference(){
	union(){
		translate([-12.5, 16, 0]) cube([25, 5, 22.5]);
		intersection(){
			translate([16,-12.5,  0])cube([8, 25, 10]);
			translate([16,-12.5, -2.5]) rotate([0, -15, 0])cube([8, 25, 15]);
		}
		mirror([1,0,0])
		intersection(){
			translate([16,-12.5,  0])cube([8, 25, 10]);
			translate([16,-12.5, -2.5]) rotate([0, -15, 0])cube([8, 25, 15]);
		}
		translate([-28, 6, 0]) 
		difference(){
			cube([10, 12, 34]);
			translate([5, 6, 19])cylinder(d=3, h=15);
		}
		translate([-28, -18, 0])
		difference(){
			cube([10, 12, 34]);
			translate([5, 6, 19])cylinder(d=3, h=15);
		}
	}
	nema14();
	}
// FONDO
	color("violet")
	translate([0, 0, -2.4])
	linear_extrude(height = 2.4)
	difference(){
		polygon(points=[
			[32, 60],
			[-8, 60],
			[-28-wall_thick, 36.5],
			[-28-wall_thick, -27],
			[-8, -49],
			[32, -49],
			[32, -10],
			[24, -10],
			[24, 30],
			[32, 30]
		]);
		circle(r=12);
		polygon(points=[
			[-10, -20],
			[-10, -40],
			[28, -40],
			[28, -20]
		]);
	}
}

module motor(){
	cylinder(r=2.5, h=54);
	cylinder(r=11.3, h=36);
	translate([-18, -18, 0]) cube([36, 36, 34]);
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
