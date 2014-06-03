// based on support on: http://www.thingiverse.com/thing:179605

$fn = 60;

module part(){
cylinder_height = 35;
difference(){
cylinder(d=31, h=cylinder_height);
cylinder(d=24, h=cylinder_height);
}

thickness = 7.5;

linear_extrude(height=thickness)	
difference(){
polygon(points=[
[0,-13],
[9.5,-10],
[11.8,-86.5],
[-5, -96],
[-4, -106],
[-10.2, -110],
[-9.5,-10]
]);
polygon(points=[
[5,-24],
[6.5,-86.5],
[-5.4,-86.5],
[-5,-24]
]);

}

color("red")translate([5, -124,0])rotate([0,0,30])
difference(convexity = 20){
	union(){
		translate([0,-1,0])rcube([24.8, 33, thickness], 3);
		translate([-20, 9, 0])rcube([40, 13, thickness], 3);
		translate([19.8,2,0])
		union(){
			cube([5, 10, thickness*2]);
			translate([2,0,0])cylinder(r=3, h=thickness*2);
			translate([-6,-3,0])cube([8,6,thickness*2]);
		}
	}
translate([-20, 4.5, 0])cube([40, 6.8, thickness*2]);
translate([5, 17, 0])cube([13, 10, thickness*2]);
translate([-12, 25, thickness/2])rotate([90,0,0])cylinder(d=4, h=20);	
translate([57.6, 110, thickness])cylinder(r=105.9, h= thickness); // max coil radius
}
}

module rcube(vector, radius){
	hull(){
		translate([radius, radius, 0])cylinder(r=radius, h = vector[2]);
		translate([vector[0]-radius, radius, 0])cylinder(r=radius, h = vector[2]);
		translate([vector[0]-radius, vector[1]-radius, 0])cylinder(r=radius, h = vector[2]);
		translate([radius, vector[1]-radius, 0])cylinder(r=radius, h = vector[2]);
	}
}

part();
translate([-45, -120])rotate([0,0,180])mirror([1,0,0])part();
/*
cylinder_height =  80;
translate([30, -50])
difference(){
cylinder(r=11.6, h=cylinder_height);
cylinder(r=9.6, h=cylinder_height);
}
*/