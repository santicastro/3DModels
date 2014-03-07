use <mendel_misc.inc>
use <modified_parametric_involute_gear_v5.0.scad>
///////////////////////////////////////////////////////////////////////////////
//// C O N F I G U R A T I O N 
///////////////////////////////////////////////////////////////////////////////

/*
//DEFAULT CONFIGS
nut_diameter = 8;
nut_thickness = 6;
screw_hole_diameter = 5;
srew_head_diameter = 9;
axis_radius = 5;
axis_thickness = 20;
rim_thickness = 20;
trisquel_thickness = 12;
gear_radius = 100;
*/
/*
//  r_35_t_M2
nut_diameter = 3.8;
nut_thickness = 1.5;
screw_hole_diameter = 2;
screw_head_diameter = 3.8;
axis_radius = 1.6;
axis_thickness = 8;
rim_thickness = 5.5;
trisquel_thickness = 3;
gear_radius = 35;
*/
//  r_18_llavero
nut_diameter = 0;
nut_thickness = 0;
screw_hole_diameter = 0;
screw_head_diameter = 0;
axis_radius = 1;
axis_thickness = 4;
rim_thickness = 4;
trisquel_thickness = 3;
gear_radius = 18;


show_trisquel = true;
show_gear = true;
rounded_axis = true;

//INTERNAL PARAMETERS
fn_val = 75;
gear_empty_angle=95;
///////////////////////////////////////////////////////////////////////////////
//// D R A W
///////////////////////////////////////////////////////////////////////////////
//draw_scale = gear_diameter(number_of_teeth = teeth,
//      circular_pitch = 2000*draw_scale);

draw_scale = 2*gear_radius/gear_diameter(number_of_teeth = 9, circular_pitch = 2000);

difference() {
union(){
  // TRISKEL
  if(show_trisquel) {
      union() {
        color("red")triskele(trisquel_thickness);
        color("red") 
        if(rounded_axis){
          intersection() {
          translate([0,0,trisquel_thickness])color("violet")
            cylinder_round(internal_radius=draw_scale*17.1,
                           external_radius=draw_scale*17.1+(axis_thickness-trisquel_thickness), 
                           margin=draw_scale*17.1, 
                           fn_val=fn_val);
           translate([0, 0, trisquel_thickness])triskele(trisquel_thickness);
          }
        }else{
          translate([0, 0, trisquel_thickness])
            cylinder(h=axis_thickness-trisquel_thickness, r=17.1*draw_scale, $fn=fn_val);
        }
      }
  }
// GEAR
  if(show_gear){
    difference (){
      Wades();

      rotate([0,0,-90-gear_empty_angle/2])
      partial_rotate_extrude(angle=gear_empty_angle, radius=120*draw_scale, convex=30);

      color("blue")translate([0,0,trisquel_thickness/2.5/2])
      scale([30*draw_scale, 30*draw_scale, 1])
          linear_extrude(height = trisquel_thickness/2.5, center = true)
          import(file = "Triskele_centered_with_connectors_extract.dxf");
    }
  }

}
triple_nut();
axis_cylinder();
}

///////////////////////////////////////////////////////////////////////////////
//// A U X I L I A R   F U N C T I O N S
///////////////////////////////////////////////////////////////////////////////
module Wades(){
  teeth = 9;
  rotate([0,0,10])
    gear (number_of_teeth = teeth,
      circular_pitch = 2000*draw_scale,
      gear_thickness = rim_thickness,
      rim_thickness = rim_thickness,
      bore_diameter = 216.5*draw_scale);
}

module pie_slice(radius, angle, step) {
  for(theta = [0:step:angle-step]) {
    rotate([0,0,0]) linear_extrude(height = radius*2, center=true)
    polygon( points = [[0,0],[radius * cos(theta+step) ,radius * sin(theta+step)],[radius*cos(theta),radius*sin(theta)]]);
  }
}

module axis_cylinder(){
  translate([0,0, -0.05])
  cylinder(h=axis_thickness*1.1, r=axis_radius, convexity=10, $fn=fn_val);
}

module nut(){
  union() {
   hexagon(nut_diameter, nut_thickness);
   color("violet")translate([0,0, -5])
     cylinder(h=rim_thickness+10, r=screw_hole_diameter/2, $fn=fn_val);
   translate([0,0,(rim_thickness-nut_thickness)]) 
     cylinder(h=rim_thickness, r=screw_head_diameter/2, $fn=fn_val);
  }
}

module triple_nut(){
  holes_to_center = 116.5*draw_scale;
  color("blue")
  union(){
    translate([0, holes_to_center, 0])nut();
    rotate(a=[0,0,120], v=[0,0,0])translate([0, holes_to_center, 0])nut();
    rotate(a=[0,0,-120], v=[0,0,0])translate([0, holes_to_center, 0])nut();
  }
}

module partial_rotate_extrude(angle, radius, convex) {
  intersection () {
    rotate_extrude(convexity=convex) translate([radius,0,0]) child(0);
    pie_slice(radius*2, angle, angle/5);
  }
}

module triskele(trisquel_thickness){
  scale([30*draw_scale, 30*draw_scale, 1])translate([0, 0, trisquel_thickness/2])
  linear_extrude(height = trisquel_thickness, center = true, convexity = 20)
    import(file = "Triskele_centered_with_connectors.dxf");
}

module cylinder_round(internal_radius, external_radius, margin, fn_val){
  height = external_radius-internal_radius;
  delta_radius=external_radius-internal_radius;

  rotate_extrude(convexity = 10, $fn=fn_val)
  translate([internal_radius, 0, 0])rotate([90,0,0])
  difference() {
    translate([-margin, -margin, 0]) square(delta_radius + margin);
    translate([delta_radius,delta_radius,0]) circle(delta_radius, $fn=fn_val);
  }
}
