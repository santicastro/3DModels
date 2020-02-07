use <common.scad>

$fn = 55;
M_PI=3.14159265359;

ball_diameter=4.5+0.5;
ball_distance=12-0.4; // center to center
thread_diameter=2+0.5;

/*
sphere(r=ball_diameter/2);
cylinder(r=thread_diameter/2, h=ball_distance);
translate([0,0,ball_distance]) sphere(r=ball_diameter/2);
*/

ball_radius=ball_diameter/2;
thread_radius=thread_diameter/2;

motor_thickness=5.2;

ball_bearing_height = 7;
ball_bearing_diameter = 22 + 0.26;
pulley_thickness = ball_diameter+2.5;
pulley1_ball_bearing_height = pulley_thickness/2-0.9;
echo("pulley1_ball_bearing_height",pulley1_ball_bearing_height);

pulley2_ball_bearing_height = ball_bearing_height-pulley1_ball_bearing_height;

ball_count = 10;
/*
difference() {
  half_pulley(ball_count, pulley_thickness);
  translate([0,0,-pulley_thickness/2]) cylinder(d=18, h=pulley_thickness/2); //ball bearing
  %translate([0,0,-pulley1_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley1_ball_bearing_height); //ball bearing
  
  for ( i = [0 : 3] ) {
    // screw hole with head
    rotate([0,0,90*i]) translate([13.5, 0, -pulley_thickness/2]) color("blue")
    union() {
      cylinder(d=3, h=pulley_thickness);
      cylinder(d=5.7, h=pulley_thickness/4);
    }
  }
}

translate([pulley_radius(ball_count)*2.5,0])
difference() {
  half_pulley(ball_count, pulley_thickness);
  translate([0,0,-pulley_thickness/2]) cylinder(d=15, h=pulley_thickness/2); //ball bearing
  translate([0,0,-pulley2_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley2_ball_bearing_height); //ball bearing
  for ( i = [0 : 3] ) {
    // screw hole
    rotate([0,0,90*i]) translate([13.5, 0, -pulley_thickness/2]) color("blue")
    union() {
      cylinder(d=3, h=pulley_thickness);
    }
  }
}
*/

// This is used for ball bearings
//final_half_pulley_8_for_ball_bearing();
module final_half_pulley_8_for_ball_bearing() {
  pulley_thickness = ball_bearing_height+1;
  new_ball_count = 8;
  difference() {
    half_pulley(new_ball_count, pulley_thickness);
    mirror([0,0,-1]) {
      cylinder(d=ball_bearing_diameter-1.5, h=pulley_thickness); //ball bearing
      //  cylinder(d2=ball_bearing_diameter-1, d2=ball_bearing_diameter, h=2);
    }
    color("blue")mirror([0,0,-1])cylinder(d=ball_bearing_diameter-0.75, h=ball_bearing_height/2+0.3-0.5);
    mirror([0,0,-1])cylinder(d=ball_bearing_diameter, h=ball_bearing_height/2+0.3-0.75);
    
    // screw holes
    /*
    for ( i = [18, 162,270] ) {
      // screw hole with head
      rotate([0,0,i]) translate([14.5, 0, -pulley_thickness/2]) color("blue")
      union() {
        cylinder(d=3, h=pulley_thickness);
        cylinder(d=5.7, h=pulley_thickness/4);
      }
    }
    */
    // bridas
    /*
    translate([4, 10.8, -10])rotate([0, 0, -20])cube([3, 1.35, 20]);
    mirror([1, 0])                translate([4, 10.8, -10])rotate([0, 0, -20])cube([3, 1.35, 20]);
    mirror([0, 1])                translate([4, 10.8, -10])rotate([0, 0, -20])cube([3, 1.35, 20]);
    mirror([0, 1]) mirror([1, 0]) translate([4, 10.8, -10])rotate([0, 0, -20])cube([3, 1.35, 20]);
    */
    conediameter = 3;
    for ( i = [45/2, 45/2 + 90, 45/2 + 180, 45/2 + 270] ) {
      rotate([0,0,i]) translate([13.15, 0, -pulley_thickness/2]) color("blue")
      union() {
        cylinder(d=2.35, h=10);
        mirror([0,0,1])translate([0, 0, -conediameter/2])cylinder(d1=0, d2=conediameter, h=conediameter/2);
      }
    }
    
    translate([0, 0, -10])complex_cylinder_round(18.4, 10, 0) {
      difference() {
        rotate([0, 0, 40]) square(5.4);
      }
    };
  }
}

intersection(){
  double_full_pulley();
  cube([100, 100, 100]);
}
module double_full_pulley() {
  
  //mirror([0, 0, 1])cylinder(d=8, h=10);
  difference() {
    
    union() {
    color("blue")translate([0, 0, 12]) cylinder(d=ball_bearing_diameter + 8, h=40-12-0.01);
      pulley_test(ball_bearing_height+1);
      translate([0, 0, ball_bearing_height+1])pulley_test(ball_bearing_height+1);
    }
    union(){
      translate([0, 0, -(ball_bearing_height+1)/2]) half_interior();
      translate([0, 0, 40])mirror([0, 0, 1])half_interior();
    }
  }
  module pulley_test(pulley_thickness) {
    new_ball_count = 9;
    difference() {
      union() {
        half_pulley(new_ball_count, pulley_thickness);
        difference() {
          mirror([0, 0, 1])half_pulley(new_ball_count, pulley_thickness);
            /*
          translate([0, 0, -4])complex_cylinder_round(20.4, 10, 0) {
            difference() {
              rotate([0, 0, 45]) square(6.7);
            }
          }
            */
          
        }
      }
    }
  }
  
}

module half_interior() {
  color("violet")union() {
    cylinder(d=ball_bearing_diameter, h=ball_bearing_height);
    
    internal_diameter = ball_bearing_diameter + 3;
    max_incline = 1;
    internal_border_diameter = ball_bearing_diameter-1.5*max_incline*2;
    translate([0, 0, ball_bearing_height])cylinder(d1=ball_bearing_diameter,d2=internal_border_diameter, h=1.5);
    tmp_h=(internal_diameter-internal_border_diameter)/2/0.8;
    translate([0, 0, ball_bearing_height + 1.5 ])cylinder(d2=internal_diameter,d1=internal_border_diameter, h=tmp_h);
    translate([0, 0, ball_bearing_height + 1.5+ tmp_h])cylinder(d=internal_diameter, h=15);
    
  }
}

//double_full_pulley_test();
module double_full_pulley_test() {
  //mirror([0, 0, 1])cylinder(d=8, h=10);
  //pulley_test(ball_bearing_height+1);
  translate([0, 0, ball_bearing_height+1])pulley_test(ball_bearing_height+1);
  module pulley_test(pulley_thickness) {
    new_ball_count = 9;
    difference() {
      union() {
        half_pulley(new_ball_count, pulley_thickness);
        mirror([0, 0, 1])half_pulley(new_ball_count, pulley_thickness);
        
        translate([0, 0, -4])complex_cylinder_round(20.4, 10, 0) {
          union() {
            square([1, 4.3]);
            translate([0.5, 3.7])rotate([0, 0, 45]) square([2.3, 0.8]);
          }
        }
        
        
      }
      translate([0, 0, -ball_bearing_height])cylinder(d=26.5, h=ball_bearing_height*2);
      
    }
  }
}

function pulley_external_radius(ball_count) = pulley_radius(ball_count)+ball_diameter/2;
function pulley_radius(ball_count) = ball_count*ball_distance/(2*M_PI);
function ball_diameter() = ball_diameter;

module half_pulley(ball_count, thickness) {
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
  
  error = abs(radius-sin(alpha)*direct_ball_distance + cos(angle)*radius);
  if(error>0.1) {
    echo ("---------------- ERROR CALCULATING ANGLE -------------------------");
    echo("error:" + error);
  }
  /*
  color("violet")
  translate([0,0,-thickness/2])
  linear_extrude(height=thickness/2, convexity = 10)
  polygon(points=[[radius, 0],
  [radius, direct_ball_distance*cos(alpha)],
  [radius -(direct_ball_distance*sin(alpha)), direct_ball_distance*cos(alpha)]]);
  */
  difference() {
    union() {
      // MAIN CYLINDER
      difference() {
        translate([0,0,-thickness/2]) cylinder(r=external_radius, h=thickness/2);
        color("blue") translate([0,0,-thickness/2]) cylinder(r=motor_thickness/2, h=10);
      }
    }
    union() {
      // EXTRACT MATERIAL FOR BALLS AND THREAD
      //// thread_indent
      union() {
        rotate_extrude(convexity = 10)
        hull() {
          translate([radius, 0, 0]) circle(d=thread_diameter);
          translate([external_radius, 0, 0]) circle(d=thread_diameter);
        }
        color("red") translate([0,0,- thread_radius])rotate([180,0,0])cylinder_round(external_radius, 0.5, 0.5);
      }
      //// ball_indent
      //for ( i = [0 : 0] )
      //  rotate([0,0,i*360/ball_count]) translate([radius, 0, 0]) color("blue")
      //    sphere(r=ball_radius);
      
      //// ball_ways
      difference() {
        for ( i = [0 : ball_count-1] )
        hull() {
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
module basic_pulley(ball_count) {
  echo("Generating pulley for ", ball_count, " balls");
  perimeter=ball_count*ball_distance;
  radius=perimeter/(2*M_PI);
  external_radius=radius+ball_diameter/6;
  echo("  Calculated perimeter", perimeter);
  echo("  Calculated radius", radius);
  thickness=ball_diameter+2;
  ring_width=radius*0.2;
  
  difference() {
    union() {
      // MAIN CYLINDER
      difference() {
        translate([0,0,-thickness/2])
        cylinder(r=external_radius, h=thickness);
        cylinder(r=radius-ring_width, h=thickness);
        translate([0,0,-thickness/2])
        cylinder(r=motor_thickness/2, h=10);
      }
      cylinder_round(radius-ring_width,thickness/2, 0);
      difference() {
        cylinder(r=7, h=3);
        cylinder(r=motor_thickness/2, h=10);
      }
    }
    union() {
      // EXTRACT MATERIAL FOR BALLS AND THREAD
      rotate_extrude(convexity = 10)
      translate([radius, 0, 0])
      thread_hole(thread_radius, thickness, radius, external_radius);
      for ( i = [0 : ball_count-1] )
      rotate([0,0,i*360/ball_count]) translate([radius, 0, 0])
      union() {
        hull() {
          sphere(r=ball_radius);
          translate([3*(external_radius-radius), 0, 3*(external_radius-radius)])sphere(r=ball_radius);
        }
      }
    }
  }
  
}

module thread_hole(thread_radius, thickness, internal_radius, external_radius) {
  point1=[-thread_radius*cos(45),thread_radius*sin(45)];
  y=thickness/2+0.1;
  point2=[point1[0]+y-point1[1],y];
  point3=[max(external_radius-internal_radius, point2[0]),-thread_radius];
  point4=[0, -thread_radius];
  points=[point1, point2, point3, point4];
  union() {
    circle(r=thread_radius, h=0);
    polygon(points=points);
  }
}

