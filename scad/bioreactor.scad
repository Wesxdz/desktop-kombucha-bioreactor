use <auger_dispenser.scad>

translate([87.5,0,0])
rotate([0,0,90])
    augerDispenser();
    
translate([-87.5,0,0])
rotate([0,0,-90])
    augerDispenser();