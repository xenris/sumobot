botLength = 100;
botWidth = 100;
botHeight = 40;

groundClearance = 2;

scoopSize = 20;
scoopSharpness = 0.5; // 0 = sharp, 5 = blunt

bodyColor = "red";
shellThickness = 4;

motorColor = "yellow";
motorLength = 9 + 15;
motorWidth = 12;
motorHeight = 10;
motorShaftLength = 5;
motorShaftWidth = 1;
driveShaftLength = 10;
driveShaftWidth = 3;

wheelColor = "green";
wheelWidth = 6.6;
wheelBumpHeight = 2;
wheelBumpRadius = 4; // XXX Guess.
wheelRadius = 16;
wheelMargin = 1;

crossSection = false;

scoopRadius = scoopSize * (scoopSharpness + 1);
shellLength = botLength - scoopSize;

wheelX = scoopSize / 2;
wheelY = botWidth / 2 - shellThickness - wheelWidth / 2 - wheelMargin;
wheelZ = -(botHeight / 2 - wheelRadius + groundClearance);

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
        body();

        motors();

        wheels();
    }
}

module body() {
    color(bodyColor) {
        union() {
            difference() {
                shell();
                wheelSlots();
            }
            ramp();
        }
    }
}

module wheelSlots() {
    sxz = (2 * wheelMargin / wheelRadius) + 1;
    sy = (2 * wheelMargin / wheelWidth) + 1;

    translate([wheelX, wheelY, wheelZ]) {
        scale([sxz, sy, sxz]) {
            wheel();
        }
    }

    mirror([0, 1, 0]) {
        translate([wheelX, wheelY, wheelZ]) {
            scale([sxz, sy, sxz]) {
                wheel();
            }
        }
    }
}

module wheels() {
    color(wheelColor) {
        translate([wheelX, wheelY, wheelZ]) {
            wheel();
        }

        mirror([0, 1, 0]) {
            translate([wheelX, wheelY, wheelZ]) {
                wheel();
            }
        }
    }
}

module wheel() {
    rotate([90, 0, 0]) {
        union() {
            cylinder(h = wheelWidth, r = wheelRadius, $fn = 50, center = true);
            translate([0, 0, wheelBumpHeight / 2]) {
                cylinder(h = wheelWidth + wheelBumpHeight, r = wheelBumpRadius, $fn = 50, center = true);
            }
        }
    }
}

module shell() {
    translate([scoopSize / 2, 0, 0]) {
        difference() {
            cube(size = [shellLength, botWidth, botHeight], center = true);
            translate([0, 0, shellThickness]) {
                t2 = shellThickness * 2;
                cube(size = [shellLength - t2, botWidth - t2, botHeight], center = true);
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

    sx = -(botLength / 2 - scoopSize / 2);
    sz = -(botHeight / 2 - scoopSize / 2);

    translate([sx, 0, sz]) {
        difference() {
            cube(size = [scoopSize, botWidth, scoopSize], center = true);

            translate([x, 0, z]) {
                rotate([90, 0, 0]) {
                    cylinder(h = botWidth + 1, r = scoopRadius, center = true, $fn = 400);
                }
            }
        }
    }
}

module motors() {
    color(motorColor) {
        mx = wheelX;
        my = wheelY - motorLength / 2 - driveShaftLength + wheelWidth / 2;
        mz = wheelZ;
        translate([mx, -my, mz]) {
            motor();
        }
        mirror([0, 1, 0]) {
            translate([mx, -my, mz]) {
                motor();
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
