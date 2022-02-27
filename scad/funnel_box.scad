height=100;
diameter=200;
hole=25;
wall=3;
tunnelHeight=20;
containerCircle=false;
tunnelCircle=false;

module funnelBox(height=100, diameter=200, hole=25, wall=3, tunnelHeight=20,
				 containerCircle=false, tunnelCircle=false)
{
	holeWall = hole + wall*2;
	diameterWall = diameter + wall*2;
	
	difference()
	{
		union()
		{
			linear_extrude(height, scale=diameterWall/holeWall)
			{
				if(containerCircle)
				{
					circle(d=holeWall);
				}
				else
				{
					square(holeWall,center=true);
				}
			}
			
			translate([0,0,-tunnelHeight])linear_extrude(height) 
			{	
				if(tunnelCircle)
				{
					circle(d=holeWall);
				}
				else
				{
					square(holeWall,center=true);
				}
			}
		}

		union()
		{
			linear_extrude(height+0.01, scale=diameter/hole)
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
			
			translate([0,0,-tunnelHeight-0.01])linear_extrude(height) 
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
	}
}

funnelBox(height,
diameter,
hole,
wall,
tunnelHeight,
containerCircle,
tunnelCircle);