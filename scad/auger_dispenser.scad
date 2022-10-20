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

screwHeight=pipeLen;
screwTurns=5.5;
screwStopDiam=pipeDiameter-$to*2;
screwDiam=screwStopDiam+$to;
screwThick=3;
screwCenter=3;
screwTerm=pipeWall;
screwClearLen=coneHoleDiam/2;
screwEndDiam=8;
screwHelixCount=1;

heightAbovePipe = 5;
adapterHeight = heightAbovePipe+pipeDiameter/2;
insertSlotHeight = 6.5;

topMargin = 10;

module augerDispenser()
{
	*difference()
	{
		union()
		{
            translate([0,0,-pipeDiameter/2])
            cylinder(r=coneHoleDiam/2 + 1.5, h=adapterHeight+topMargin);
            
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
			
            offsetPipeLength = pipeLen - coneHoleDiam/2;
            translate([0,coneHoleDiam/4 + pipeWall,topMargin])
			pipeTransform()
			{
				pipeOutside(pipeDiameter, pipeWall, offsetPipeLength);
			}
            
            translate([0,coneHoleDiam/4 + pipeWall,topMargin / 2])
			pipeTransform()
			{
                cube([pipeDiameter + pipeWall * 2, topMargin, offsetPipeLength], true);
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
			
            // End cap
			pipeTransform()
			translate([0, 0, pipeLen / 2])
			cylinder(h=pipeWall, d=pipeDiameter+pipeWall*2);
            
            // Bottom supports
			pipeTransform()
            for(i = [-1,1])
			translate([0, pipeDiameter/2+pipeWall-pipeDiameter/4-pipeWall/2, pipeLen/2 * i + pipeWall/2])
            {
                cube([pipeDiameter+pipeWall*2,pipeDiameter/2+pipeWall,pipeWall],true);
            }
		}
		
        union()
        {
            translate([0,0,-pipeDiameter/2-pipeWall])
            cylinder(r=coneHoleDiam/2, h=adapterHeight+topMargin+pipeWall);
            translate([0,0,heightAbovePipe-insertSlotHeight+topMargin+0.01])
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
			
        offsetPipeLength = pipeLen - coneHoleDiam/2;
        translate([0,coneHoleDiam/4+pipeWall/2,topMargin])
        pipeTransform()
        {
            pipeInside(pipeDiameter, pipeWall, offsetPipeLength - pipeWall);
        }
        
        translate([0,coneHoleDiam/4+pipeWall/2,topMargin/2])
        pipeTransform()
        {
            cube([pipeDiameter, topMargin, offsetPipeLength - pipeWall], true);
        }
		
        // End cap hole
		pipeTransform()
		translate([0, 0, pipeLen/2-pipeWall/2+$to])
		cylinder(h=pipeWall, r=screwEndDiam/2+$to*2);
			
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
        realScrewLen = screwHeight-screwTerm-$to-screwClearLen;
                
		pipeTransform()
		translate([0, 0, -pipeLen / 2])
		difference()
		{
            rotate([0,0,$t*360])
			union()
			{
                for(i = [0:screwHelixCount])
                {
                    rotate([0,0,360/screwHelixCount*i])
                    translate([0, 0, screwTerm])
                    {
                        auger(realScrewLen, screwDiam, screwCenter, screwTurns, screwThick);
                        
                        // start fill
                        difference()
                        {
                            startFill = 6;
                            ratio = startFill / realScrewLen;
                            
                            slices = realScrewLen*5 * ratio;
                            for(i = [0:slices])
                            {
                                rotate([0,0,i/slices*screwTurns*ratio*-360])
                                translate([0,0,i/slices*startFill-startFill])
                                linear_extrude(height=startFill, convexity=4) union()
                                {	
                                    rectSize = screwStopDiam/2 - screwThick/2;
                                    translate([rectSize / 2, 0]) square([rectSize, screwThick], true);
                                    translate([rectSize, 0, 0]) circle(r=screwThick/2);
                                }
                            }
                            
                            translate([0, 0, -startFill*2])
                            linear_extrude(startFill*2) circle(d=screwStopDiam+0.1);
                        }
                    }
                }
                
				linear_extrude(screwTerm) circle(d=screwStopDiam);
			
                centerHolderDiam = stepper2b_pinDiam() + 3;
                centerHolderLen = 8;
                
                linear_extrude(centerHolderLen) circle(d=centerHolderDiam);
                translate([0,0,centerHolderLen]) sphere(centerHolderDiam / 2);
			}
			
			minkowski()
			{
				translate([0,0,-2.01]) stepper2b_pin();
				cube($to, center=true);
			}
		}
                
		pipeTransform()
        {
        }
		
        // end extension
		pipeTransform()
		translate([0, 0, -pipeLen / 2 + screwTerm + realScrewLen])
		cylinder(h=pipeLen+pipeWall/2-realScrewLen-pipeWall-$to, r=screwCenter,center=false);
        
        //end ball
		difference()
		{
            pipeTransform()
            translate([0, 0, pipeLen/2+screwTerm-pipeWall/2-$to])
            sphere(d=screwEndDiam);
            
            pipeTransform()
            translate([0, 0, pipeLen/2+screwTerm-pipeWall/2-$to+screwEndDiam/2])
            cube([screwEndDiam,screwEndDiam,screwEndDiam],center=true);
        }
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
	
	*translate([0,-$to/2,0]) 
	pipeCap();


	*stepperTransform()  
	translate([0,0,-$to])
	stepper2b();
}

//crossSection()
{
    augerDispenser();
}