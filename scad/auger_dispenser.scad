$fa = 1;
$fs = 0.5;
$fn = 40;

$to = 0.3;

use <utils.scad>
use <funnel_box.scad>
use <auger.scad>
use <stepper2b.scad>

coneHeight = 75;
coneDiameter = 150;
coneHoleDiam = 25;

boxCircle = true;
funnelCircle = true;

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

screwHeight=100;
screwTurns=6;
screwDiam=pipeDiameter-$to*2;
screwThick=5;
screwCenter=4;
screwTerm=pipeWall;

heightAbovePipe = 5;
adapterHeight = heightAbovePipe+pipeDiameter/2;
insertSlotHeight = 6.5;

module augerDispenser()
{
	difference()
	{
		union()
		{
            translate([0,0,-pipeDiameter/2])
            cylinder(r=coneHoleDiam/2 + 1.5, h=adapterHeight);
            
            outside = coneHoleDiam+pipeWall;
            *translate([0,-outside/4-pipeWall/2,-adapterHeight/2 + heightAbovePipe])
            cube([outside/4,outside/2,adapterHeight], center=true);
            
			*funnelBoxOutside(coneHeight,
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

            //Screw plate
			translate([0,pipeWall])
			stepperTransform()
            {
                plateOffset = 6.5;
                plateL = pipeDiameter+pipeWall*2+plateOffset*2;
                
                cube([plateL,10,pipeWall],true);
                
                mirrorAdd([1,0])
                translate([plateL/2-6.5,-10/2])
                rotate([180,0,0])
                linear_extrude(pipeWall,center=true)
                polygon([[6.5, 0], [0,0], [0, 2.5]]);
                
                // Support Triangles
                /*
                mirrorAdd([1,0,0]) mirrorAdd([0,1,0])
                {
                    translate([0,10/2-pipeWall/4,-1])
                    rotate([90,90,0])
                    linear_extrude(pipeWall/2,center=true)
                    polygon([[plateL/2, 0], [0,0], [0, plateL/2]]);
                }
                */
            }
			
			pipeTransform()
			translate([0, 0, pipeLen / 2])
			cylinder(h=pipeWall, d=pipeDiameter+pipeWall*2);
            
			pipeTransform()
            for(i = [-1,1])
			translate([0, pipeDiameter/2+pipeWall-pipeDiameter/4-pipeWall/2, pipeLen/2 * i + pipeWall/2])
            {
                cube([pipeDiameter+pipeWall*2,pipeDiameter/2+pipeWall,pipeWall],true);
            }
		}
		
        union()
        {
            translate([0,0,-pipeDiameter/2])
            cylinder(r=coneHoleDiam/2, h=adapterHeight);
            translate([0,0,heightAbovePipe-insertSlotHeight+0.01])
            cylinder(r=coneHoleDiam/2+.75, h=insertSlotHeight);
        }
        
		*funnelBoxInside(coneHeight,
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

        //Screw plate
        translate([0,pipeWall])
        stepperTransform()
        for(i=[-1, 1])
        {
            translate([35/2*i,0,+0.01]) cylinder(d=6.5+$to,h=pipeWall/2, $fn=6);
            translate([35/2*i,0,-pipeWall/2-0.01]) cylinder(d=4, h=pipeWall);
        }
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
	
	//translate([0,$to])
	//screw();
	
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
	
	//translate([0,-$to/2,0]) 
	//pipeCap();

	/*
	*/
	//stepperTransform()  
	//translate([0,0,-$to])
	//stepper2b();
}

//crossSection()
{
    augerDispenser();
}