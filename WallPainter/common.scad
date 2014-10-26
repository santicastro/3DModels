use <common.scad>

//$fn=20;

module m3_hole() {
  translate([-2.85, -2.85, 0])linear_extrude(2.35) union() {
    square([5.7, 12.5]);
    polygon(points=[[0,0], [5.7, 0], [2.85, -1]]);
  }
  translate([0,0,-4])cylinder(r=1.6,h=16);
}

//nema17(true, true, true);
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

module nema17(show_screws = false, show_body=true, big_holes=false) {
  screw_holes_length = 10;
  if(show_body) {
    cylinder(r=2.5, h=34+24);
    cylinder(r=11.3, h=34+2);
    translate([-21, -21, 0]) cube([42.3, 42.3, 34]);
  }
  if(show_screws) {
    hull() {
      translate([15.5, 15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
      if(big_holes) translate([13, 13, 34]) cylinder(r=1.55, h=screw_holes_length);
    }
    hull() {
      translate([-15.5, 15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
      if(big_holes) translate([-13, 13, 34]) cylinder(r=1.55, h=screw_holes_length);
    }
    hull() {
      translate([15.5, -15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
      if(big_holes) translate([13, -13, 34]) cylinder(r=1.55, h=screw_holes_length);
    }
    hull() {
      translate([-15.5, -15.5, 34]) cylinder(r=1.55, h=screw_holes_length);
      if(big_holes) translate([-13, -13, 34]) cylinder(r=1.55, h=screw_holes_length);
    }
    
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

module pen_holder_testing() {
  // móvil
  rotate([0, 90, 0]) //eje
  intersection() {
    translate([-1, 0, 0])cylinder(d=3, h=15, $fn=30);
    translate([-3, -1.5, 0])cube([3, 3, 15]);
  }
  difference() {
    cube([15, 30, 1.6]);
    translate([3, 0, 0]) cube([9, 4.4, 5]);
  }
  
  //base
  translate([20, 0, 0])union() {
    cube([20, 15, 1.2]);
    rotate([0, 90, 0])
    translate([-1.55-1.2-0.8, 6, 6])difference() {
      cylinder(d=7, h=8.5, $fn=20);
      cylinder(d=3.1, h=8.5, $fn=20);
      translate([-3, 0, 8.5/2])cube([6, 1.95, 8.5], center=true);
    }
  }
}
intersection() {
  eraser();
  //translate([10, -20, 0])cube([36, 50, 30]);
}

module eraser(base_width = 120, eraser_width=100, base_weight=3) {
  hole_width = eraser_width/2 - 2.5;
  margins = (base_width - eraser_width) / 2;
  //mobile part
  rotate([-45])difference() {
    union() {
      cube([eraser_width, 7, 10]);//cuerpo de soporte de fieltro
      translate([10, 3, 13.3])rotate([0, 90, 0])eraser_holder();
      translate([eraser_width-20, 3, 13.3])rotate([0, 90, 0])eraser_holder();
      // pestaña al servo
      translate([47, 3.2, 2])rotate([45, 0, 0])
      intersection() {
        translate([-4.5, -4, 0])cube([9, 7.4, 30]);
        rotate([8, 0, 0])
        translate([-2, 0, 0])union() {
          difference() {
            cube([4, 3, 35]);
            translate([-1, 5, 17.2])rotate([0, 90, 0])cylinder(d=4, h=10, $fn=20);
          }
          translate([-2.5, -3.5, 0])rotate([0, 0, 45])cube([6, 1.2, 35]);
          translate([1.8, 1, 0])rotate([0, 0, -45])cube([6, 1.2, 35]);
          
          translate([4, 0.55, 0])rotate([0, 0, 75])cube([4, 1.2, 35]);
          translate([-1, 4.5, 0])rotate([0, 0, -75])cube([4, 1.2, 35]);
        }
      }
    }
    
    union() {
      rotate([-45])cube([eraser_width, 50, 50]);
      //agujeros del cuerpo soporte de fieltro
      translate([2,1.1]) union() {
        cube([hole_width, 4.8, 8]);
        translate([hole_width+1, 0, 0])cube([hole_width, 4.8, 8]);
      }
    }
  }
  //servo
  //%	translate([7.3, 15, 23.7])rotate([180, 0, 90])servo_mg90s();
  //%translate([46.7, 20.0, 17.1])rotate([180, 180, 90])servo_mg90s(head_rotation=170, steps=4);
  
  //pen
  %	translate([base_width/2-margins-1.5, 47, 4.6])rotate([-30, 0,0 ])pen();
  
  //base
  translate([0, 11.5, 7.2])
  union() {
    color("green")difference() {
      translate([-margins, 3.4-30, -3])cube([base_width, 47, base_weight]);
      translate([-2, -17, -4])cube([eraser_width + 4, 20.8, 10]);
      translate([0, 28, -4])rotate([0, 0, 35])cube([40, 20, 10], center=true);
      translate([base_width-20, 28, -4])rotate([0, 0, -35])cube([40, 20, 10], center=true);
    }
    translate([42, 15.4, -3])cube([14, 3, 6]);
    
    translate([29.2, 14.9, -3])cube([4, 5.2, 20]);
    translate([37, 14.9, -3])cube([4, 5.2, 20]);
    translate([29.2, 14.9, 16.25])cube([11.8, 5.2, 1.4]);
    translate([29.2, 15.8, 9.25])cube([11.8, 4.3, 1]);
    
    %translate([11, 8, -3])cube([3.2, 7.3, 10]);
    %translate([11, 14.9, -3])cube([15, 2, 10]);
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
    translate([eraser_width-9.5, 0, 0])rotate([0, 90, 0])rotate([0, 0, 90])eraser_holder(internal_diameter=2.1, h=9.5);
    
    //  pen_holder_support
    /*
    translate([40.7,-23.5, 6.3])rotate([0, 90, 0])eraser_holder(internal_diameter= 3.2, h=8);
    translate([55.3,-23.5, 6.3])rotate([0, 90, 0])eraser_holder(internal_diameter= 3.2, h=8);
    translate([40.7,-26.5, 0])cube([22.6, 6, 2.5]);*/
  }
  /////////////////////////////////////////////
  //color("blue")translate([38, -12, 10.5])pen_holder();
  /////////////////////////////////////////////
}

module pen_holder() {
  protector_angle = 30;
  tower_height = 8;
  //holder base
  difference() {
    union() {
      difference() {
        cube([21, 80, 3]);
        translate([0, 39/2+9/2, 0])cube([14*2, 30, 3.1*2], center=true);
      }
      translate([-1, 0, 0])cube([30, 10, 3]);
      translate([14, 0, 3])rotate([0, 90, 0])cylinder(d=6, h=30, $fn=25, center=true);
    }
    translate([6.6, 0, 2])rotate([0, 90, 0])cylinder(d=8.5, h=8.5, $fn=25, center=true);
    translate([21.3, 0, 2])rotate([0, 90, 0])cylinder(d=8.5, h=8.5, $fn=25, center=true);
    translate([14, 0, 3])rotate([0, 90, 0])cylinder(d=3.15, h=30+1, $fn=25, center=true);
    translate([10.5, 59.6, -5])rotate([-protector_angle, 0, 0])translate([0, 0, 5])union() {
      cylinder(d=16, h=15);
      cylinder(d=10, h=30, center=true);
    }
  }
  
  //tower
  translate([11.5, 42, 0])rotate([0, -90, 0])union() {
    hull() {
      translate([0, -5.5, 0])cube([1, 8.5, 5]);
      translate([tower_height, 0, 0])cylinder(d=4, h=5);
    }
    translate([tower_height, 0, 0])cylinder(d=6, h=1.15);
    translate([tower_height, 0, 5-1.15])cylinder(d=6, h=1.15);
  }
  
  //pen protector
  translate([10.5, 90, 48])
  difference() {
    rotate([-protector_angle, 0, 0])difference() {
      union() {
        cylinder(d=20.5, h=120, center = true);
        translate([0, -10.25, 0])cylinder(d=3, h=120, center=true, $fn=10);
        translate([0, 10.25, 0])cylinder(d=3, h=120, center=true, $fn=10);
      }
      cylinder(d=17.5, h=122, center=true);
      translate([6, 0, -70])rotate([45, 0, 0])cube([15, 30, 30]);
      translate([-20, 0, -70])rotate([45, 0, 0])cube([15, 30, 30]);
      
      translate([0,-19, -30])rotate([45, 0, 90])cube([15, 30, 30]);
      
      translate([6, 0, 10])rotate([45, 0, 0])cube([15, 30, 30]);
      translate([-20, 0, 10])rotate([45, 0, 0])cube([15, 30, 30]);
      
      translate([0, 0, -82])rotate([protector_angle, 0, 0])cube([60, 60, 50], center=true);
    }
    
  }
}

module eraser_holder(internal_diameter= 2.3, h=10) {
  difference() {
    union() {
      cylinder(d=6, h=h, $fn=20);
      translate([0, -3, 0])cube([3.8, 6, h]);
      translate([3.8, -3, 0])rotate([0, 0, 45])cube([sqrt(6*6/2) , sqrt(6*6/2), h]);
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

