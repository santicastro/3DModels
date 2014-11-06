use <common.scad>

//$fn=20;

module m3_hole() {
  translate([-2.85, -2.85, 0])linear_extrude(2.35) union() {
    square([5.7, 12.5]);
    polygon(points=[[0,0], [5.7, 0], [2.85, -1]]);
  }
  translate([0,0,-4])cylinder(r=1.6,h=16);
}

module nema14(show_screws = false, show_body=true) {
  if(show_body) {
    cylinder(r=2.5, h=54);
    cylinder(r=11.3, h=36);
    translate([-18, -18, 0]) cube([35, 35, 34]);
  }
  if(show_screws) {
    translate([13, 13, 34]) cylinder(r=1.55, h=10);
    translate([-13, 13, 34]) cylinder(r=1.55, h=10);
    translate([13, -13, 34]) cylinder(r=1.55, h=10);
    translate([-13, -13, 34]) cylinder(r=1.55, h=10);
  }
}

//nema16(true, true, true, true);
module nema16(front_screws = false, bottom_screws = false,show_body=true, big_holes=false) {
  $fn=15;
  screw_holes_length = 10;
  full_screw_holes_length = screw_holes_length*2 + 34;
  if(show_body) {
    cylinder(r=2.5, h=34+24);
    cylinder(r=11.3, h=34+2);
    translate([-21, -21, 0]) cube([42.3, 42.3, 34]);
  }
  if(front_screws) {
    translate([0, 0, 34])for(i = [0 : 90 : 270]) {
      rotate([0, 0, i])nema_screw_hole();
    }
  }
  if(bottom_screws) {
    for(i = [0 : 90 : 270]) {
      rotate([180, 0, i])nema_screw_hole(screw_holes_length=4.25);
    }
  }
}
//nema_screw_hole(screw_holes_length=10, head_hole_length = 5);
module nema_screw_hole(screw_holes_length=5, head_hole_length = 10, big_holes=true) {
  $fn=15;
  hull() {
    translate([15.5, 15.5, 0]) cylinder(r=1.55, h=screw_holes_length);
    if(big_holes) translate([13, 13, 0]) cylinder(r=1.55, h=screw_holes_length);
  }
  hull() {
    translate([15.5, 15.5, screw_holes_length]) cylinder(r=5.5, h=head_hole_length);
    if(big_holes) translate([13, 13, screw_holes_length]) cylinder(r=5.5, h=head_hole_length);
  }
  
}

module semiarc(r, h, weight, angle_start, angle_finish) {
  angle = angle_finish - angle_start;
  distance=(r+weight)*1.5;
  
  rotate([0, 0, angle_start])
  intersection() {
    rotate_extrude(convexity = 10)
    translate([r, 0, 0]) children(0);
    if(angle<360) {
      linear_extrude(height=h)
      if(angle>180) {
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
      }else {
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

module cube_semiarc(r, h, weight, angle_start, angle_finish) {
  semiarc(r, h, weight, angle_start, angle_finish) {
    square([weight,h]);
  };
}

module cylinder_round(internal_radius, height, margin) {
  delta_radius=height;
  complex_cylinder_round(internal_radius, height, margin) {
    difference() {
      translate([-margin, -margin, 0]) square(delta_radius + margin);
      translate([delta_radius,delta_radius,0]) circle(delta_radius);
    }
  };
}

module complex_cylinder_round(internal_radius, height, margin) {
  rotate_extrude(convexity = 20)
  translate([internal_radius, 0, 0])rotate([90,0,0])rotate([0,180,0])
  children(0);
}

//servo_mg90s();
module servo_mg90s(head_rotation=0, from=45, to=180, steps=0) {
  translate([0, -29/2-3.3, 0])
  union() {
    translate([10.4/2, -6/2, 0]) {
      cube([23,23,12.6], center=true);
      translate([0, 9.25, 0])cube([32.3,3.5,12.6], center=true);
    }
    
    union() {
      rotate([-90, 0, 0]) {
        cylinder(d=12.6, h=29, center=true);
        translate([12.6/2, 0, 0])cylinder(r=3, h=29, center=true);
      }
    }
  }
  for(i=[from: (to-from)/(steps+1): to]) {
    rotate([-90, i+head_rotation, 0])servo_head();
  }
}

module servo_head() {
  translate([0, 0, -3.75]) {
    cylinder(d=7, h=5.5);
    translate([0, 0, 2.5])
    hull() {
      cylinder(d=6, h=2.5);
      translate([14, 0, 0])cylinder(d=4, h=2.5);
    }
  }
}

module eraser(base_width = 125, eraser_width=100, base_weight=3, show_pen_holder=true, show_eraser=true) {
  hole_width = eraser_width/2 - 2.5;
  margins = (base_width - eraser_width) / 2;
  //mobile part
  if(show_eraser) {
    rotate([-45])difference() {
      union() {
        cube([eraser_width, 7, 10]);//cuerpo de soporte de fieltro
        translate([0, -0.5, 0])cube([13, 4, 10]);//cuerpo de soporte de fieltro
        translate([66, -0.5, 0])cube([34, 4, 10]);//cuerpo de soporte de fieltro
        translate([10, 3, 13.3])rotate([0, 90, 0])eraser_holder(h=8);
        translate([eraser_width-18, 3, 13.3])rotate([0, 90, 0])eraser_holder(h=8);
        // pestaña al servo
        translate([47, -20, 20])rotate([0, 90, 0])hull() {
          cylinder(d=3, h=10, $fn=15, center=true);
          rotate([0, 0, 50])translate([4, 0, 0])cube([2, 0.1, 4], center=true);
        }
        translate([47, 3.2, 2])rotate([45, 0, 0])
        intersection() {
          translate([-4.5, -4, 0])cube([9, 7.4, 32]);
          rotate([8, 0, 0])
          translate([-2, 0, 0])union() {
            cube([4, 3, 35]);
            translate([-2.5, -3.5, 0])rotate([0, 0, 45])cube([6, 1.2, 35]);
            translate([1.8, 1, 0])rotate([0, 0, -45])cube([6, 1.2, 35]);
            
            translate([4, 0.55, 0])rotate([0, 0, 75])cube([4, 1.2, 35]);
            translate([-1, 4.5, 0])rotate([0, 0, -75])cube([4, 1.2, 35]);
          }
        }
      }
      
      union() {
        rotate([-45,0 ,0])translate([-0.5,0])cube([eraser_width+1, 20, 20]);
        //agujeros del cuerpo soporte de fieltro
        translate([2,1.1]) difference() {
          union() {
            cube([hole_width, 4.8, 8]);
            translate([hole_width+1, 0, 0])cube([hole_width, 4.8, 8]);
          }
          translate([0, 1.5, 0])cube([eraser_width, 1.8, 6.75]);
        }
      }
    }
  }
  //servo
  //%	translate([7.3, 15, 23.7])rotate([180, 0, 90])servo_mg90s();
  %translate([46.7, 20.0, 17.1])rotate([180, 180, 90])servo_mg90s(head_rotation=170, steps=4);
  
  //pen
  %	translate([base_width/2-margins-0, 49, 5])rotate([-37, 0,0 ])pen();
  
  //base
  translate([0, 11.5, 7.2])
  union() {
    color("green")difference() {
      translate([-margins, 3.4-30+5, -3])cube([base_width, 47-5, base_weight]);
      translate([-2, -17, -4])cube([eraser_width + 4, 20.8, 10]);
      translate([-5, 25, -4])rotate([0, 0, 45])cube([60, 23, 10], center=true);
      translate([base_width-20, 26, -4])rotate([0, 0, -45])cube([60, 23, 10], center=true);
    }
    translate([43, 17.4, -3])cube([14, 3, 4]);
    %translate([43, 19.4, -3])cube([14, 1, 4+8]);
    
    translate([29.2, 14.9, -3])cube([4, 5.2, 19]);
    translate([37, 14.9, -3])cube([4, 5.2, 19]);
    translate([29.2, 14.9, 16])cube([11.8, 5.2, 0.8]);
    translate([29.2, 15.8, 9.15])cube([11.8, 4.3, 1]);
    
    //%translate([11, 8, -3])cube([3.2, 7.3, 10]);
    //%translate([11, 14.9, -3])cube([15, 2, 10]);
    color("blue")translate([25, -1, -3]) {
      difference() {
        // servo support bridge
        cube([17, 18, 6.5]);
        translate([2, 5, 2.4])cube([12, 10, 7]);
        rotate([45, 0, 0]) cube([45, 9, 9], center=true);
      }
      difference() {
        translate([13.5, -17.5, 6.5]) {
          translate([0, 0, 0.5])cube([3.5, 28, 3]);
          translate([0, 17.5, 0])cube([3.5, 5, 0.5]);
          hull() {
            translate([0, 0, 0.5])cube([3.5, 3, 3]);
            translate([0, -6, -5])cube([3.5, 5, 0.1]);
          }
        }
        translate([15, 5, 12])rotate([55, 0, 0]) cube([10, 9, 40], center=true);
      }
      translate([8, -10, 13])
      difference() {
        translate([6.4, 0, 0])hull() {
          cube([5, 6, 5], center=true);
          translate([0.8, 0, -4])cube([3.5, 12, 2], center=true);
        }
        rotate([0, 90, 0])cylinder(d=1.5, h=10);
        translate([-5, 2.5, -5])cube([10, 10, 10]);
      }
    }
    rotate([0, 90, 0])rotate([0, 0, 90])eraser_holder(internal_diameter=2.1, h=9.5);
    translate([eraser_width-9.5, 0, 0])rotate([0, 90, 0])rotate([0, 0, 90])eraser_holder(internal_diameter=2, h=9.5);
    
    //  pen_holder_support
    translate([38,-19, 8.9])rotate([0, 90, 0])rotate([0, 0, -15])
    union() {
      eraser_holder(internal_diameter= 3.1, h=4, length=4.8);
      translate([0, 0, 13])eraser_holder(internal_diameter=3.1, h=4, length=4.8);
      translate([0, 0, 26])eraser_holder(internal_diameter=3.1, h=4, length=4.8);
    }
    difference() {
      translate([38,-23.1, -2.4])cube([26+4, 6.1, 5.5+2.4]);
      translate([41,-18, 8.6])rotate([0, 90, 0])cylinder(d=8.5, h=13-3, $fn=25);
      translate([54,-18, 8.6])rotate([0, 90, 0])cylinder(d=8.5, h=13-3, $fn=25);
    }
  }
  /////////////////////////////////////////////
  if(show_pen_holder) {
    color("blue")translate([39.25, -12, 10.5+3])rotate([-7+11-4, 0, 0])pen_holder();
    color("blue")translate([150, 0, 10])pen_top();
  }
  /////////////////////////////////////////////
}

module pen_holder() {
  protector_angle = 30;
  tower_height = 8.5;
  //holder base
  difference() {
    union() {
      translate([3, 0+4.2, 0])cube([21.5, 10-4.2, 3*2]);
      difference() {
        translate([16, 0, 0])rotate([0,0,9])rounded_cube(10, 50, 3, 4);
        cube([30, 4.2, 3.1]);
      }
      hull() {
        translate([0.4, 53, 0])rounded_cube(20, 25, 3, 4);
        translate([4.4, 38, 0])rounded_cube(12, 15, 3, 4);
      }
      translate([13.75, 4.2, 3])rotate([0, 90, 0])cylinder(d=6.3, h=21.5, $fn=25, center=true);
      translate([-0.8, 45, 0])rounded_cube(22, 6, 3, 1.5);
    }
    
    translate([24.5, 0, 0]) cube([10, 10, 4]);
    translate([13.75, 4.2, 2])rotate([0, 90, 0])cylinder(d=9.5, h=4.5, $fn=25, center=true);
    translate([14, 4.2, 3])rotate([0, 90, 0])cylinder(d=3.2, h=30+1, $fn=25, center=true);
    translate([10.5, 59.6, -5])rotate([-protector_angle, 0, 0])translate([0, 0, 5])
    cylinder(d=10, h=30, center=true);
  }
  
  //tower
  translate([10.25, 41, 0])rotate([0, -90, 0])union() {
    hull() {
      translate([0, -4.5, 0])cube([1, 7.5, 5]);
      translate([tower_height, 0, 0])cylinder(d=4, h=5);
    }
    translate([tower_height, 0, 0])cylinder(d=6, h=1.15);
    translate([tower_height, 0, 5-1.15])cylinder(d=6, h=1.15);
  }
  
  //pen protector
  translate([10.5, 90, 48])
  difference() {
    rotate([-protector_angle, 0, 0])difference() {
      translate([0, 0, -60])union() {
        cylinder(d=20.5, h=80);
        translate([0, -10.25, 0])rotate([-0.8, 0, 0])cylinder(d=5, h=80, $fn=10);
        translate([0, 10.25, 0])rotate([0.8, 0, 0])cylinder(d=5, h=80, $fn=10);
        
        rotate([protector_angle, 0, 0])translate([0, 32, 59])
        for( i = [-1, 1] ) {
          translate([i*10, 0, 0]) rotate([0, 45, 0])
          difference() {
            cube([10, 3, 10], center=true);
            cube([5, 3.1, 5], center=true);
          }
        }
      }
      cylinder(d=17.5, h=122, center=true);
      difference(){
      union(){
             //translate([6, 0, -70])rotate([45, 0, 0])cube([15, 30, 30]);
      //       translate([-20, 0, -70])rotate([45, 0, 0])cube([15, 30, 30]);
      }
      translate([-18, -6, -80])cube([40, 10, 50]);
      translate([-18, -10, -38])rotate([protector_angle, 0, 0])cube([40, 20, 20]);
      }
      translate([0,-16, -30])rotate([45, 0, 90])cube([15, 30, 30]);
      
      translate([6, 0, 10])rotate([45, 0, 0])cube([15, 30, 30]);
      translate([-20, 0, 10])rotate([45, 0, 0])cube([15, 30, 30]);
      
      translate([0, 0, -82])rotate([protector_angle, 0, 0])cube([60, 60, 50], center=true);
      
    }
    
  }
}
module pen_top(){
    difference(){
      union(){
        cylinder(d=20.5, h=14, center=true);
        translate([-13, -1, -7+2])cube([26, 2, 4]);
        translate([13, 0, -4])cube([2, 6, 6], center=true);
        translate([-13, 0, -4])cube([2, 6, 6], center=true);
      }
      translate([0, 0, 2])cylinder(d=17.4, h=14, center=true);
    }
}

module eraser_holder(internal_diameter= 2.3, h=10, length=4) {
  difference() {
    union() {
      cylinder(d=6, h=h, $fn=20);
      translate([0, -3, 0])cube([length, 6, h]);
      translate([length, -3, 0])rotate([0, 0, 45])cube([sqrt(6*6/2) , sqrt(6*6/2), h]);
    }
    translate([0, 0.1, 0])cylinder(d=internal_diameter, h=h+0.2, $fn=20);
  }
}

module pen() {
  rotate([180, 0,0 ])translate([0,0, -121])union() {
    cylinder(d=4, h=128);
    cylinder(d=9, h=121);
    cylinder(d=14, h=111);
    cylinder(d=16, h=98);
  }
}

module rounded_cube(x, y, z, radius, margin=0) {
    $fn=8;
  translate([radius, radius, 0])hull() {
    cylinder(r=radius-margin, h=z);
    translate([x-radius*2, 0, 0])cylinder(r=radius-margin, h=z);
    translate([0, y-radius*2, 0])cylinder(r=radius-margin, h=z);
    translate([x-radius*2, y-radius*2, 0])cylinder(r=radius-margin, h=z);
  }
}

//mirror([1, 0, 0]) top_holder();

module top_holder() {
  arm_thick = 4.4;
  margin = 0.05;
  wall_thick = 1.5;
  blackboard_border_thick = 16.3;
  holder_thick = wall_thick * 2 + blackboard_border_thick;
  
  //anti warping
  difference() {
    translate([-5, -5])cube([holder_thick+10, 10, 0.4]);
    cylinder(d=5, $fn=10);
    translate([holder_thick/2, 0, 0])cylinder(d=5, $fn=10);
    translate([holder_thick, 0, 0])cylinder(d=5, $fn=10);
  }
  // blackboard support
  difference() {
    cube([holder_thick, 50, 50]);
    translate([wall_thick, -margin, wall_thick])
    cube([blackboard_border_thick, 50-wall_thick+margin, 50-wall_thick+margin]);
    translate([-margin/2, -blackboard_border_thick, blackboard_border_thick])
    cube([holder_thick+margin, 50-wall_thick, 50-wall_thick]);
    translate([-margin, 0, 8]) rotate([45, 0, 0])cube([holder_thick+margin*2, 80, 80]);
    
    //screw
    translate([holder_thick/2, 24, -margin]) cylinder(d=3, h=10, $fn=10);
  }
  // big arm
  translate([0, 50, 0])difference() {
    cube([holder_thick, 102, arm_thick]);
    translate([-20+5, 0, -margin])rounded_cube(20, 120, 10, 5);
    translate([20-5, 0, -margin])rounded_cube(20, 99, 10, 5);
    //translate([4, 0, 4])  cube([holder_thick-8, 94, 8]);
  }
  translate([(holder_thick/2)-2.5, 50, 0])
  union() {
    cube([5, 105, arm_thick+2.4]);
    cube([6, 1.2, 50]);
    intersection() {
      cube([8, 50, 50]);
      translate([2.5, 22, 22])rotate([45, 0, 0])cube([5, 9, 75], center=true);
    }
  }
  // cadeneta_holder
  difference() {
    translate([5, 148, 0]) {
      rounded_cube(holder_thick+35, 10, arm_thick, 3);
      translate([2.5, 4, 0])cube([holder_thick+35-2.5, 3.5, arm_thick +0.8]);
    }
    for(i = [holder_thick: 6.8 : (holder_thick+40)]) {
      union() {
        translate([i, 160-6, -margin]) cube([1.7, 5, 20]);
        translate([i+1, 160-6+0.85, -margin]) sphere(d=6, center=true, $fn=25);
      }
    }
  }
  translate([13.2, 89, 0])rotate([0, 0, 55])cube([73, 6, arm_thick]);
}

top_holder();
translate([-10, 0 ,0])mirror([1, 0, 0])top_holder();

//eraser_holder(internal_diameter= 3.1, h=4);
//eraser();
//nema16(front_screws = false, bottom_screws = true,show_body=true, big_holes=false);

