// =====================================================================
//  HomeView wall case for the Waveshare ESP32-S3-Touch-LCD-4.3B (Rev 1.1)
//  with a VL53L0X (GY-VL53L0XV2) proximity sensor in the bottom chin.
//  Derived from the 5" case (homeview_wall_case.scad): same bezel, sensor
//  pocket, bosses and back plate. Differences:
//    - powered through the board's own USB-C port, via an opening in the
//      RIGHT side wall (seen from the front); no DC socket
//    - back-plate posts press on free areas of the PCB / LCD back (+ foam pads)
//    - keyholes placed so the hanging screw sits 99.8 mm above the case
//      bottom, exactly as on the 5" case -> both desk stands fit unchanged
//
//  Parts (set PART below, or use the exported STLs):
//    "front"    front shell: bezel + walls + sensor window/cradle
//    "back"     wall plate: keyholes (fit both desk stands), screw counterbores, 4 posts
//    "testfit"  bezel ring + the right wall with the USB-C opening: print first
//    "assembly" preview with ghost board + sensor
//
//  Print: front shell FACE DOWN (bezel on the bed), no supports.
//         Back plate flat. PETG recommended in a bathroom.
//  Hardware: 4x M3 heat-set inserts (OD 4.2-4.5 mm, L 5-6 mm),
//            4x M3x8 countersunk/cap screws, 2x wall screws (4 mm, head <= 8 mm),
//            a few 2-3 mm foam pads.
//
//  !! VERIFY with calipers before printing the full shell !!
//  Values marked [MEASURE] could not be confirmed from Waveshare's
//  drawing. The outline 112.4 x 75.1 mm is from Waveshare's spec.
// =====================================================================

PART = "assembly";      // "front" | "back" | "testfit" | "sensorinsert" | "sensortest" | "assembly"

/* ---------- Display module (Waveshare) ---------- */
glass_w        = 112.4;   // module/glass width  (Waveshare spec, +-0.1)
glass_h        = 75.1;    // module/glass height (Waveshare spec, +-0.1)
// From Waveshare's dimension drawing (ESP32-S3-Touch-LCD-4.3B, unit mm):
glass_t        = 4.8;     // glass + LCD stack thickness (front face -> back of panel)
module_depth   = 20.3;    // front of glass -> top of the green terminal block (measured; the drawing's 17.4 is too small)
glass_r        = 4.0;     // glass corner radius (4 x R4.00)
fit_clear_x    = 0.05;    // per side, left/right (0.20 loose in testfit 2; 0.0 too tight in the full shell)
fit_clear_y    = 0.05;    // per side, up/down (0.10 a little loose in testfit 1; 0.0 too tight in the full shell)
// PCB: measured from the user's photo of the board in the front shell (v4 print).
// It covers almost the full glass width (~110 mm) and starts at the glass top edge.
pcb_w          = 110.0;
pcb_h          = 62.0;
pcb_top_from_top = 1.0;
pcb_back       = 10.5;    // glass front -> PCB back face (measured: 9.9 mm below the 22.2 mm wall edge)
// Back-plate pressure posts, placed on areas that are free in the photo:
//   [x seen from the FRONT (+ = left), glass top edge -> post centre, landing depth from the glass front, diameter]
// Landing depths measured with calipers (depth from the 22.2 mm wall edge, 2026-11-06):
//   bare PCB 9.9 -> 10.5;  ESP32 module top 6.8;  LCD metal bottom-left 12.2 -> 8.2;
//   LCD metal bottom-right 15.5 -> 4.9;  terminal block top 0.1 -> 20.3.
// Two on bare PCB (beside the "ESP32-S3-Touch-LCD" text, ~20 mm clear of the ESP32 module,
// and below "Rev1.1"); two on the metal below the PCB (left of the touch FPC, right of the tape).
posts = [
  [  -2.0,   9.1, 13.6,     5.0 ],   // lands on the ESP32 module top (user: it hit the module at PCB depth)
  [ -29.8,  22.2, pcb_back, 5.0 ],
  [  49.6,  68.6, 8.2,      6.0 ],
  [ -44.7,  68.6, 4.9,      6.0 ],
];
// The terminal block reaches to 0.1 mm below the wall edge, so the back plate gets a
// pocket over it. Footprint seen from the front: x -35..35, 50..65 mm below the glass top.
term_pocket_depth = 2.0;
post_gap       = 1.0;     // posts stop this short: put ~1.5 mm foam pads on the tips (soaks up tolerance)

/* ---------- Case ---------- */
wall           = 3.0;     // side / outer walls
front_t        = 1.8;     // bezel plate thickness in front of the glass
lip            = 2.2;     // how far the bezel overlaps the glass edge
top_band       = 12.0;    // bezel above the glass (houses 2 screw bosses)
chin_h         = 28.0;    // bezel below the glass (houses sensor + 2 bosses)
cavity_extra   = 0.1;     // shell depth stays 22.2 (as printed); the back plate's terminal pocket gives the room
corner_r       = 7.0;     // outer corner radius
edge_chamfer   = 1.2;     // front edge chamfer

/* ---------- Back plate ---------- */
back_t         = 5.0;     // room for the recessed M3 / M2.5 screw heads
keyhole_spacing= 60.0;    // 60 mm = standard EU/DK wall box spacing (= desk stands)
keyhole_to_bottom = 99.8; // hanging screw -> case bottom, same as the 5" case (= desk stands)
keyhole_head_d = 8.5;
keyhole_slot_w = 4.4;
keyhole_len    = 10.0;
cable_hole     = false;   // cable through the back plate (off: power comes from below)
cable_d        = 9.0;
cable_offset_x = 30.0;

/* ---------- Panel-mount DC jack in the bottom wall ---------- */
dc_jack        = false;   // 4.3B: powered via USB-C instead
dc_hole_d      = 11.2;    // panel hole for the round power socket
dc_x           = 35.0;    // from centre; +x = LEFT seen from the front (right seen from the back)
dc_nut_clear_d = 17.0;    // flat area kept free inside for the nut / washer
dc_z           = 0;       // 0 = centred in the shell depth; else distance from the front face
press_posts    = true;    // posts that push the module forward onto the bezel

/* ---------- USB-C port in the right side wall (seen from the front) ---------- */
// The port, BOOT, RESET and the TF slot sit on the left PCB edge seen from the back.
usb_cut        = true;
usb_y_from_top = 39.4;    // glass top edge -> USB-C centre (testfit 2, straight-on photo without cable: socket 0.8 mm toward the top of 40.2)
usb_z          = 13.6;    // front face of the case -> USB-C centre (testfit 2, straight-on photo: socket centred at 13.4, max 0.5 deeper)
usb_open_l     = 15.0;    // opening along the edge: fits overmolds up to ~13.5 mm
usb_open_h     = 10.0;    // opening across the depth: fits overmolds up to ~8.5 mm

/* ---------- Screws / inserts ---------- */
boss_d         = 10.0;
insert_d       = 4.6;     // M3 heat-set insert hole (was 4.4: the insert's lower part would not seat)
insert_depth   = 8.0;     // fits 5.7-6.4 mm long inserts + room for displaced plastic
screw_clear_d  = 3.6;     // M3 clearance (printed holes shrink a little)
screw_head_d   = 6.8;     // M3 cap head is 5.5 mm
screw_head_t   = 3.3;     // M3 cap head is 3.0 mm
// (4.3B: no standoffs, so the posts only press; no screws through them)
m25_clear_d    = 2.9;
m25_head_d     = 5.2;
m25_head_t     = 2.7;

/* ---------- VL53L0X sensor (GY-VL53L0XV2 / "VL53L0/1XV2") ---------- */
// Mounted horizontally in the chin: mounting holes left/right, pin row UP.
// From two module drawings (25 x 10.6 mm board, 15.6 mm without the ears):
// Pillar positions relative to the WINDOW centre, seen from the back (as printed):
sensor_hole_left_x  = -10.35; // left pillar
sensor_hole_right_x =   9.35; // right pillar (moved 1 mm in after the test print)
sensor_win_dx       =  -0.5;  // window/nose shift relative to the pillars (from test print 2)
sensor_chip_off     = 2.2;   // chip centre is this far from the hole line,
                             // on the side away from the pins
sensor_pins_up      = true;  // true: pins toward the screen -> chip BELOW the hole line
sensor_chip_w       = 4.4;   // VL53L0X package (long side, horizontal here)
sensor_chip_h       = 2.4;
sensor_chip_t       = 1.0;   // package height above the PCB
// Pillars (PCB front face rests on them, screws from the back)
sensor_style        = "pocket";  // "pocket" = sealed chip pocket + wide flare (v3, default)
                                 // "slot"   = narrow slot (v2: clips the beam -> constant short readings)
                               // "pocket" = anti-crosstalk version (v3): use if the
                               //            reading sticks at a short distance
pillar_h            = (sensor_style == "pocket") ? 2.2 : 3.0;  // PCB front face -> inside of the bezel
pillar_d            = 5.0;
pillar_hole_d       = 2.1;   // pilot for M2.2/M2.5 self-tapping screws (M2: 1.7)
pillar_skin         = (sensor_style == "pocket") ? 0.6 : 0.8;   // plastic left in front of the blind hole
// Window: the chip sits in a pocket in a raised block that touches the PCB
// (stops light leaking sideways = crosstalk). In front of the chip the opening
// starts at the full chip outline and flares outward, so the beam never
// grazes the walls.
// v2 "slot" window
sensor_gap          = 0.3;   // air gap between chip and the window nose
win_in_w            = 4.0;   // slot at the chip (inside); emitter+receiver are ~3 mm apart
win_in_h            = 1.6;
slot_flare          = 18;    // half-angle of the slot flare (deg)
slot_nose_margin    = 1.2;
// v3 "pocket" window
pocket_clear        = 0.25;  // per side, chip in its pocket
pocket_pcb_gap      = 0.15;  // block top -> PCB front face (must not lift the PCB)
win_flare           = 30;    // half-angle of the opening flare (deg); beam is ~25-35 deg full
nose_margin         = 0.8;   // wall around the pocket at the PCB (keep small: SMD parts nearby)
nose_base_wall      = 1.0;   // wall outside the flared window where the nose meets the bezel
sensor_y_off        = 0.0;   // nudge the whole sensor mount up(+)/down(-)
sensor_x_off        = 0.0;   // nudge left(-)/right(+)

/* ---------- Sensor insert (print in BLACK) ---------- */
// The sensor mount is a separate pill-shaped part that fills a matching
// through-opening in the chin (front flush). Print it in black, FACE DOWN:
// the whole front lies on the bed, so there are no floating regions.
// Grey/white PETG passes 940 nm IR, which causes crosstalk.
sensor_insert   = false;
ins_w           = 27.0;   // pill size (must contain both pillars + the window)
ins_h           = 11.0;
ins_clear       = 0.15;   // per side, insert in the shell opening (press fit + CA glue)

/* ---------- Two-colour print (e.g. Bambu H2D): white case, black sensor area ---------- */
// PART="white" = the shell without the sensor oval and nose; PART="black" = the oval
// through the bezel + the sealed chip pocket. Import both STLs together as ONE object
// (Bambu Studio asks "load as a single object with multiple parts?" -> Yes) and give
// each part its filament. White plastic passes 940 nm IR, so everything around the beam is black.
mc_w            = 12.0;   // black oval around the window, seen from the front (window front ~8.4 x 6.4)
mc_h            = 10.0;   // keeps >1.3 mm white between the oval and the (white) sensor pillars

/* ---------- Ventilation ---------- */
vent_slots     = 6;
vent_w         = 2.0;
vent_l         = 14.0;

$fn = 64;

// ---------------- derived ----------------
pocket_w = glass_w + 2*fit_clear_x;
pocket_h = glass_h + 2*fit_clear_y;
outer_w  = pocket_w + 2*wall;
outer_h  = pocket_h + top_band + chin_h;
y_top    =  pocket_h/2 + top_band;        // outer top edge
y_bot    = -(pocket_h/2 + chin_h);        // outer bottom edge
y_mid    = (y_top + y_bot)/2;
depth    = front_t + module_depth + cavity_extra;   // shell depth (front face -> back edge)
chin_cy  = -(pocket_h/2 + chin_h/2) + sensor_y_off; // sensor hole line in the chin
chip_y   = chin_cy + (sensor_pins_up ? -sensor_chip_off : sensor_chip_off);
nose_h   = (sensor_style == "pocket") ? pillar_h - pocket_pcb_gap        // block reaches almost to the PCB
                                     : pillar_h - sensor_chip_t - sensor_gap; // nose stops 0.3 mm before the chip
chip_z   = front_t + pillar_h - sensor_chip_t;          // chip top (z from the front face)
win_x    = sensor_x_off + sensor_win_dx;                // window / chip centre
ins_cx   = sensor_x_off + (sensor_hole_left_x + sensor_hole_right_x)/2;
ins_cy   = chip_y;                                      // pill centred on the window


boss_xy = [
  [ -(outer_w/2 - wall - boss_d/2 - 2),  pocket_h/2 + top_band/2 ],
  [  (outer_w/2 - wall - boss_d/2 - 2),  pocket_h/2 + top_band/2 ],
  [ -(outer_w/2 - wall - boss_d/2 - 2),  y_bot + wall + boss_d/2 + 2 ],
  [  (outer_w/2 - wall - boss_d/2 - 2),  y_bot + wall + boss_d/2 + 2 ],
];

// ---------------- helpers ----------------
module rrect(w, h, r) {
  offset(r = r) square([w - 2*r, h - 2*r], center = true);
}
// rounded slab with chamfered front edge (front face at z=0)
module outer_body(h) {
  hull() {
    translate([0, y_mid, 0]) linear_extrude(0.01)
      rrect(outer_w - 2*edge_chamfer, outer_h - 2*edge_chamfer, corner_r - edge_chamfer);
    translate([0, y_mid, edge_chamfer]) linear_extrude(h - edge_chamfer)
      rrect(outer_w, outer_h, corner_r);
  }
}

// ---------------- front shell ----------------
module front_shell() {
  difference() {
    union() {
      difference() {
        outer_body(depth);
        // main cavity behind the bezel (inside the walls)
        translate([0, y_mid, front_t])
          linear_extrude(depth)
            rrect(outer_w - 2*wall, outer_h - 2*wall, max(1, corner_r - wall));
      }
      // screw bosses (full depth, with inserts at the back)
      for (p = boss_xy) translate([p[0], p[1], 0])
        cylinder(d = boss_d, h = depth);
      // glass locating rib under the glass bottom edge
      translate([-pocket_w/2, -pocket_h/2 - 1.6, 0]) cube([pocket_w, 1.6, front_t + glass_t]);
      // glass locating rib above the glass top edge
      translate([-pocket_w/2, pocket_h/2, 0]) cube([pocket_w, 1.6, front_t + glass_t]);
      // sensor pillars + light-blocking block (or the opening for the insert)
      if (!sensor_insert) { sensor_pillars(); if (PART != "white") sensor_nose(); }
    }
    // display opening (glass shows through, bezel overlaps the edge by `lip`)
    translate([0, 0, -1])
      linear_extrude(front_t + 2)
        rrect(glass_w - 2*lip, glass_h - 2*lip, 2.5);
    // glass pocket (from behind the bezel), R4 corners like the glass
    translate([0, 0, front_t]) linear_extrude(depth) rrect(pocket_w, pocket_h, glass_r + min(fit_clear_x, fit_clear_y));
    // sensor window + blind screw holes, or the stepped opening for the insert
    if (sensor_insert) insert_opening(ins_clear); else sensor_cuts();
    // two-colour: the black oval is a separate body
    if (PART == "white") translate([win_x, chip_y, -1]) linear_extrude(front_t + 2) pill(mc_w, mc_h);
    // insert holes
    for (p = boss_xy) translate([p[0], p[1], depth - insert_depth])
      cylinder(d = insert_d, h = insert_depth + 1);
    // panel-mount DC power socket in the bottom wall
    if (dc_jack) dc_hole();
    // USB-C opening in the right side wall (seen from the front = -x)
    if (usb_cut) usb_hole();
    // ventilation: bottom and top walls
    vents(y_bot);
    vents(y_top - wall);
  }
}

dc_zc = (dc_z == 0) ? (front_t + depth) / 2 - 1.0 : dc_z;   // 1 mm forward: nut clears the back-plate rim
module dc_hole() {
  translate([dc_x, y_bot - 1, dc_zc]) rotate([-90, 0, 0]) cylinder(d = dc_hole_d, h = wall + 2);
}

usb_y = glass_h/2 - usb_y_from_top;
module usb_hole() {
  translate([-outer_w/2 - 1, usb_y, usb_z]) rotate([0, 90, 0])
    linear_extrude(wall + 2 + fit_clear_x + 0.5)
      hull() for (d = [-1, 1]) translate([0, d * (usb_open_l - usb_open_h)/2]) circle(d = usb_open_h);
}

// Opening in front of the chip
module sensor_window() {
  if (sensor_style == "pocket") {
    L = chip_z;                                  // chip top -> front face
    w0 = sensor_chip_w + 2*pocket_clear;
    h0 = sensor_chip_h + 2*pocket_clear;
    g  = 2 * L * tan(win_flare);
    hull() {
      translate([0, 0, L]) cube([w0, h0, 0.02], center = true);
      translate([0, 0, 0]) cube([w0 + g, h0 + g, 0.02], center = true);
    }
    translate([-w0/2, -h0/2, L - 0.01]) cube([w0, h0, sensor_chip_t + pocket_pcb_gap + 1]);
  } else {
    L = front_t + nose_h;                        // tunnel through bezel + nose
    grow = 2 * L * tan(slot_flare);
    hull() {
      translate([0, 0, L - 0.01]) linear_extrude(0.02)
        offset(r = win_in_h/2) square([win_in_w - win_in_h, 0.001], center = true);
      translate([0, 0, -0.01]) linear_extrude(0.02)
        offset(r = (win_in_h + grow)/2) square([win_in_w - win_in_h, 0.001], center = true);
    }
  }
}

module sensor_mount() { sensor_pillars(); sensor_nose(); }
module sensor_pillars() {
  for (hx = [sensor_hole_left_x, sensor_hole_right_x]) translate([sensor_x_off + hx, chin_cy, front_t])
    cylinder(d = pillar_d, h = pillar_h);
}
module sensor_nose() {
  translate([sensor_x_off + sensor_win_dx, chip_y, front_t])
    if (sensor_style == "pocket")
      // tapered nose: the top (against the PCB) keeps nose_margin, the base gets
      // nose_base_wall outside the flared window, so no wall is thinner than a nozzle
      hull() {
        translate([0, 0, nose_h - 0.01]) cube([sensor_chip_w + 2*pocket_clear + 2*nose_margin,
                                               sensor_chip_h + 2*pocket_clear + 2*nose_margin, 0.02], center = true);
        translate([0, 0, 0.01]) cube([sensor_chip_w + 2*pocket_clear + 2*(chip_z - front_t)*tan(win_flare) + 2*nose_base_wall,
                                      sensor_chip_h + 2*pocket_clear + 2*(chip_z - front_t)*tan(win_flare) + 2*nose_base_wall, 0.02], center = true);
      }
    else
      linear_extrude(nose_h) offset(r = slot_nose_margin) offset(r = win_in_h/2)
        square([win_in_w - win_in_h + 1.0, 0.001], center = true);
}

module sensor_cuts() {
  translate([sensor_x_off + sensor_win_dx, chip_y, 0]) sensor_window();
  for (hx = [sensor_hole_left_x, sensor_hole_right_x]) translate([sensor_x_off + hx, chin_cy, pillar_skin])
    cylinder(d = pillar_hole_d, h = front_t + pillar_h);
}

module pill(w, h) { offset(r = h/2) square([max(0.01, w - h), 0.001], center = true); }

// through-opening in the shell for the insert
module insert_opening(c) {
  translate([ins_cx, ins_cy, -1]) linear_extrude(front_t + 2) pill(ins_w + 2*c, ins_h + 2*c);
}

// the black insert: solid pill through the bezel + pillars + chip pocket
module sensor_insert_part() {
  difference() {
    union() {
      translate([ins_cx, ins_cy, 0]) linear_extrude(front_t) pill(ins_w, ins_h);
      sensor_mount();
    }
    sensor_cuts();
  }
}

// two-colour: black oval through the bezel + the chip-pocket nose, minus the window
module black_part() {
  difference() {
    union() {
      translate([win_x, chip_y, 0]) linear_extrude(front_t) pill(mc_w, mc_h);
      sensor_nose();
    }
    translate([sensor_x_off + sensor_win_dx, chip_y, 0]) sensor_window();
  }
}

// Small test piece: the chin section of the bezel with the sensor mount
module sensor_test() {
  difference() {
    union() {
      translate([sensor_x_off - 18, chin_cy - 9, 0]) cube([36, 18, front_t]);
      sensor_mount();
      // outline of the PCB (raised 0.4 mm rim) to check the footprint visually
      translate([sensor_x_off + (sensor_hole_left_x + sensor_hole_right_x)/2, chin_cy, front_t]) linear_extrude(0.4) difference() {
        square([25.8, 11.8], center = true); square([25.4, 11.0], center = true);
      }
    }
    sensor_cuts();
  }
}

module vents(y0) {
  n = vent_slots;
  for (i = [0 : n - 1]) {
    x = (i - (n - 1)/2) * (vent_w + 6);
    if (!(dc_jack && y0 == y_bot && abs(x - dc_x) < dc_nut_clear_d/2 + vent_w))
      translate([x - vent_w/2, y0 - 1, front_t + 6]) cube([vent_w, wall + 2, depth - front_t - 6 + 1]);   // open at the back edge, like the 5" case
  }
}

// ---------------- back plate ----------------
module back_plate() {
  difference() {
    union() {
      translate([0, y_mid, 0]) linear_extrude(back_t) rrect(outer_w, outer_h, corner_r);
      // locating rim that drops inside the shell walls
      translate([0, y_mid, back_t]) linear_extrude(2)
        difference() {
          rrect(outer_w - 2*wall - 0.5, outer_h - 2*wall - 0.5, max(1, corner_r - wall));
          rrect(outer_w - 2*wall - 3.5, outer_h - 2*wall - 3.5, max(1, corner_r - wall - 1.5));
        }
      if (press_posts)
        // posts press the module forward onto the bezel, on free areas of the PCB / LCD back.
        // The plate is flipped left-right to go onto the case, so x is mirrored here.
        for (p = posts) translate([-p[0], glass_h/2 - p[1], back_t])
          cylinder(d = p[3], h = depth - front_t - p[2] - post_gap);
    }
    // screw holes with counterbore on the wall side
    for (p = boss_xy) translate([p[0], p[1], 0]) {
      translate([0, 0, -1]) cylinder(d = screw_clear_d, h = back_t + 4);
      translate([0, 0, -0.01]) cylinder(d = screw_head_d, h = screw_head_t);
    }
    // rim cleared from each boss out into its corner (no thin slivers)
    for (p = boss_xy) translate([0, 0, back_t - 0.01]) hull() {
      translate([p[0], p[1], 0]) cylinder(d = boss_d + 1, h = 3);
      translate([p[0] + sign(p[0]) * 20, p[1] + sign(p[1] - y_mid) * 20, 0]) cylinder(d = boss_d + 1, h = 3);
    }
    // pocket over the green terminal block (symmetric in x, so the left-right flip doesn't matter)
    translate([-35, glass_h/2 - 65, back_t - term_pocket_depth]) cube([70, 15, term_pocket_depth + 3]);
    // keyholes (hang on two wall screws)
    for (s = [-1, 1]) translate([s*keyhole_spacing/2, y_bot + keyhole_to_bottom - keyhole_len, 0]) keyhole();
    // optional cable hole through the back plate
    if (cable_hole) translate([cable_offset_x, chin_cy, -1]) cylinder(d = cable_d, h = back_t + 4);
  }
}

module keyhole() {
  translate([0, 0, -1]) cylinder(d = keyhole_head_d, h = back_t + 2);
  translate([-keyhole_slot_w/2, 0, -1]) cube([keyhole_slot_w, keyhole_len, back_t + 2]);
  // head pocket so the plate sits flush
  hull() {
    translate([0, 0, 1.5]) cylinder(d = keyhole_head_d, h = back_t);
    translate([0, keyhole_len, 1.5]) cylinder(d = keyhole_head_d, h = back_t);
  }
}

// ---------------- test fit ring ----------------
module test_fit() {
  intersection() {
    front_shell();
    union() {
      translate([0, y_mid, 0]) linear_extrude(front_t + 3.0) square([outer_w + 2, outer_h + 2], center = true);
      // right wall around the USB-C opening, full depth
      translate([-outer_w/2 - 1, usb_y - 15, 0]) cube([wall + 1.5, 30, depth]);
    }
  }
}

// ---------------- ghost parts for the preview ----------------
module ghost_module() {
  color([0.08, 0.08, 0.09]) translate([-glass_w/2, -glass_h/2, front_t]) cube([glass_w, glass_h, glass_t]);
  color([0.10, 0.45, 0.20]) translate([-pcb_w/2, glass_h/2 - pcb_top_from_top - pcb_h, front_t + pcb_back - 1.6])
    cube([pcb_w, pcb_h, 1.6]);
  // terminal block along the PCB bottom edge (26.3 mm from the left edge seen from the back)
  color([0.10, 0.55, 0.25]) translate([-32.8, glass_h/2 - 62.8, front_t + pcb_back])
    cube([64.5, 9.2, module_depth - pcb_back]);
  // USB-C receptacle at the right edge (seen from the front)
  color([0.75, 0.75, 0.75]) translate([-pcb_w/2 - 0.5, usb_y - 4.5, usb_z - 1.6]) cube([7.5, 9.0, 3.2]);
}
module ghost_jack() {
  if (dc_jack) color([0.15, 0.15, 0.15])
    translate([dc_x, y_bot + wall, dc_zc]) rotate([-90, 0, 0]) cylinder(d = 9, h = 16);
}
module ghost_sensor() {
  color([0.45, 0.15, 0.55]) translate([sensor_x_off + (sensor_hole_left_x + sensor_hole_right_x)/2, chin_cy, front_t + pillar_h]) linear_extrude(1.6)
    difference() { square([25, 10.6], center = true);
      for (hx = [sensor_hole_left_x, sensor_hole_right_x]) translate([hx - (sensor_hole_left_x + sensor_hole_right_x)/2, 0]) circle(d = 2.7); }
  color([0.05, 0.05, 0.05]) translate([sensor_x_off + sensor_win_dx - sensor_chip_w/2, chip_y - sensor_chip_h/2, front_t + pillar_h - sensor_chip_t])
    cube([sensor_chip_w, sensor_chip_h, sensor_chip_t]);
}

// ---------------- output ----------------
if (PART == "front")    front_shell();
if (PART == "white")    front_shell();
if (PART == "black")    black_part();
if (PART == "back")     back_plate();
if (PART == "testfit")  test_fit();
if (PART == "sensortest") sensor_test();
if (PART == "sensorinsert") sensor_insert_part();
if (PART == "assembly") {
  color([0.93, 0.93, 0.95]) front_shell();
  ghost_module();
  if (sensor_insert) color([0.1, 0.1, 0.1]) sensor_insert_part();
  ghost_sensor();
  ghost_jack();
  // flipped over about the vertical axis, exactly as it is fitted
  color([0.80, 0.80, 0.83]) translate([0, 0, depth + back_t + 25]) rotate([0, 180, 0]) back_plate();
}
