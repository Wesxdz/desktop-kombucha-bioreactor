$fa = 1;
$fs = 0.4;
$fn=200;

use <utils.scad>

coneHeight = 100;
coneDiameter = 100;
coneHoleDiam = 25;

rotate_extrude() polygon([[coneHoleDiam / 2, 0], [coneDiameter, 0], [coneDiameter, coneHeight]]);

pipeDiameter = 25;
pipeWall = 3;
pipeLen = 100;

pipeTrans = [0, pipeLen/2 - coneHoleDiam / 2 - pipeWall, -pipeDiameter / 2 - pipeWall];
miniPipeTrans = [0, 0, -pipeDiameter / 4];

difference()
{
	translate(miniPipeTrans) 
	{
		pipe(coneHoleDiam, pipeWall, coneHoleDiam / 2);
	}
	
	translate(pipeTrans) rotate([90]) 
	{
		pipeInside(pipeDiameter, pipeWall, pipeLen);
	}
}

difference()
{
	translate(pipeTrans) rotate([90])
	{
		pipe(pipeDiameter, pipeWall, pipeLen);
	}
	
	translate(miniPipeTrans)
	{
		pipeInside(coneHoleDiam, pipeWall, coneHoleDiam / 2);
	}
}

screwHeight=100;
screwTurns=6;
screwDiam=pipeDiameter;
screwThick=5;
screwCenter=4;

translate(pipeTrans) rotate([90]) 
translate([0, 0, -pipeLen / 2]) union()
{
	cylinder(h=screwHeight, r=screwCenter);
	
	linear_extrude(height=screwHeight, twist=screwTurns*360) union()
	{	
		screwQuareSize = screwDiam/2 - screwThick / 2;
		translate([screwQuareSize / 2, 0]) square([screwQuareSize, screwThick], true);
		translate([screwQuareSize, 0, 0]) circle(r=screwThick/2);
	}
}