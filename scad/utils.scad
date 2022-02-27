module pipeOutside(diameter, wall, length)
{
	cylinder(length, d=diameter+wall*2, center=true);
}

module pipeInside(diameter, wall, length)
{
	cylinder(length+1, d=diameter, center=true);
}

module pipe(diameter, wall, length)
{
	difference()
	{
		pipeOutside(diameter, wall, length);
		pipeInside(diameter, wall, length);
	}
}