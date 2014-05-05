use <common.scad>

module motor(){
	cylinder(r=2.5, h=54);
	cylinder(r=11.3, h=36);
	translate([-18, -18, 0]) cube([36, 36, 34]);
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

	
