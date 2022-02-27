$fa = 1;
$fs = 0.4;
$fn=200;

use <utils.scad>

coneHeight = 100;
coneDiameter = 100;
coneHoleDiam = 25;


module funnelBox(height=100, diameter=200, hole=25, wall=3)
{
	
	difference()
	{
		union()
		{
			rotate_extrude() 
			{
				points = 
				[
					[hole/2, 0], 
					[hole/2 + wall, 0],
					[diameter/2 + wall, height],
					[diameter/2, height],
				];
				
				polygon(points);
				
			}
			translate([0, 0, -hole/3]) cube([hole+wall*2, hole+wall*2, hole], center=true);
		}
		
		translate([0, 0, -hole/2])  cube([hole, hole, hole+10000], center=true);
	}
}

funnelBox();