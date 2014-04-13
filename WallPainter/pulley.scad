$fn=80;
M_PI=3.14159265359;

ball_diameter=4.5+0.5;
ball_distance=12-0.4; // center to center
thread_diameter=2+0.4;

/*
sphere(r=ball_diameter/2);
cylinder(r=thread_diameter/2, h=ball_distance);
translate([0,0,ball_distance]) sphere(r=ball_diameter/2);
*/

ball_radius=ball_diameter/2;
thread_radius=thread_diameter/2;

motor_thickness=5.2;

ball_bearing_height = 7 + 0.2;
ball_bearing_diameter = 22 + 0.5;
pulley_thickness = ball_diameter+2.5;
pulley1_ball_bearing_height = pulley_thickness/2-0.9;
echo("pulley1_ball_bearing_height",pulley1_ball_bearing_height);

pulley2_ball_bearing_height = ball_bearing_height-pulley1_ball_bearing_height;

ball_count = 12;

difference(){
  half_pulley(ball_count, pulley_thickness);
  translate([0,0,-pulley_thickness/2]) cylinder(d=18, h=pulley_thickness/2); //ball bearing
  translate([0,0,-pulley1_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley1_ball_bearing_height); //ball bearing
  
  for ( i = [0 : 2] ){ // screw hole with head
    rotate([0,0,75+120*i]) translate([15.5, 0, -pulley_thickness/2]) color("blue") 
      union(){
        cylinder(d=3, h=pulley_thickness);
        cylinder(d=5.7, h=pulley_thickness/4);
      }
  }
}

translate([pulley_radius(ball_count)*2.5,0])
difference(){
  half_pulley(ball_count, pulley_thickness);
  translate([0,0,-pulley_thickness/2]) cylinder(d=15, h=pulley_thickness/2); //ball bearing
  translate([0,0,-pulley2_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley2_ball_bearing_height); //ball bearing
  for ( i = [0 : 2] ){ // screw hole
    rotate([0,0,75+120*i]) translate([15.5, 0, -pulley_thickness/2]) color("blue") 
      union(){
        cylinder(d=3, h=pulley_thickness);
      }
  }
}


function pulley_radius(ball_count) = ball_count*ball_distance/(2*M_PI);
function ball_diameter() = ball_diameter;

module half_pulley(ball_count, thickness = ball_diameter/2){
  echo("Generating pulley for ", ball_count, " balls");
  perimeter=ball_count*ball_distance;
  radius=perimeter/(2*M_PI);
  external_radius=radius+ball_diameter/2;
  echo("  Calculated perimeter", perimeter);
  echo("  Calculated radius", radius);
  ring_width=radius*0.2;
    angle = 360/ball_count;

  direct_ball_distance = radius*sqrt( pow(sin(angle),2) + pow(1-cos(angle),2));
  alpha = asin(((1-cos(angle))*radius)/direct_ball_distance);
  echo("  Calculated alpha", alpha);

    if(radius!=sin(alpha)*direct_ball_distance + cos(angle)*radius)
    echo ("---------------- ERROR CALCULATING ANGLE -------------------------");
/*
color("violet")
translate([0,0,-thickness/2])
linear_extrude(height=thickness/2, convexity = 10) 
                polygon(points=[[radius, 0], 
                      [radius, direct_ball_distance*cos(alpha)],
                      [radius -(direct_ball_distance*sin(alpha)), direct_ball_distance*cos(alpha)]]);
*/
  difference(){
    union(){ // MAIN CYLINDER
      difference(){
        translate([0,0,-thickness/2]) cylinder(r=external_radius, h=thickness/2);
        color("blue") translate([0,0,-thickness/2]) cylinder(r=motor_thickness/2, h=10);
      }
    }
    union(){ // EXTRACT MATERIAL FOR BALLS AND THREAD
      //// thread_indent
      rotate_extrude(convexity = 10)
      hull(){
        translate([radius, 0, 0]) circle(d=thread_diameter);
        translate([external_radius, 0, 0]) circle(d=thread_diameter);
      }
      //// ball_indent
      //for ( i = [0 : 0] )
      //  rotate([0,0,i*360/ball_count]) translate([radius, 0, 0]) color("blue")
      //    sphere(r=ball_radius);
      
      //// ball_ways
      difference(){
        for ( i = [0 : ball_count-1] )
        hull(){
          // half 1
          rotate([0,0,i*angle]) translate([radius, 0, 0]) 
          color("red")
           union() {
             translate([-(direct_ball_distance*sin(alpha)), direct_ball_distance*cos(alpha)])
              sphere(r=ball_radius);
            intersection() {
              rotate_extrude(convexity = 10) translate([direct_ball_distance, 0, 0]) 
                circle(r=ball_radius);
              translate([0,0,-thickness/2])
               linear_extrude(height=thickness) 
                polygon(points=[[0, 0], 
                      [cos(angle)*external_radius*1.5-radius, sin(angle)*external_radius*1.5],
                      [-(direct_ball_distance*sin(alpha)), direct_ball_distance*cos(alpha)]]);
            }//intersection
          }//union

        // half 2
          rotate([0,0,((i + 2) % ball_count)*angle]) translate([radius, 0, 0]) 
          color("yellow")
           union() {
             translate([-(direct_ball_distance*sin(alpha)), -direct_ball_distance*cos(alpha)])
              sphere(r=ball_radius);
            intersection() {
              rotate_extrude(convexity = 10) translate([direct_ball_distance, 0, 0]) 
                circle(r=ball_radius);
              translate([0,0,-thickness/2])
               linear_extrude(height=thickness) 
                polygon(points=[[0, 0], 
                      [cos(angle)*external_radius*1.5-radius, -sin(angle)*external_radius*1.5],
                      [-(direct_ball_distance*sin(alpha)), -direct_ball_distance*cos(alpha)]]);
            }//intersection
          }//union
        } //hull
      }//difference
    }//union

  }//difference

}//module








//////////// B A S I C   P U L L E Y /////////////
module basic_pulley(ball_count){
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
        cylinder(r=7, h=3);
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
