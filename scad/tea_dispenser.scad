$fa = 1;
$fs = 0.4;
$fn = 200;

use <utils.scad>
use <funnel_box.scad>
use <auger.scad>

coneHeight = 75;
coneDiameter = 150;
coneHoleDiam = 25;

boxCircle = false;
funnelCircle = false;

pipeDiameter = 50;
pipeWall = 3;
pipeLen = 25 + pipeWall * 2;

pipeTrans = 
[
	0, 
	pipeLen/2 - coneHoleDiam/2 - pipeWall, 
	-pipeDiameter/2 - pipeWall
];

difference()
{
	union()
	{
		funnelBoxOutside(coneHeight,
		coneDiameter,
		coneHoleDiam,
		pipeWall,
		coneHoleDiam/2+pipeWall,
		boxCircle,
		funnelCircle);
		
		translate(pipeTrans) rotate([90])
		{
			pipeOutside(pipeDiameter, pipeWall, pipeLen);
		}
	}
	
	funnelBoxInside(coneHeight,
		coneDiameter,
		coneHoleDiam,
		pipeWall,
		coneHoleDiam/2+pipeWall,
		boxCircle,
		funnelCircle);
	
	translate(pipeTrans) rotate([90]) 
	{
		pipeInside(pipeDiameter, pipeWall, pipeLen);
	}
}

paddleCenter = 10;
paddleWidth = 5;
paddleRadius = 5;
paddleCount = 7;

module paddleWheel(lenght, diama, core, thick, count)
{
	padRad = thick;
	
	cylinder(lenght, core, core, center=true);
	
	for(i = [0 : count])
	{
		rotate([0,0,360/count*i]) union()
		{
			linear_extrude(lenght, center=true) 
			{
				intersection()
				{
					translate([diama/2 - padRad/2, 0])		 	circle(padRad/2);
				
					translate([0, -thick/2]) square([diama/2, thick]);
				}
				
				translate([0, -thick/2]) square([diama/2 - padRad/2, thick]);
			}
		}
	}
}

translate(pipeTrans) rotate([90, $t*360, 0])
{
	paddleWheel(pipeLen, pipeDiameter, paddleCenter, paddleWidth, paddleCount);
}
