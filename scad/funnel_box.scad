height=100;
diameter=200;
hole=25;
wall=3;
tunnelHeight=200;
containerCircle=false;
tunnelCircle=false;

module funnelBox_impl(height, diameter, 
					   hole, tunnelHeight,
					   containerCircle, tunnelCircle)
{
	linear_extrude(height, scale=diameter/hole)
	{
		if(containerCircle)
		{
			circle(d=hole);
		}
		else
		{
			square(hole,center=true);
		}
	}
	
	translate([0,0,-tunnelHeight])linear_extrude(tunnelHeight + 1) 
	{	
		if(tunnelCircle)
		{
			circle(d=hole);
		}
		else
		{
			square(hole,center=true);
		}
	}
}

module funnelBoxInside(height, diameter, 
					   hole, wall, tunnelHeight,
					   containerCircle=false, tunnelCircle=false)
{			   
	funnelBox_impl(height+0.01, diameter, hole, tunnelHeight+0.01, containerCircle, tunnelCircle);
}

module funnelBoxOutside(height, diameter, 
					   hole, wall, tunnelHeight,
					   containerCircle=false, tunnelCircle=false)
{			   
	holeWall = hole + wall*2;
	diameterWall = diameter + wall*2;
	
	funnelBox_impl(height, diameterWall, holeWall, tunnelHeight, containerCircle, tunnelCircle);
}

module funnelBox(height, diameter, hole, wall, tunnelHeight,
				 containerCircle=false, tunnelCircle=false)
{
	difference()
	{
		funnelBoxOutside(height, diameter, hole, wall, tunnelHeight, containerCircle, tunnelCircle);
		
		funnelBoxInside(height, diameter, hole, wall, tunnelHeight, containerCircle, tunnelCircle);
		
	}
}

funnelBox(height,
diameter,
hole,
wall,
tunnelHeight,
containerCircle,
tunnelCircle);