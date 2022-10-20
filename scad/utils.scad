module pipeOutside(diameter, wall, length)
{
	cylinder(length, d=diameter+wall*2, center=true);
}

module pipeInside(diameter, wall, length)
{
	cylinder(length+0.01, d=diameter, center=true);
}

module pipe(diameter, wall, length)
{
	difference()
	{
		pipeOutside(diameter, wall, length);
		pipeInside(diameter, wall, length);
	}
}

module crossSection(angle=0)
{
	intersection()
	{
		children();
		
		rotate([0, 0, angle]) translate([1000/2, 0, 0]) 
		linear_extrude(1000, center=true) square(1000, center=true);
	}
}

module mirrorAdd(axis)
{
	children();
	mirror(axis) children();
}

function angle(a,b) = atan2(norm(cross(a,b)),a*b);

function normalize(v) = v / norm(v);

function circleCircleIntersection(c1, r1, c2, r2) = 
    let(dist = norm(c1-c2))
    let(a = (r1 * r1 - r2 * r2 + dist * dist) / (2 * dist))
    let(h = sqrt(r1 * r1 - a * a))
    let(p2 = c1 + a * (c2 - c1) / dist)
    [
        [p2.x + h * (c2.y - c1.y) / dist, p2.y - h * (c2.x - c1.x) / dist],
        [p2.x - h * (c2.y - c1.y) / dist, p2.y + h * (c2.x - c1.x) / dist]
    ];

function circleTangentPoints(c, r, p) = 
    let(diff = c-p)
    let(distSqr = diff.x * diff.x + diff.y * diff.y)
    let(L = sqrt(distSqr - r*r))
    circleCircleIntersection(c, r, p, L);

function circleToCicleInteriorTangentSegments(c1, r1, c2, r2) = 
    let(d = norm(c2-c1))
    let(v = (c2-c1) / d)
    
    let(c = (r1 + r2) / d)
    let(h = sqrt(max(0.0, 1.0 - c*c)))
    
    [for(s = [1, -1])
        let(nx = v.x * c - s * h * v.y)
        let(ny = v.y * c + s * h * v.x)
        
        [
            [c1.x + r1 * nx, c1.y + r1 * ny], 
            [c2.x - r2 * nx, c2.y - r2 * ny]
        ]
    ];
    

function rotate(a) =
    let(rx=a[0], ry=a[1], rz=a[2])
      [[1, 0, 0],              [0, cos(rx), -sin(rx)], [0, sin(rx), cos(rx)]]
    * [[cos(ry), 0, sin(ry)],  [0, 1, 0],              [-sin(ry), 0, cos(ry)]]
    * [[cos(rz), -sin(rz), 0], [sin(rz), cos(rz), 0],  [0, 0, 1]];
    
function closestPointOnSegment(l1, l2, p) = 
    let(diff = l2-l1)
    let(length2 = diff.x*diff.x + diff.y*diff.y)
    let(t = ((p.x - l1.x) * diff.x + (p.y - l1.y) * diff.y) / length2)
    l1 + t * diff;
    
module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}