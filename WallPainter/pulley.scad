M_PI=3.14159265359;

ball_diameter=4.5;
ball_distance=12; // center to center
thread_diameter=2;

/*
sphere(r=ball_diameter/2);
cylinder(r=thread_diameter/2, h=ball_distance);
translate([0,0,ball_distance]) sphere(r=ball_diameter/2);
*/

ball_radius=ball_diameter/2;
thread_radius=thread_diameter/2;

motor_thickness=5;

pulley(10);

function pulley_radius(ball_count) = ball_count*ball_distance/(2*M_PI);

function ball_diameter() = ball_diameter;

module pulley(ball_count){
	echo("Generating pulley for ", ball_count, " balls");
	perimeter=ball_count*ball_distance;
	radius=perimeter/(2*M_PI);
	external_radius=radius+ball_diameter/6;
	echo("  Calculated perimeter", perimeter);
	echo("  Calculated radius", radius);
	thickness=ball_diameter+2;
	ring_width=radius*0.2;

	difference(){
		union(){ // MAIN CYLINDER
			difference(){
				translate([0,0,-thickness/2]) 
				cylinder(r=external_radius, h=thickness);
				cylinder(r=radius-ring_width, h=thickness);
				translate([0,0,-thickness/2]) 
				cylinder(r=motor_thickness/2, h=10);
			}
			cylinder_round(radius-ring_width,thickness/2, 0);
			difference(){
				cylinder(r=7, h=10);
				cylinder(r=motor_thickness/2, h=10);
			}
		}
		union(){ // EXTRACT MATERIAL FOR BALLS AND THREAD
			rotate_extrude(convexity = 10)
			translate([radius, 0, 0])
			  thread_hole(thread_radius, thickness, radius, external_radius);
			for ( i = [0 : ball_count-1] )
				rotate([0,0,i*360/ball_count]) translate([radius, 0, 0]) 
				union(){
					hull(){
						sphere(r=ball_radius);
						translate([3*(external_radius-radius), 0, 3*(external_radius-radius)])sphere(r=ball_radius);
					}
				}
		}
	}

}

module thread_hole(thread_radius, thickness, internal_radius, external_radius){
	point1=[-thread_radius*cos(45),thread_radius*sin(45)];
	y=thickness/2+0.1;
	point2=[point1[0]+y-point1[1],y];
	point3=[max(external_radius-internal_radius, point2[0]),-thread_radius];
	point4=[0, -thread_radius];
	points=[point1, point2, point3, point4];
    union(){
		circle(r=thread_radius, h=0);  
		polygon(points=points);
	}	
}

module cylinder_round(internal_radius, height, margin){
	delta_radius=height;
	rotate_extrude(convexity = 10)
	translate([internal_radius, 0, 0])rotate([90,0,0])rotate([0,180,0])
	difference() {
		translate([-margin, -margin, 0]) square(delta_radius + margin);
		translate([delta_radius,delta_radius,0]) circle(delta_radius);
	}
}
