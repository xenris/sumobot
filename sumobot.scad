botColor = "red";
motorColor = "yellow";
length = 100;
width = 100;
height = 40;
scoopSize = 20;
scoopSharpness = 0.5; // 0 = sharp, 5 = blunt
shellThickness = 4;

motorLength = 9 + 15;
motorWidth = 12;
motorHeight = 10;
driveShaftLength = 10;
driveShaftWidth = 3;
motorShaftLength = 5;
motorShaftWidth = 1;

driveShaftDistanceToWall = 2;

crossSection = false;

scoopRadius = scoopSize * (scoopSharpness + 1);
shellLength = length - scoopSize;

difference() {
    model();

    if(crossSection) {
        translate([0, -500, 0]) {
            cube(size = [1000, 1000, 1000], center = true);
        }
    }
}

module model() {
    union() {
        color(botColor) {
            shell();
            ramp();
        }

        color(motorColor) {
            mx = scoopSize / 2;
            my = width / 2 - shellThickness - motorLength / 2 - driveShaftLength - driveShaftDistanceToWall;
            mz = -(height / 2 - motorHeight / 2 - shellThickness);
            translate([mx, -my, mz]) {
                motor();
            }
            translate([mx, my, mz]) {
                rotate([180, 0, 0]) {
                    motor();
                }
            }
        }
    }
}

module shell() {
    translate([scoopSize / 2, 0, 0]) {
        difference() {
            cube(size = [shellLength, width, height], center = true);
            translate([0, 0, shellThickness]) {
                t2 = shellThickness * 2;
                cube(size = [shellLength - t2, width - t2, height], center = true);
            }
        }
    }
}

module ramp() {
    z1 = scoopSize / 2;
    x1 = scoopSize / 2;

    z2 = -z1;
    x2 = -x1;

    q = sqrt(pow(z2-z1, 2) + pow(x2-x1, 2));

    z3 = (z1+z2) / 2;
    x3 = (x1+x2) / 2;

    rr = pow(scoopRadius, 2);

    z = z3 + sqrt(rr - pow(q/2, 2)) * (x1-x2) / q;
    x = x3 + sqrt(rr - pow(q/2, 2)) * (z2-z1) / q;

    sx = -(length / 2 - scoopSize / 2);
    sz = -(height / 2 - scoopSize / 2);

    translate([sx, 0, sz]) {
        difference() {
            cube(size = [scoopSize, width, scoopSize], center = true);

            translate([x, 0, z]) {
                rotate([90, 0, 0]) {
                    cylinder(h = width + 1, r = scoopRadius, center = true, $fn = 400);
                }
            }
        }
    }
}

module motor() {
    union() {
        cube(size = [motorWidth, motorLength, motorHeight], center = true);
        sy = -(motorLength / 2 + driveShaftLength / 2);
        translate([0, sy, 0]) {
            rotate([90, 0, 0]) {
                cylinder(h = driveShaftLength, d = driveShaftWidth, $fn = 10, center = true);
            }
        }
        msy = motorLength / 2 + motorShaftLength / 2;
        translate([0, msy, 0]) {
            rotate([90, 0, 0]) {
                cylinder(h = motorShaftLength, d = motorShaftWidth, $fn = 10, center = true);
            }
        }
    }
}
