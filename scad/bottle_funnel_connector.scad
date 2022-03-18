use <threads.scad>

height = 20;
thread_height = 5;

difference() {
    cylinder(r=20,h=height);
    ScrewHole(10, thread_height, [0, 0, height], [180,0,0], ThreadPitch(36), 30);
    cylinder(r=18,h=height-thread_height);
}
