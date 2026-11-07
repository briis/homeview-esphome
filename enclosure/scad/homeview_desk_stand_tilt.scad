// =====================================================================
//  HomeView desk stand, adjustable tilt (0-20 deg)
//  Three printed parts:
//    "base"     base plate with two side cheeks (pivot hole + arc slot)
//    "upright"  hanger plate (2 x M4 hanging screws, like the fixed stand)
//               with two ears that sit just inside the cheeks
//    "knob"     thumb knob for the lock screw (print 2)
//  The upright pivots on two M4 screws. Two more M4 screws run through the
//  arc slots and are locked with the thumb knobs. Loosen the knobs, set
//  the angle (tick marks every 5 deg on the outside of the cheeks), and
//  tighten again.
//
//  The case itself is unchanged: it hangs on its back-plate keyholes.
//
//  Print:  base   - flat, cheeks up, no supports (slot is 45-65 deg steep)
//          upright- FRONT FACE DOWN, ears up, no supports
//          knob   - flat, hex pocket up
//  Hardware:
//    4x M4 heat-set inserts (OD ~5.6-6.0, L 5.7) in the ears
//    2x M4x12 cap/pan screws + washers   (pivots)
//    2x M4x20 hex-head bolts (DIN 933)   (locks, head sits in the knob's hex pocket)
//       + 2 washers between knob and cheek
//    2x M4x12 pan-head screws            (hanging screws for the keyholes)
//    4x Ø10 mm rubber feet
// =====================================================================

PART = "preview";     // "base" | "upright" | "knob" | "preview" | "check"
preview_tilt = 15;    // angle shown in "preview"

/* ---------- From the case (homeview_wall_case.scad) ---------- */
keyhole_spacing  = 60.0;
screw_to_bottom  = 99.8;     // hanging screw -> bottom edge of the case
case_w           = 134.1;
case_h           = 127.7;
case_depth       = 25.8;
dc_x             = 35.0;     // power socket, case +x = LEFT of centre seen from the front

/* ---------- Tilt range ---------- */
tilt_min         = 0;
tilt_max         = 20;
plug_clearance   = 60;       // min. gap under the case (table -> case bottom, at any angle): room for a straight DC plug

/* ---------- Pivot geometry ---------- */
py               = 50;       // pivot position (y from the base front edge)
pz               = 26;       // pivot height above the table
pu               = 10;       // pivot, along the upright from its bottom end
pv               = 15;       // pivot, behind the upright front face
lock_r           = 35;       // lock screw distance from the pivot
lock_beta        = 45;       // lock screw direction behind the upright (deg).
                             // Keeps the cheeks behind the case at every angle.

/* ---------- Upright ---------- */
up_w             = 100;
up_t             = 7;
ear_t            = 7;        // ear thickness (x); holds a 5.7 mm insert
ear_r            = 8;        // material around pivot / lock holes in the ear

/* ---------- Base + cheeks ---------- */
base_w           = 118;
base_d           = 115;      // deeper at the back: the case sits higher now
base_t           = 6;
base_r           = 8;
cheek_t          = 6;
cheek_gap        = 0.4;      // ear <-> cheek, per side
cheek_r          = 11;       // material around the pivot hole
cheek_arc_r      = 17.5;     // material around the slot (room for the ticks outside the knob)
cable_w          = 14;
foot_d           = 10;
foot_depth       = 1.0;

/* ---------- Screws ---------- */
screw_pilot_d    = 3.4;      // hanging screws (M4 self-tapping), as in the fixed stand
m4_clear_d       = 4.5;
insert_d         = 5.6;      // M4 heat-set insert hole (OD minus ~0.2-0.4)
tick_depth       = 0.6;

/* ---------- Knob ---------- */
knob_d           = 22;
knob_h           = 9;
knob_lobes       = 6;
hex_af           = 7.2;      // M4 hex head is 7 mm across flats
hex_h            = 3.0;      // head 2.8 mm

$fn = 64;

// ---------------- derived ----------------
s_bottom = pu + plug_clearance - pz;          // case bottom, along the upright (worst case is 0 deg)
s_screw  = s_bottom + screw_to_bottom;        // hanging screws
up_len   = s_screw + 14;
ear_x    = up_w/2 - ear_t/2;                  // ear centre (x)
cheek_x  = up_w/2 + cheek_gap + cheek_t/2;    // cheek centre (x)
lock_Y   = pv + lock_r * sin(lock_beta);      // lock hole in the upright frame
lock_Z   = pu + lock_r * cos(lock_beta);

function lockpos(t) = [py + lock_r * sin(lock_beta + t), pz + lock_r * cos(lock_beta + t)];

module rrect(w, h, r) { offset(r = r) square([w - 2*r, h - 2*r], center = true); }
// 2D (a, b) -> 3D (x = extrusion, y = a, z = b)
module yz_extrude(h) { rotate([90, 0, 90]) linear_extrude(h, center = true) children(); }
// 2D (x, u) -> 3D (x, y = 0..h, z = u)
module xz_extrude(h) { rotate([90, 0, 0]) mirror([0, 0, 1]) linear_extrude(h) children(); }
// teardrop hole, point toward +b (print "up")
module teardrop(d) { hull() { circle(d = d); translate([0, d/2 * sqrt(2) * 0.85]) rotate(45) square(d/2 * 0.85 * 1.0, center = true); } }

// upright frame: x across, Y backwards from the front face, Z up along the upright
module upright_frame(t) {
  translate([0, py, pz]) rotate([-t, 0, 0]) translate([0, -pv, -pu]) children();
}

// ---------------- upright (in its own frame) ----------------
module ear_2d() {
  hull() {
    translate([pv, pu]) circle(r = ear_r);
    translate([lock_Y, lock_Z]) circle(r = ear_r);
    translate([up_t - 0.5, 4]) square([0.5, lock_Z + 8]);   // starts above the rounded corner
  }
}
module upright_body() {
  difference() {
    union() {
      xz_extrude(up_t) translate([-up_w/2, 0]) offset(r = 4) offset(delta = -4) square([up_w, up_len]);
      for (s = [-1, 1]) translate([s * ear_x, 0, 0]) yz_extrude(ear_t) ear_2d();
    }
    // hanging screws, perpendicular to the plate
    for (s = [-1, 1]) translate([s * keyhole_spacing/2, -1, s_screw]) rotate([-90, 0, 0])
      cylinder(d = screw_pilot_d, h = up_t + 2);
    // lighten (pointed top kept from the fixed stand)
    translate([0, -1, 0]) xz_extrude(up_t + 2) translate([0, s_bottom + 45]) hull() {
      translate([0, -8]) rrect(54, 30, 8);
      translate([0, 30]) circle(d = 2);
    }
    // insert holes for pivot + lock, through each ear
    for (s = [-1, 1]) for (p = [[pv, pu], [lock_Y, lock_Z]])
      translate([s * ear_x, 0, 0]) yz_extrude(ear_t + 2) translate(p) circle(d = insert_d);   // round: heat-set inserts need a round hole
  }
}

// ---------------- base + cheeks ----------------
module cheek_2d() {
  hull() {
    translate([py, pz]) circle(r = cheek_r);
    for (t = [tilt_min, (tilt_min + tilt_max)/2, tilt_max]) translate(lockpos(t)) circle(r = cheek_arc_r);
    translate([py - cheek_r, 0]) square([base_d - 5 - (py - cheek_r), base_t]);
  }
}
module slot_2d() {
  for (t = [tilt_min : 1 : tilt_max - 1]) hull() {
    translate(lockpos(t)) circle(d = m4_clear_d);
    translate(lockpos(t + 1)) circle(d = m4_clear_d);
  }
}
module ticks_2d() {
  for (t = [tilt_min : 5 : tilt_max]) {
    long = (t % 10 == 0);
    a = lock_beta + t;
    translate([py, pz]) rotate(-a) translate([-0.5, lock_r + 12.5]) square([1.0, long ? 4.0 : 2.5]);   // outside the 22 mm knob
  }
}
module base() {
  difference() {
    union() {
      translate([0, base_d/2, 0]) linear_extrude(base_t) rrect(base_w, base_d, base_r);
      for (s = [-1, 1]) translate([s * cheek_x, 0, 0]) yz_extrude(cheek_t) cheek_2d();
    }
    for (s = [-1, 1]) translate([s * cheek_x, 0, 0]) {
      // pivot hole and lock slot
      yz_extrude(cheek_t + 2) translate([py, pz]) circle(d = m4_clear_d);
      yz_extrude(cheek_t + 2) slot_2d();
      // angle ticks on the outside face
      translate([s * (cheek_t/2 - tick_depth/2 + 0.01), 0, 0]) yz_extrude(tick_depth + 0.02) ticks_2d();
    }
    // cable channel from under the socket to the back edge
    translate([-dc_x - cable_w/2, 8, base_t - 2.5]) cube([cable_w, base_d, 3]);
    // rubber feet
    for (p = [[-base_w/2 + 12, 12], [base_w/2 - 12, 12], [-base_w/2 + 12, base_d - 12], [base_w/2 - 12, base_d - 12]])
      translate([p[0], p[1], -0.01]) cylinder(d = foot_d + 0.4, h = foot_depth);
  }
}

// ---------------- knob ----------------
module knob() {
  difference() {
    union() {
      linear_extrude(knob_h) offset(r = 1.5) offset(delta = -1.5)
        union() { circle(d = knob_d - 6); for (i = [0 : knob_lobes - 1]) rotate(i * 360 / knob_lobes) translate([knob_d/2 - 3.5, 0]) circle(d = 7); }
    }
    translate([0, 0, -1]) cylinder(d = m4_clear_d, h = knob_h + 2);
    translate([0, 0, knob_h - hex_h]) cylinder(d = hex_af / cos(30), h = hex_h + 1, $fn = 6);
  }
}

// ---------------- ghost case ----------------
module ghost_case(t) {
  upright_frame(t) translate([-case_w/2, -case_depth, s_bottom]) cube([case_w, case_depth, case_h]);
}

// ---------------- output ----------------
if (PART == "base")    base();
if (PART == "upright") rotate([90, 0, 0]) upright_body();    // front face on the bed
if (PART == "knob")    knob();
if (PART == "preview") {
  color([0.35, 0.36, 0.40]) base();
  color([0.45, 0.46, 0.50]) upright_frame(preview_tilt) upright_body();
  color([0.85, 0.85, 0.88, 0.5]) ghost_case(preview_tilt);
}
// "check": intersections that must be empty (used to verify every angle)
check_tilt = 0;
check_what = "case_base";   // "case_base" | "upright_base"
if (PART == "check") {
  if (check_what == "case_base")    intersection() { base(); ghost_case(check_tilt); }
  if (check_what == "upright_base") intersection() { base(); upright_frame(check_tilt) upright_body(); }
}
