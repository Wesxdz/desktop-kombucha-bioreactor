use<utils.scad>;

$fa = 1;
$fs = 0.5;
$fn = 40;

$w=3;
$tol=0.3;

plateW=30.1;
plateL=100;
plateT=0.6;
plateD=70;

filterD=57.5;
filterBottomD=53.3;
filterH=63.5;
filterCOM = [0, 0, -filterH];

beakerH=146;
beakerD=100.1;
beakerR=beakerD/2;
beakerW=2.5;
beakerPos = [0, 0, -beakerH - 4];

grabberDim = [(plateL-filterD)/2+$w, plateW+$w*2, $w*2+plateT];
grabberPos = [plateL/2+$w-grabberDim[0]/2, 0, 0];

leverDim = [grabberDim[2], 50, grabberDim[2]];

pinPos = [plateL/2+$w, -plateW/2-30, 0];
hookYPos = pinPos.y - 45;
hookStartPos = [grabberPos[0]-grabberDim[0]/2+leverDim.x/2, hookYPos, 150];
hookEndPos = [grabberPos[0]-grabberDim[0]/2+leverDim.x/2, hookYPos, -40];
hookDiameter = 10;

armStartPos = [grabberPos[0]-grabberDim[0]/2+leverDim.x/2, pinPos.y + 40, 0];
armEndPos = [grabberPos[0]-grabberDim[0]/2+leverDim.x/2, -grabberDim[1]/2-leverDim.y, 0];

tipOverAngle = angle(filterCOM - [0, pinPos.y, pinPos.z], [0,0,1]);
targetTipAngle = tipOverAngle + 12.5;

leverStartPos = armStartPos;

function yIntercept(p1, p2, xPos) =
    let(v = p2-p1)
    let(m = v.y/v.x)
    let(b=p1.y-m*p1.x)
    [xPos, xPos * m + b];

function computeLeverMid() =
    let(relativeHookEnd = rotate([-targetTipAngle,0,0]) * (hookEndPos - pinPos) + pinPos)
    let(t = circleTangentPoints(YZtoXY(relativeHookEnd), hookDiameter/2 + leverDim.x/2, 
                                YZtoXY(armStartPos))[0])
                                
    let(tempMid = [armStartPos.x, t.x, t.y])
    
    let(leverNorm = normalize(tempMid - leverStartPos))
    let(leverLength = norm(tempMid - leverStartPos) + 20)
    leverStartPos + leverNorm * leverLength;
    
leverMidPos = computeLeverMid();
    
function computeLeverEnd() =
    let(relativeHookEnd = rotate([-targetTipAngle,0,0]) * (hookEndPos - pinPos) + pinPos)
    let(t = circleTangentPoints(YZtoXY(relativeHookEnd), hookDiameter/2 + leverDim.x/2, 
                                YZtoXY(armStartPos))[0])
                                
    let(hookTarget = XYtoYZ(yIntercept(YZtoXY(leverStartPos), YZtoXY(leverMidPos), hookYPos), leverStartPos.x))
    
    let(leverNorm = normalize(leverMidPos - leverStartPos))
    let(leverLength = norm(hookTarget - leverStartPos) + hookDiameter)
    
    [leverMidPos.x, hookYPos - hookDiameter, leverMidPos.z + 20];
 
leverEndPos = computeLeverEnd();

function YZtoXY(v) = [v.y, v.z];
function XYtoYZ(v, x=0) = [x, v.x, v.y]; 

function rotationFromHookSegment(hookPos, start, end) =  
    let(projectedPoint = closestPointOnSegment(YZtoXY(start), YZtoXY(end), YZtoXY(pinPos)))
    let(dist = norm(projectedPoint - YZtoXY(pinPos)))
    
    let(segments = circleToCicleInteriorTangentSegments(
                YZtoXY(pinPos), dist, 
                YZtoXY(hookPos), hookDiameter/2 + leverDim.x/2
            )
       )
       
    let(hookPoint = XYtoYZ(segments[1][1], pinPos.x))
    let(leverPoint = XYtoYZ(segments[1][0], pinPos.x))
    
    let(hookDist = norm(hookPoint - leverPoint))
    let(leverLen = norm(XYtoYZ(projectedPoint, pinPos.x) - end))
    
    let(a = angle(pinPos - leverPoint, 
          pinPos - XYtoYZ(projectedPoint, pinPos.x)))
          
    hookDist > leverLen ? 0 : a;

function rotationFromHook(hookPos) =  
    let(a1 = rotationFromHookSegment(hookPos, leverStartPos, leverMidPos))
    let(a2 = rotationFromHookSegment(hookPos, leverMidPos, leverEndPos))
    a1 != 0 ? a1 : a2;

module rotationFromHook(hookPos)
{
    t2 = circleTangentPoints(YZtoXY(hookPos), hookDiameter/2 + leverDim.x/2, YZtoXY(leverStartPos))[0];
    
    p = YZtoXY(hookPos);
    
    *translate(XYtoYZ(p, leverStartPos.x))
    color("black")
    sphere(4);
    
    *translate(leverMidPos)
    color("red")
    sphere(4);
    
    echo(rotationFromHook(hookPos));
    
    radius = norm(p - YZtoXY(pinPos));
    
    projectedPoint = closestPointOnSegment(YZtoXY(leverStartPos), YZtoXY(leverMidPos), YZtoXY(pinPos));
    
    dist = norm(projectedPoint - YZtoXY(pinPos));
    
    segments = circleToCicleInteriorTangentSegments(YZtoXY(pinPos), dist, 
                                         YZtoXY(hookPos), hookDiameter/2);

    *%translate(pinPos)
    color("purple", 0.1)
    sphere(dist);      
    
    *%translate(hookPos)
    color("purple", 0.1)
    sphere(hookDiameter/2);  
    
    *for(x=[0,1])
    for(y=[0,1])
    translate(XYtoYZ(segments[x][y], leverStartPos.x + 10))
    color("black")
    sphere(1);     
    
    translate(XYtoYZ(segments[1][1], leverStartPos.x + 10))
    color("black")
    sphere(2);  
    
    *translate(XYtoYZ(projectedPoint, leverStartPos.x + 10))
    color("black")
    sphere(1);
    
    a = angle(pinPos - XYtoYZ(segments[1][0], pinPos.x), 
              pinPos - XYtoYZ(projectedPoint, pinPos.x));

    
    echo(radius, dist);
    
    w = sqrt(radius*radius - dist*dist);
    
    finalP = projectedPoint + normalize(YZtoXY(leverMidPos) - YZtoXY(leverStartPos)) * w;
    
    *translate(XYtoYZ(finalP, leverStartPos.x))
    color("white")
    sphere(4);
}

module beaker()
{
    difference()
    {
        cylinder(r=beakerR+beakerW,h=beakerH);
        
        translate([0,0,beakerW])
        cylinder(r=beakerR,h=beakerH-beakerW+0.01);
    }
}

module filterPlate()
{
	translate([0,0,-plateT])
	linear_extrude(plateT)
	difference()
	{
        union()
        {
            square([plateL, plateW], center=true);
            circle(d=plateD);
        }
		circle(d=filterD);
	}
}

module filter()
{
	filterPlate();

	rotate([180])
	difference()
	{
		linear_extrude(filterH, scale=filterBottomD/filterD)
		circle(d=filterD);
		
		translate([0,0,-0.01])
		linear_extrude(filterH-$w, scale=filterBottomD/filterD)
		circle(d=filterD-$w);
	}
}

module grabber()
{    
    module pin()
    {
        translate(pinPos)
        rotate([0,90])
        cylinder(d=$w,h=$w+$tol);
    }
    
    module stopper()
    {
        stopperDim = [$w+$tol, 10, grabberDim[2]/2];
        translate([grabberPos[0]+grabberDim[0]/2+stopperDim[0]/2, grabberDim[1]/2-stopperDim[1]/2, stopperDim[2]/2])
        cube(stopperDim, center=true);
    }
    
    module lever()
    {
        leverThickness = leverDim.z;
        armStart = armStartPos.y;
        
        //fullHeight = 84;
        
        /*
        translate([grabberPos[0]-grabberDim[0]/2+leverDim[0]/2, -grabberDim[1]/2-leverDim[1]/2])
        cube([leverDim.x, abs(armStart, , leverDim.z], center=true);
        */
        
        //end = [armEndPos.x, armEndPos.y, height2];
        
        *color("green")
        translate(end)
        sphere(5);
        
        color("blue")
        translate(armStartPos)
        sphere(5);
        
        color("green")
        translate(filterCOM)
        sphere(5);
        
        translate(armStartPos)
        rotate([angle([0,0,1], leverMidPos-armStartPos),0,0])
        translate([0,0,norm(leverMidPos-armStartPos)/2])
        cube([leverThickness, leverThickness, norm(leverMidPos-armStartPos)], center=true);
        
        translate(leverMidPos)
        //color("blue")
        rotate([angle([0,0,1], leverEndPos-leverMidPos),0,0])
        translate([0,0,norm(leverEndPos-leverMidPos)/2])
        cube([leverThickness, leverThickness, norm(leverEndPos-leverMidPos)], center=true);
    }

	mirrorAdd([1,0,0])
    {
        difference()
        {
            translate(grabberPos)
            cube([grabberDim[0], grabberDim[1], grabberDim[2]], center=true);
            
            minkowski(3)
            {
                filterPlate();
                cube($tol*2,center=true);
            }
        }
        
        #pin();
        stopper();
        lever();
    }
    
	mirrorAdd([1,0,0])
    {
        difference()
        {
            translate([grabberPos[0]+grabberDim[0]/2+$w+$tol, 0])
            cube([$w*2, grabberDim[1], grabberDim[2]], center=true);
        
            minkowski(3)
            {
                pin();
                cube($tol*2,center=true);
            }
        
            minkowski(3)
            {
                stopper();
                cube($tol*2,center=true);
            }
        }
    }
}

progress = $t;

module leverHook()
{
	mirrorAdd([1,0,0])
    {        
        translate(hookStartPos)
        rotate([0, 90])
        cylinder(d=hookDiameter, h=leverDim.x, center=true);
        /*
        translate([0,0,filterH+30])
        translate([grabberPos[0]-grabberDim[0]/2+dim[0]/2, -grabberDim[1]/2-dim[1]/2])
        cube(dim, center=true);
        */
    }
}


//translate([0,20,0])
//grabber();

//crossSection(90)

{
    hookPos = hookStartPos + progress*(hookEndPos-hookStartPos);
    
    rotationFromHook(hookPos);
    
    translate(pinPos)
    rotate([rotationFromHook(hookPos), 0])
    translate(-pinPos)
    {
        filter();
        grabber();
    }
    
    translate(hookPos - hookStartPos)
    leverHook();
    
    translate(beakerPos)
    *beaker();
    
}
