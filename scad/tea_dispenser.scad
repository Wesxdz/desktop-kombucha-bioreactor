$fa = 1;
$fs = 0.4;
$fn = 200;

use <utils.scad>
use <funnel_box.scad>
use <auger.scad>
use <paddle_wheel.scad>

coneHeight = 75;
coneDiameter = 150;
coneHoleDiam = 25;

boxCircle = false;
funnelCircle = false;

pipeDiameter = coneHoleDiam*2;
pipeWall = 3;
pipeLen = coneHoleDiam;

coneTunnel = pipeDiameter + pipeWall*2;

pipeTrans = 
[
	0, 
	0, 
	-pipeDiameter/2 - pipeWall
];

paddleCenter = 10;
paddleWidth = 5;
paddleRadius = 5;
paddleCount = 7;

module teaDispenser()
{
	difference()
	{
		union()
		{
			funnelBoxOutside(coneHeight,
			coneDiameter,
			coneHoleDiam,
			pipeWall,
			coneTunnel,
			boxCircle,
			funnelCircle);
			
			translate(pipeTrans) rotate([90])
			{
				pipeOutside(pipeDiameter, pipeWall, pipeLen);
				
				for(i=[1,-1])
				{
					translate([0, 0, (pipeLen+pipeWall)/2*i]) 
					 linear_extrude(pipeWall, center=true) 
					  circle(d=pipeDiameter + pipeWall*2);
				}
			}
		}
		
		funnelBoxInside(coneHeight,
			coneDiameter,
			coneHoleDiam,
			pipeWall,
			coneTunnel,
			boxCircle,
			funnelCircle);
		
		translate(pipeTrans) rotate([90]) 
		{
			pipeInside(pipeDiameter, pipeWall, pipeLen);
		}
	}

	translate(pipeTrans) rotate([90, 0, 0])
	{
		paddleWheel(pipeLen, pipeDiameter, paddleCenter, paddleWidth, paddleCount);
	}
}

crossSize=1000;

intersection()
{
	teaDispenser();
	
	rotate([0, 0, 0]) translate([crossSize/2, 0, 0]) 
	linear_extrude(crossSize, center=true) square(crossSize, center=true);
}
