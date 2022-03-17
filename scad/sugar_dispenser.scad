//$fa = 1;
//$fs = 0.4;
$fn = 40;

$to = 0.3;

use <utils.scad>
use <funnel_box.scad>
use <auger.scad>
use <stepper2b.scad>

coneHeight = 75;
coneDiameter = 150;
coneHoleDiam = 25;

boxCircle = false;
funnelCircle = false;

pipeDiameter = 25;
pipeWall = 3;
pipeLen = 100;

pipeTrans = 
[
	0, 
	pipeLen/2 - coneHoleDiam/2 - pipeWall, 
	-pipeDiameter/2 - pipeWall
];

pipeRot = 
[
	-90, 
	0,
	0
];

module pipeTransform()
{
	translate(pipeTrans) rotate(pipeRot) children();
}

module stepperTransform()
{
	pipeTransform()
	rotate([0, 0, 180]) 
	translate([0, 0, -pipeLen / 2])
	translate([0,-8,-1.5])
	children();
}

screwHeight=pipeLen;
screwTurns=6;
screwDiam=pipeDiameter-$to*2;
screwThick=5;
screwCenter=4;
screwTerm=pipeWall;

module sugarDispenser()
{
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
			
			pipeTransform()
			{
				pipeOutside(pipeDiameter, pipeWall, pipeLen);
			}

			translate([0,1.5])
			stepperTransform()
			scale([1,1,-1.5])
			difference()
			{
				scale([1.025, 1.1, 1])
				union()
				{
					stepper2b_mountingPlate(holes=false);
				}
				
				translate([0,0])
				for(i=[-1, 1])
				{
					translate([35/2*i,0, -1.015]) cylinder(d=6.5+$to,h=0.5, $fn=6);
					translate([35/2*i,0, -0.52]) cylinder(d=4, h=0.6);
				}
			}
			
			pipeTransform()
			translate([0, 0, pipeLen / 2])
			cylinder(h=pipeWall, d=pipeDiameter+pipeWall*2);
		}
		
		funnelBoxInside(coneHeight,
			coneDiameter,
			coneHoleDiam,
			pipeWall,
			coneHoleDiam/2+pipeWall,
			boxCircle,
			funnelCircle);
		
		pipeTransform()
		{
			pipeInside(pipeDiameter, pipeWall, pipeLen);
		}
			
		pipeTransform()
		translate([0, 0, pipeLen/2-pipeWall/2+$to])
		cylinder(h=pipeWall, r=screwCenter+$to*2);
			
		pipeTransform()
		translate([0, coneHoleDiam/2, pipeLen/2-coneHoleDiam/2])
		cube(coneHoleDiam, center=true);
	}

	module screw()
	{
		pipeTransform()
		translate([0, 0, -pipeLen / 2])
		difference()
		{
			union()
			{
				translate([$to,0])
				auger(screwHeight-pipeWall, screwDiam, screwCenter, screwTurns, screwThick);
				
				linear_extrude(screwTerm) circle(d=screwDiam);
			}
			
			minkowski()
			{
				translate([0,0,-2.01]) stepper2b_pin();
				cube($to, center=true);
			}
		}
		
		pipeTransform()
		translate([0, 0, pipeLen / 2 - pipeWall - $to])
		cylinder(h=pipeWall*1.5, r=screwCenter);
	}
	
	translate([0,$to])
	screw();
	
	module pipeCap()
	{
		difference()
		{
			union()
			{
				pipeTransform()
				translate([0, 0, -pipeLen/ 2])
				translate([0,0,-pipeWall/2]) 
				linear_extrude(pipeWall/2) circle(d=pipeDiameter+pipeWall*2);
					
				translate([0,1.5])
				stepperTransform()
				scale([1,1,1.5])
				stepper2b_mountingPlate();
			}
			
			pipeTransform()
			translate([0, 0, -pipeLen/ 2])
			translate([0,0,-pipeWall/2]) 
			translate([0, 0, -0.1])
			linear_extrude(pipeWall/2+0.2) circle(d=9+$to*2);
		}
	
	}
	
	translate([0,-$to/2,0]) 
	pipeCap();

	/*
	*/
	stepperTransform()  
	translate([0,0,-$to])
	stepper2b();
}

crossSection()
{
	sugarDispenser();
}