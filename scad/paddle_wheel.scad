module paddleWheel(lenght, diama, core, thick, count)
{
	padRad = thick;
	
	cylinder(lenght, core, core, center=true);
	
	for(i = [0 : count])
	{
		rotate([0,0,360/count*i]) union()
		{
			linear_extrude(lenght, center=true) 
			{
				intersection()
				{
					translate([diama/2 - padRad/2, 0])		 	circle(padRad/2);
				
					translate([0, -thick/2]) square([diama/2, thick]);
				}
				
				translate([0, -thick/2]) square([diama/2 - padRad/2, thick]);
			}
		}
	}
}