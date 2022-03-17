use<utils.scad>;

$w=3;
$tol=0.3;

plateW=40;
plateL=100;
plateT=1;

filterD=70;
filterBottomD=filterD*0.7;
filterH=80;

module filterPlate()
{
	linear_extrude(plateT)
	difference()
	{
		square([plateL, plateW], center=true);
		circle(d=70);
	}
}

module filter()
{
	filterPlate();
	
	linear_extrude(plateT)
	difference()
	{
		square([plateL, plateW], center=true);
		circle(d=70);
	}

	translate([0,0,1])
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
	mirrorAdd([1,0,0])
	difference()
	{
		translate([0,0,-$w])
		linear_extrude($w*2+plateT)
		translate([plateL/2-(plateL-filterD)/4+$w/2,0])
		square([(plateL-filterD)/2+$w, plateW+$w*2], center=true);
		
		minkowski(3)
		{
			filterPlate();
			cube($tol*2,center=true);
		}
	}
}

//crossSection(90)
{
	filter();
	grabber();
}
