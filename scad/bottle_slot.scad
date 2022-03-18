// $fa=1; $fs=0.5;

module bottle_connector()
{
    difference()
    {
        union()
        {
            translate([0,0,18])
            rotate_extrude(convexity=10)
            translate([40.5,0,0])
            circle(r=2.5);
            
            translate([0,0,18])
            rotate_extrude(convexity=10)
            translate([41.75,0,0])
            square(size=[2.5,5],center=true);
            
            cylinder(r=43,h=18);
        }
        cylinder(r=38,h=18);
    }
}

translate([0,0,30])
bottle_connector();

difference()
{
    cylinder(30,26.5,43);
    cylinder(30,25,38);
}