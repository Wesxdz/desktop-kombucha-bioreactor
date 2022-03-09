// To play activate animations in View->Animate
// Disable "mouse centric zoom" in Edit->Preferences->3D View
// Time=0, FPS=1000000, Steps=1000000
// Zoom in/out to move, don't rotate or move the view
// Use othographic mode and hide the grid
// Adjust the size of the render window so that distance
//	between the sides of the screen and the paddles is 
//  about the same as the width of the paddles
// Use the "Reset View" button to reset the game

$vpr_i = $vpr;
$vpt_i = $vpt;
$vpd_i = $vpd;

baseZoom = 140;
scl = $vpd_i/baseZoom;

sizeX = 110;
sizeY = 56;

boundsX = [-sizeX/2,sizeX/2];
boundsY = [-sizeY/2,sizeY/2];

paddleX = boundsX[1] * 0.9;
paddleHeight = sizeY / 5;

pongSpeed = 2;

$vpr_i0 = $vpr[0];

function clamp(v, mi, ma) = max(min(v, ma), mi);

function pack(vec,center=0,prec=1) = round((vec[0]+center)*prec)/1000 + round((vec[1]+center)*prec)/1000000;
function unpack(num,center=0,prec=1) = [round(num*1000)/prec-center, (round(num*1000000)%1000)/prec-center];

isReset = $vpt_i == [0,0,0] && $vpr_i == [55,0,25];
isGameover = abs($vpr[0] - 0.32) < 0.001;

resetPos = $vpt_i[1] == 0.314 || isReset;

module reverse()
{
	translate($vpt_i)
	rotate($vpr_i)
	scale([scl,scl,scl])
	children();
}

posLR = unpack($vpr_i[2]);
posL = clamp(resetPos ? 50 : posLR[0], 0, 100);
posR = clamp(resetPos ? 50 : posLR[1], 0, 100);

posLabs = posL / 100 * -sizeY + sizeY/2 - paddleHeight/2;
posRabs = posR / 100 * -sizeY + sizeY/2 - paddleHeight/2;

pos = resetPos ? [0,0] : unpack($vpr_i[1],70,10); 
posX = clamp(pos[0],boundsX[0],boundsX[1]);
posY = clamp(pos[1],boundsY[0],boundsY[1]);

moveL = clamp(round(($vpd_i-baseZoom)), -1, 1) * 5;
moveR = clamp(round((posRabs-posY)), -1, 1) * 1.5;

finalL = posL + moveL;
finalR = posR + moveR;
finalLR = [finalL, finalR];

dir = resetPos ? rands(-25, 25, 2) : unpack($vpr_i[0],50,10);
//dir = isReset ? [-10,0] : unpack($vpr_i[0],50,10);

vel = dir / (norm(dir)+0.001) * pongSpeed;
velX = vel[0];
velY = vel[1];

velMin = max(1, min(abs(velX), abs(velY)));

mirrorY = (velY > 0 && posY >= boundsY[1]) || (velY < 0 && posY <= boundsY[0]) ? -1 : 1;

mirrorX = (velX < 0 && abs(posX - -paddleX) < 5 && posLabs - paddleHeight/2 <= posY && posLabs + paddleHeight/2 >= posY) || 
			(velX > 0 && abs(posX - paddleX) < 5 && posRabs - paddleHeight/2 <= posY && posRabs + paddleHeight/2 >= posY)
			? -1 : 1;

dirFinal = [dir[0] * mirrorX, dir[1] * mirrorY];

finalPos = [posX + velX, posY + velY];

points = unpack($vpt_i[2]);

pointR = posX <= boundsX[0] ? 1 : 0;
pointL = posX >= boundsX[1] ? 1 : 0;

pointsFinal = [points[0] + pointL, points[1] + pointR]; 

wantResetPos = pointR > 0 || pointL > 0 ? 0.314 : 0;

echo(resetPos);
echo(wantResetPos);

reverse()
{
	translate([pos[0], pos[1]] / scl)
	{
		square(2,center=true);
	}
	
	{
		color("white")
		translate([-paddleX, posLabs] / scl)
		{
			square([2,paddleHeight],center=true);
		}
		
		color("white")
		translate([paddleX, posRabs] / scl)
		{
			square([2,paddleHeight],center=true);
		}
	}
		
	translate([-15, boundsY[1] * 0.7])
	text(str(pointsFinal[0]), size = 5, halign="center");
		
	translate([15, boundsY[1] * 0.7])
	text(str(pointsFinal[1]), size = 5, halign="center");
}

$vpr = [pack(dirFinal,50,10), pack(finalPos,70,10), pack(finalLR)];
$vpt = [0, wantResetPos, pack(pointsFinal)];
$vpd = baseZoom;
