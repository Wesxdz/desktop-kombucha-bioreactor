module pipeInside(diameter, wall, length)
{
	cylinder(length+1, d=diameter, center=true);
}

module pipe(diameter, wall, length)
{
	difference()
	{
		cylinder(length, d=diameter+wall*2, center=true);
		pipeInside(diameter, wall, length);
	}
}