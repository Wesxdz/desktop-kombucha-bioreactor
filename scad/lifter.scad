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

beakerH=146;
beakerD=100.1;
beakerR=beakerD/2;
beakerW=2.5;

grabberDim = [(plateL-filterD)/2+$w, plateW+$w*2, $w*2+plateT];
grabberPos = [plateL/2+$w-grabberDim[0]/2, 0];

leverDim = [grabberDim[2], 40, grabberDim[2]];

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
        translate([plateL/2+$w, -plateW/2])
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
        translate([grabberPos[0]-grabberDim[0]/2+leverDim[0]/2, -grabberDim[1]/2-leverDim[1]/2])
        cube(leverDim, center=true);
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
        
        pin();
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

module leverHook()
{
	mirrorAdd([1,0,0])
    {
        dim = [grabberDim[2], $w*2, grabberDim[2]];
        
        translate([0,0,filterH+10])
        translate([grabberPos[0]-grabberDim[0]/2+dim[0]/2, -grabberDim[1]/2+dim[1]/2-leverDim[1]])
        cube(dim, center=true);
        
        translate([0,0,filterH+30])
        translate([grabberPos[0]-grabberDim[0]/2+dim[0]/2, -grabberDim[1]/2-dim[1]/2])
        cube(dim, center=true);
    }
}


translate([0,20,0])
grabber();

//crossSection(90)
{
    translate([0,0,beakerH+4])
    {
        filter();
        grabber();
        leverHook();
    }
    beaker();
}
