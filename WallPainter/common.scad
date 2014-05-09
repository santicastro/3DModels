use <common.scad>

$fn=20;

		
module m3_hole(){
	translate([-3, -3, 0])
	cube([6, 12.5, 2.4]);
	translate([0,0,-4])cylinder(r=1.6,h=16);
}
m3_hole();
//nema17(true, true, true);
module nema14(show_screws = false, show_body=true){
	if(show_body){
		cylinder(r=2.5, h=54);
		cylinder(r=11.3, h=36);
		translate([-18, -18, 0]) cube([35, 35, 34]);
	}
	if(show_screws){
		translate([13, 13, 34]) cylinder(r=1.55, h=10);
		translate([-13, 13, 34]) cylinder(r=1.55, h=10);
		translate([13, -13, 34]) cylinder(r=1.55, h=10);
		translate([-13, -13, 34]) cylinder(r=1.55, h=10);
	}
}

module nema17(show_screws = false, show_body=true, big_holes=false){
	screw_holes_length = 10;
	if(show_body){
		cylinder(r=2.5, h=34+24);
		cylinder(r=11.3, h=34+2);
		translate([-21, -21, 0]) cube([42.3, 42.3, 34]);
	}
	if(show_screws){
		hull(){
			translate([15.5, 15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
			if(big_holes) translate([13, 13, 34]) cylinder(r=1.55, h=screw_holes_length);
		}
		hull(){
			translate([-15.5, 15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
			if(big_holes) translate([-13, 13, 34]) cylinder(r=1.55, h=screw_holes_length);
		}
		hull(){
			translate([15.5, -15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
			if(big_holes) translate([13, -13, 34]) cylinder(r=1.55, h=screw_holes_length);
		}
		hull(){
			translate([-15.5, -15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
			if(big_holes) translate([-13, -13, 34]) cylinder(r=1.55, h=screw_holes_length);
		}
		
	}
}

module semiarc(r, h, weight, angle_start, angle_finish){
	angle = angle_finish - angle_start;
	distance=(r+weight)*1.5;

	rotate([0, 0, angle_start])
	intersection(){
		rotate_extrude(convexity = 10)
		translate([r, 0, 0]) children(0);
		if(angle<360){
			linear_extrude(height=h)
			if(angle>180){
				polygon(points=[[0,0], 
				[distance,0],
				[distance,distance],
				[0, distance],
				[-distance, distance],
				[-distance, 0],
				[-distance, -distance],
				[0, -distance],
				[distance*cos(angle), distance*sin(angle)]
				]);
			}else{
				polygon(points=[[0,0], 
				[distance,0],
				[distance,distance],
				[0, distance],
				[distance*cos(angle), distance*sin(angle)]
				]);
			}
		}
	}
}

module cube_semiarc(r, h, weight, angle_start, angle_finish){
	semiarc(r, h, weight, angle_start, angle_finish) {
		square([weight,h]);
	};
}

module cylinder_round(internal_radius, height, margin){
	delta_radius=height;
	complex_cylinder_round(internal_radius, height, margin) {
		difference() {
		    translate([-margin, -margin, 0]) square(delta_radius + margin);
		    translate([delta_radius,delta_radius,0]) circle(delta_radius);
		}
	};
}

module complex_cylinder_round(internal_radius, height, margin){
  rotate_extrude(convexity = 20)
  translate([internal_radius, 0, 0])rotate([90,0,0])rotate([0,180,0])
  children(0);
}

semiarc(21.5+0.8, 30, 1.5, 0, 185) { 
					%square(1.5);
				};