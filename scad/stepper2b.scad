$fa = 1;
$fs = 0.4;
$fn = 200;

function stepper2b_pinOffset() = [0, 8, 0];

module stepper2b_pin()
{
	color("#c1a15e")
	{
		linear_extrude(10-6)
		circle(d=5);

		intersection()
		{
			linear_extrude(10)
			circle(d=5);
			
			translate([0, 0, 10-6+6/2])  cube([10, 3, 6], center=true);
		}
	}
}

module stepper2b_mountingPlate()
{
	difference()
	{
		translate([0, 0, -1])
		linear_extrude(1)
		for(i=[-1, 1])
		{
			union()
			{
				translate([35/4*i, 0]) square([35/2, 7], center=true);
				translate([35/2*i, 0]) circle(d=7);
			}
		}
		
		stepper2b_mountingHole();
	}
}

module stepper2b_mountingHole()
{
	translate([0, 0, -1.01])
	linear_extrude(1.02)
	for(i=[-1, 1])
	{
		translate([35/2*i, 0]) circle(d=4);
	}
}

module stepper2b()
{
	translate([0, 0, -19])
	linear_extrude(19)
	circle(d=28);
	
	stepper2b_mountingPlate();
	
	linear_extrude(1.5)
	translate([0, 8]) circle(d=9);
	
	translate([0, -17/2+1.5/2, -16.5])
	linear_extrude(16.5)
	square([14.6-2, 17-1.5], center=true);
	
	translate(stepper2b_pinOffset())
	rotate([0, 0, $t*360])
	stepper2b_pin();
	
	color("#5399cc")
	difference()
	{
		translate([0, -17/2, -16.5-0.01])
		linear_extrude(16.5)
		square([14.6, 17], center=true);
		
		translate([0, -17, -2.5])
		linear_extrude(1.5)
		square([6.5, 2], center=true);
	}
	
	color("#5399cc")
	translate([0, -17, -16])
	linear_extrude(12.75)
	for(i=[-1, 1])
	{
		translate([i*14.6/2, 5.06])
		scale([i, 1])
		difference()
		{
			polygon([[0,0], [0,-1.5],[1.5,-1], [1.5, 2]]);
		}
	}
}

stepper2b();