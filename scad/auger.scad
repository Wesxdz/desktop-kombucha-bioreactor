$fa = 1;
$fs = 0.5;
$fn = 40;

module auger(height, diameter, centerDiameter, turns, thickness)
{
	cylinder(h=height, r=centerDiameter);
	
	linear_extrude(height=height, twist=turns*360, convexity=4, slices=height*3) union()
	{	
		rectSize = diameter/2 - thickness/2;
		translate([rectSize / 2, 0]) square([rectSize, thickness], true);
		translate([rectSize, 0, 0]) circle(r=thickness/2);
	}
}


Height=100;
Turns=6;
Diam=25;
Thick=5;
Center=4;

auger(Height, Diam, Center, Turns, Thick);