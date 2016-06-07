botColor = "red";
length = 100;
width = 100;
height = 40;
scoopSize = 20;
scoopSharpness = 0.5; // 0 = sharp, 5 = blunt
shellThickness = 4;

scoopRadius = scoopSize * (scoopSharpness + 1);
shellLength = length - scoopSize;

color(botColor) {
    union() {
        shell();
        ramp();
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
