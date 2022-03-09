// To play activate animations in View->Animate
// Time=0, FPS=1000000, Steps=1000000
// Drag the view to move (right-click + drag), don't rotate the view
// Use othographic mode and hide the grid
// Use the "Reset View" button to reset the game

$vpr_i = $vpr;
$vpt_i = $vpt;
$vpd_i = $vpd;

baseZoom = 140;
scl = $vpd_i/baseZoom;

$vpr_i0 = $vpr[0];

function clamp(v, mi, ma) = max(min(v, ma), mi);

isReset = $vpt_i == [0,0,0] && $vpr_i == [55,0,25];
isGameover = abs($vpr[0] - 0.32) < 0.001;

module reverse()
{
	translate($vpt)
	rotate($vpr)
	scale([scl,scl,scl])
	children();
}


pos = [clamp($vpt_i[0],-55,55),clamp($vpt_i[1],-28,28),0];
rot = $vpr_i;

moveX = isGameover ? 0 : pos[0] - (rot[0]-0.5)*1000;
moveY = isGameover ? 0 : pos[1] - (rot[1]-0.5)*1000;

enX = isGameover ? 0 : isReset ? -20 : round(($vpd_i-baseZoom)*1000) - 50;
enY = isGameover ? 0 : isReset ? -20 : (round(($vpd_i-baseZoom)*1000000)%1000) - 50;

enMovX = clamp(pos[0] - enX, -1, 1);
enMovY = clamp(pos[1] - enY, -1, 1);

vec = [enX, enY, 0] - pos;
dist = sqrt(vec[0]*vec[0]+vec[1]*vec[1]);
isCol = dist < 4 || isGameover; 

enFinalX = isCol ? 50 : round((enX + enMovX)) + 50;
enFinalY = isCol ? 50 : round((enY + enMovY)) + 50;

reverse()
{
	translate([pos[0], pos[1]] / scl)
	{
		square(2,center=true);
		polygon([[-0.5,-0.5], [moveX, moveY]*-1.5, [0.5,0.5]]);
	}
	
	color("red")
	translate([enX, enY] / scl)
	{
		square(2,center=true);
	}

	if(isGameover || isCol)
	{
		text("GAME OVER", halign="center");
	}
}

$vpr = isCol ? [0.32,0] : isReset ? [0.5,0.5,0] : [0.5 + pos[0]/1000,0.5 + pos[1]/1000,0];
$vpt = (isReset || isCol) ? [0,0] : [pos[0] + moveX*0.8, pos[1] + moveY*0.8];
$vpd = baseZoom + enFinalX/1000 + (enFinalY/1000000);
