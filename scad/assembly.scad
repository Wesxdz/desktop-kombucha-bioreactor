use <auger_dispenser.scad>
use <lifter.scad>
use <utils.scad>


beaker();

translate([0,0,146+4])
{
    filter();
    grabber();
}

mirrorAdd([1,0,0])
translate([25,-100,146+50])
augerDispenser();