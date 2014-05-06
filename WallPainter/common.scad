use <common.scad>

$fn=20;

nema17(true, true, true);
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
	if(show_body){
		cylinder(r=2.5, h=34+24);
		cylinder(r=11.3, h=34+2);
		translate([-21, -21, 0]) cube([42.3, 42.3, 34]);
	}
	if(show_screws){
		hull(){
			translate([15.5, 15.5, 34]) cylinder(r=1.55, h=10);
			if(big_holes) translate([13, 13, 34]) cylinder(r=1.55, h=10);
		}
		hull(){
			translate([-15.5, 15.5, 34]) cylinder(r=1.55, h=10);
			if(big_holes) translate([-13, 13, 34]) cylinder(r=1.55, h=10);
		}
		hull(){
			translate([15.5, -15.5, 34]) cylinder(r=1.55, h=10);
			if(big_holes) translate([13, -13, 34]) cylinder(r=1.55, h=10);
		}
		hull(){
			translate([-15.5, -15.5, 34]) cylinder(r=1.55, h=10);
			if(big_holes) translate([-13, -13, 34]) cylinder(r=1.55, h=10);
		}
		
	}
}

module semiarc(r, h, weight, angle_start, angle_finish){
	angle = angle_finish - angle_start;
	distance=(r+weight)*1.5;

	rotate([0, 0, angle_start])
	intersection(){
		rotate_extrude(convexity = 10)
		translate([r, 0, 0]) square([weight,h]);
		if(angle<360){
			linear_extrude(height=h)
			if(angle>180){
				polygon(points=[[0,0], 
				[distance,0],
				[0, distance],
				[-distance, 0],
				[0, -distance],
				[distance*cos(angle), distance*sin(angle)]
				]);
			}else{
				polygon(points=[[0,0], 
				[distance,0],
				[0, distance],
				[distance*cos(angle), distance*sin(angle)]
				]);
			}
		}
	}
}

	
