use <auger_dispenser.scad>
use <lifter.scad>
use <utils.scad>


beaker();

translate([0,0,146+4])
{
    filter();
    grabber();
}

translate([0,140,175+50])
rotate([0,0,180])
augerDispenser();

translate([0,70,200+50])
rotate([0,0,180])
augerDispenser();