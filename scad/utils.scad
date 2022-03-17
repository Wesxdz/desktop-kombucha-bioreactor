module pipeOutside(diameter, wall, length)
{
	cylinder(length, d=diameter+wall*2, center=true);
}

module pipeInside(diameter, wall, length)
{
	cylinder(length+0.01, d=diameter, center=true);
}

module pipe(diameter, wall, length)
{
	difference()
	{
		pipeOutside(diameter, wall, length);
		pipeInside(diameter, wall, length);
	}
}

module crossSection(angle=0)
{
	intersection()
	{
		children();
		
		rotate([0, 0, angle]) translate([1000/2, 0, 0]) 
		linear_extrude(1000, center=true) square(1000, center=true);
	}
}

module mirrorAdd(axis)
{
	children();
	mirror(axis) children();
}