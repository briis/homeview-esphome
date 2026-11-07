// =====================================================================
//  HomeView desk stand
//  Hangs the unchanged wall case on its two back-plate keyholes,
//  tilted back by `tilt` degrees. Two M4 screws in the stand act as the
//  "wall screws"; the case slides down onto them.
//
//  Print: base flat on the bed, no supports (15 deg overhang + short bridges).
//  PETG/PLA, 3 walls, 25 % infill. Add rubber feet underneath.
//  Hardware: 2x M4x12 pan/round head screws (self-tap into the 3.4 mm
//            pilot holes, or use M4 heat-set inserts with insert_holes=true).
// =====================================================================

/* ---------- From the case (homeview_wall_case.scad) ---------- */
keyhole_spacing  = 60.0;     // keyhole centre distance
screw_to_bottom  = 99.8;     // hanging screw -> bottom edge of the case
case_w           = 134.1;
case_h           = 127.7;
case_depth       = 25.8;     // front of bezel -> back of back plate
dc_x             = 35.0;     // power socket: case +x = LEFT of centre seen from the front

/* ---------- Stand ---------- */
tilt             = 15;       // screen tilt back from vertical (deg)
plug_clearance   = 32;       // vertical gap under the case for the power plug
base_w           = 118;
base_d           = 92;       // front to back
base_t           = 6;
base_r           = 8;
front_lip        = 26;       // base extends this far in front of the upright
up_w             = 100;      // upright width
up_t             = 7;        // upright thickness
gusset_t         = 6;
screw_pilot_d    = 3.4;      // M4 self-tapping pilot
insert_holes     = false;    // true: M4 heat-set inserts
insert_d         = 5.6;
cable_w          = 14;       // cable arch through the upright
cable_h          = 14;
foot_d           = 10;       // recesses for stick-on rubber feet
foot_depth       = 1.0;

$fn = 64;

// ---------------- derived ----------------
s_bottom  = plug_clearance / cos(tilt);            // case bottom, along the slope
s_screw   = s_bottom + screw_to_bottom;            // hanging screws, along the slope
up_len    = s_screw + 14;                          // upright length along the slope
y0        = front_lip;                             // upright front face meets the base here

// position along the slope -> [y, z] of the upright FRONT face
function slope(s) = [y0 + s * sin(tilt), base_t + s * cos(tilt)];

module rrect(w, h, r) { offset(r = r) square([w - 2*r, h - 2*r], center = true); }

// upright in its own frame: x across, local Y up the slope, local Z backwards (thickness)
module upright_frame() {
  translate([0, y0, base_t]) rotate([-tilt, 0, 0]) rotate([90, 0, 0]) mirror([0, 0, 1]) children();
}

module upright() {
  upright_frame() difference() {
    translate([-up_w/2, -base_t*tan(tilt) - 1, 0])
      linear_extrude(up_t) offset(r = 4) offset(delta = -4)
        square([up_w, up_len + base_t*tan(tilt) + 1]);
    // screw holes (perpendicular to the plate)
    for (sx = [-1, 1]) translate([sx * keyhole_spacing/2, s_screw, -1])
      cylinder(d = insert_holes ? insert_d : screw_pilot_d, h = up_t + 2);
    // cable arch under the power socket (case +x ends up at stand -x)
    translate([-dc_x - cable_w/2, -10, -1]) cube([cable_w, cable_h + 10, up_t + 2]);
    // lighten: pointed (45 deg) top so it prints without bridging
    translate([0, s_bottom + 45, -1]) linear_extrude(up_t + 2) hull() {
      translate([0, -8]) rrect(54, 30, 8);
      translate([0, 30]) circle(d = 2);          // apex: 45 deg roof from the 54 mm width
    }
  }
}

module gussets() {
  for (sx = [-1, 1]) {
    gx = sx * (up_w/2 - gusset_t/2);   // at the edges: keeps the cable channel (x = -dc_x) free
    // triangle in the YZ plane: from the upright back face down to the base
    top = slope(up_len * 0.72);
    translate([gx - gusset_t/2, 0, 0]) rotate([90, 0, 90])
      linear_extrude(gusset_t) polygon([
        [y0 + up_t / cos(tilt) - 1, base_t],
        [top[0] + up_t * cos(tilt) - 0.5, top[1] - up_t * sin(tilt)],
        [base_d - 6, base_t],
      ]);
  }
}

module base() {
  difference() {
    translate([0, base_d/2, 0]) linear_extrude(base_t) rrect(base_w, base_d, base_r);
    // cable channel on top of the base, from under the socket to the back edge
    translate([-dc_x - cable_w/2, y0 - 2, base_t - 2.5]) cube([cable_w, base_d, 3]);
    // rubber feet recesses
    for (p = [[-base_w/2 + 12, 12], [base_w/2 - 12, 12], [-base_w/2 + 12, base_d - 12], [base_w/2 - 12, base_d - 12]])
      translate([p[0], p[1], -0.01]) cylinder(d = foot_d + 0.4, h = foot_depth);
  }
}

module stand() {
  union() { base(); upright(); gussets(); }
}

// ---------------- ghost case for the preview ----------------
module ghost_case() {
  // back of the case lies on the upright front face; bottom edge at s_bottom
  upright_frame() color([0.85, 0.85, 0.88, 0.6])
    translate([-case_w/2, s_bottom, -case_depth]) cube([case_w, case_h, case_depth]);
}

PART = "stand";   // "stand" | "preview"
if (PART == "stand") stand();
if (PART == "preview") { color([0.35, 0.36, 0.40]) stand(); ghost_case(); }
