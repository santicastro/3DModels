use <pulley.scad>
use <common.scad>
use <parametric_involute_gear_v5.0.scad>

$fn=60;

gear1_teeth = 25;
gear2_teeth = 8;
axis_angle = 45;
bore_diameter = 5.25;
outside_circular_pitch=400;

pulley_thickness = 6.6;
ball_count = 10;

ball_bearing_height = 7 + 0.2;
ball_bearing_diameter = 22 + 0.5;
pulley1_ball_bearing_height = pulley_thickness/2-0.9;
echo("pulley1_ball_bearing_height",pulley1_ball_bearing_height);

pulley2_ball_bearing_height = ball_bearing_height-pulley1_ball_bearing_height;

show_big_pulley = false;
big_pulley_moved = 0; //0 false, 1 true
big_pulley_translation = [50 * big_pulley_moved, 0, -106 * big_pulley_moved];
big_pulley_rotation = [180 * big_pulley_moved, 0, 0];

show_half_pulley = false;
half_pulley_moved = 0; //0 false, 1 true
half_pulley_translation = [100 * half_pulley_moved, 0, 0];
half_pulley_rotation = [0, 0, 0];

show_small_gear = false;
small_gear_moved = 0; //0 false, 1 true
small_gear_translation = [150 * small_gear_moved, 0, 0+17];
small_gear_rotation = [0, -45 * small_gear_moved, 0];

show_chassis = true;

outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
pitch_apex1=outside_pitch_radius2 * sin (axis_angle) +
(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
echo ("cone_distance", cone_distance);
pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

base_thick = 2.4;

// GEARS
rotate([0,0,90])
translate ([0,0,pitch_apex1+20]) {
  difference() {
    union() {
      translate(big_pulley_translation)rotate(big_pulley_rotation)
      if(show_big_pulley) {
        difference() {
          union() {
            // BIG GEAR
            translate([0,0,-pitch_apex1])
            difference() {
              intersection() {
                bevel_gear (
                number_of_teeth=gear1_teeth,
                cone_distance=cone_distance,
                pressure_angle=30,
                bore_diameter=8,
                outside_circular_pitch=outside_circular_pitch);
                cylinder(r1=27, r2=47, h=20);
              }
              translate([0, 0, 15.5-ball_bearing_height]) {
                cylinder(d = ball_bearing_diameter, h = ball_bearing_height+1);
                mirror([0, 0, 1])cylinder(d1 = ball_bearing_diameter, d2 = 18, h = ball_bearing_diameter-18);
              }
            }
            difference() {
              union() {
                translate([0, 0, -50])
                difference() {
                  // PULLEYS UNION
                  cylinder(r1=21, r2=21, h=10);
                  translate([0, 0, -pulley_thickness + 1.2])cylinder(d = ball_bearing_diameter, h = ball_bearing_height);
                }
                
                translate([0, 0, -53])mirror([0, 0, 1])
                difference() {
                  // T O P    H A L F   P U L L E Y
                  half_pulley(ball_count, pulley_thickness);
                  translate([0,0,-pulley_thickness/2]) cylinder(d=15, h=pulley_thickness/2); //ball bearing
                  translate([0,0,-pulley2_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley2_ball_bearing_height); //ball bearing
                }
              }
              translate([0, 0, -53])mirror([0, 0, 1])
              for ( i = [0 : 3] ) {
                // screw hole
                rotate([0,0,90*i]) translate([14, 0, -10]) color("blue")
                cylinder(d=3, h=10);
              }
            }
          }
          translate([0,0,-60])cylinder(d=18, h=50);
        }
      }
      if(show_half_pulley) {
        translate(half_pulley_translation)rotate(half_pulley_rotation)
        translate([0, 0, -53]) // B O T T O M    H A L F   P U L L E Y
        difference() {
          half_pulley(ball_count, pulley_thickness);
          translate([0,0,-pulley_thickness/2]) cylinder(d=18, h=pulley_thickness/2); //ball bearing
          translate([0,0,-pulley1_ball_bearing_height]) cylinder(d=ball_bearing_diameter, h=pulley1_ball_bearing_height); //ball bearing
          
          for ( i = [0 : 3] ) {
            // screw hole with head
            rotate([0,0,90*i]) translate([14, 0, -pulley_thickness/2]) color("blue")
            union() {
              cylinder(d=3, h=pulley_thickness);
              cylinder(d=3.4, h=0.4);
            }
          }
        }
      }
    }
    
  }
  
  //SMALL GEAR
  translate(small_gear_translation)rotate(small_gear_rotation)
  rotate([0,0,-9])
  if(show_small_gear) {
    rotate([0,(pitch_angle1+pitch_angle2),0])
    translate([0,0,-pitch_apex2])
    union() {
      bevel_gear (
      number_of_teeth=gear2_teeth,
      cone_distance=cone_distance,
      pressure_angle=30,
      outside_circular_pitch=outside_circular_pitch);
      translate([0,0,-6])
      rotate([0,0,22.5])difference() {
        cylinder(r=11, h=6);
        cylinder(d=bore_diameter, h=6);
        translate([-15,10,0])cube([30,10,6]);
        mirror([0,1,0])translate([-15,10,0])cube([30,10,6]);
        // screws
        translate([0,4,3])rotate([-90,0,0]) m3_hole();
        translate([0,-4,3])rotate([-90,0,180]) m3_hole();
      }
      if(small_gear_moved==0) translate([0,0,-42.2]) nema17(false, true, true, true);
    }
  }
}

wall_thick = 1.5;
// chassis
if(show_chassis) {
  half_chassis(isLeft=1);
  translate([61, 0, 0])mirror([1,0, 0])half_chassis();
}
module half_chassis(isLeft=0) {
  wall_angle=60;
  difference() {
    union() {
      difference() {
        union() {
          for (z = [0, -90, 180]) {
            rotate([0, 0, z])translate([-20.5,0,0])difference() {
              translate([0, -0.75, 0])cube([16, 1.5, 16]);
              rotate([0, wall_angle])cube([26,5,14], center=true);
            }
          }
          
          difference() {
            cylinder(r=7, h=21.9);
            translate([0, 0, 1.2])
            cylinder(r=4.18, h=23);
          }
          //m3 translate([0, 7.5, 4])cube([8, 5, 10], center=true);
          //%cylinder_round(-7, 4, 1);
          translate([0,0,18])semiarc(21.5+0.8, 30, wall_thick, 180, 225) {
            double_hole_border(wall_thick);
          }
        }
        //m3 translate([0, 5, 6])rotate([90, 0, 180])m3_hole();
        if(isLeft==1) {
          translate([13.5, -3.3, 0])cube([4,3,20]);
          translate([-5, -10.5, 0])cube([15, 5, 18]);
          translate([-5, -10.5, 4+4.5])cube([6, 6, 5]);
        }
      }
      translate([0,0,18])
      semiarc(21.5+0.8, 30, wall_thick, 10, 120) {
        double_hole_border(wall_thick);
      }
      difference() {
        semiarc(21.5, 31.15, wall_thick, 0-isLeft*5, 360-isLeft*125) {
          translate([0, 18, 0]) {
            square([wall_thick,31.15-18]);
            translate([wall_thick,0 ,0])rotate([0, 0, 90+wall_angle])square([wall_thick+0.25,18*1.41]);
          }
        }
        translate([0,0,21])semiarc(21.5+0.8, 30, wall_thick, 0, 120) {
          square([pulley_thickness,pulley_thickness]);
        };
        translate([0,0,21])semiarc(21.5+0.8, 30, wall_thick, 180, 225) {
          square([pulley_thickness,pulley_thickness]);
        };
        /*translate([0, 25, 6])rotate([0,45,0])cube([6, 20, 6], center=true);*/
        if(isLeft==1) {
          translate([13.5, -2.5, 0])cube([4,3,20]);
        }
      }
      
      translate([21.5, -3, 18])difference() {
        cube([9, 8.25, 13]);
        translate([7.6, -1, 2])rotate([0, 27, 0])cube([10, 20, 10], center=true);
        translate([10.5, -1, 4])cube([10, 20, 10], center=true);
        if(isLeft!=1) {
          translate([7,4,10])cylinder(d=3, h=10);
        }
      }
      translate([-18.5+1, -26.7+1.4, 0]) color("red")
      cube_semiarc(9.5-2, 31.15, wall_thick, 55, 140);
      
      color("red")translate([-10, -63.1, 13.4]) rotate([-45, 0, -9])
      translate([-42.3/2, -42.3/2, -7]) difference() {
        rounded_cube(42.3, 42.3, 7, 5.5, 0.35);
        translate([42.3/2, 42.3/2,-1])cylinder(r=7, h=20);
      }
      translate([-16, -82, -2.4])rotate([0, 0, -9])cube([8, 10, 25.4]);
      
      translate([-31.5, -52-25-7, -2.4])cube([62, 42, 2.4]);
      
      // B A C K G R O U N D
      translate([0, 0, -base_thick]) {
        cylinder(r=11+wall_thick, h=base_thick);
      }
      
    }
    translate([0, 0, -5-2.4])cube([200, 300, 10], center=true);
    translate([0,0,-3])cylinder(r=3, h=5);
    translate([-10, -63.1, 13.4]) rotate([-45, 0, -9])nema17(false, true, true, true);
  }
}
translate([-19.5, -32, -6.6])eraser(base_weight = base_thick);

module hole_border(size) {
  translate([0, size, 0])
  union() {
    intersection() {
      circle(r=size, center=true);
      square([size,size]);
    }
    polygon(points=[[0, 0],[size, 0],[0, -size]]);
  }
}
module double_hole_border(base_size) {
  union() {
    translate([base_size-0.8, 0, 0])hole_border(base_size);
    translate([0, pulley_thickness+base_size-0.8+1.5, 0])
    hole_border(wall_thick+base_size-0.8);
  }
}

