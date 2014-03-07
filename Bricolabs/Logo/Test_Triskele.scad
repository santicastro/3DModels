pi = 3.1415926536;
e = 2.718281828;

/*************************
* Cartesian equations 
*************************/

/* Archimedes spiral */
module archimedesSpiral(){
    scale([0.02, 0.02, 0.02]) linear_extrude(height=150)
    2dgraph([0, 360*1.5], 50, steps=20, polar=true);
}

/*************************/
// function to convert degrees to radians
function d2r(theta) = theta*360/(2*pi);

// These functions are here to help get the slope of each segment, and use that to find points for a correctly oriented polygon
function diffx(x1, y1, x2, y2, th) = cos(atan((y2-y1)/(x2-x1)) + 90)*(th/2);
function diffy(x1, y1, x2, y2, th) = sin(atan((y2-y1)/(x2-x1)) + 90)*(th/2);
function point1(x1, y1, x2, y2, th) = [x1-diffx(x1, y1, x2, y2, th), y1-diffy(x1, y1, x2, y2, th)];
function point2(x1, y1, x2, y2, th) = [x2-diffx(x1, y1, x2, y2, th), y2-diffy(x1, y1, x2, y2, th)];
function point3(x1, y1, x2, y2, th) = [x2+diffx(x1, y1, x2, y2, th), y2+diffy(x1, y1, x2, y2, th)];
function point4(x1, y1, x2, y2, th) = [x1+diffx(x1, y1, x2, y2, th), y1+diffy(x1, y1, x2, y2, th)];
function polarX(theta) = cos(theta)*r(theta);
function polarY(theta) = sin(theta)*r(theta);

module nextPolygon(x1, y1, x2, y2, x3, y3, th) {
    if((x2 > x1 && x2-diffx(x2, y2, x3, y3, th) < x2-diffx(x1, y1, x2, y2, th) || (x2 <= x1 && x2-diffx(x2, y2, x3, y3, th) > x2-diffx(x1, y1, x2, y2, th)))) {
        polygon(
            points = [
                point1(x1, y1, x2, y2, th),
                point2(x1, y1, x2, y2, th),
                // This point connects this segment to the next
                point4(x2, y2, x3, y3, th),
                point3(x1, y1, x2, y2, th),
                point4(x1, y1, x2, y2, th)
            ],
            paths = [[0,1,2,3,4]]
        );
    }
    else if((x2 > x1 && x2-diffx(x2, y2, x3, y3, th) > x2-diffx(x1, y1, x2, y2, th) || (x2 <= x1 && x2-diffx(x2, y2, x3, y3, th) < x2-diffx(x1, y1, x2, y2, th)))) {
        polygon(
            points = [
                point1(x1, y1, x2, y2, th),
                point2(x1, y1, x2, y2, th),
                // This point connects this segment to the next
                point1(x2, y2, x3, y3, th),
                point3(x1, y1, x2, y2, th),
                point4(x1, y1, x2, y2, th)
            ],
            paths = [[0,1,2,3,4]]
        );
    }
    else {
        polygon(
            points = [
                point1(x1, y1, x2, y2, th),
                point2(x1, y1, x2, y2, th),
                point3(x1, y1, x2, y2, th),
                point4(x1, y1, x2, y2, th)
            ],
            paths = [[0,1,2,3]]
        );
    }
}

module 2dgraph(bounds=[-10,10], th=2, steps=10, polar=false, parametric=false) {

    step = (bounds[1]-bounds[0])/steps;
    union() {
        for(i = [bounds[0]:step:bounds[1]-step]) {
            if(polar) {
                nextPolygon(polarX(i), polarY(i), polarX(i+step), polarY(i+step), polarX(i+2*step), polarY(i+2*step), th);
            }
            else if(parametric) {
                nextPolygon(x(i), y(i), x(i+step), y(i+step), x(i+2*step), y(i+2*step), th);
            }
            else {
                nextPolygon(i, f(i), i+step, f(i+step), i+2*step, f(i+2*step), th);
            }
        }
    }
}

function r(theta) = theta/10.5*pi;
archimedesSpiral();