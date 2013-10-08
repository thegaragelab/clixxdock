/*---------------------------------------------------------------------------*
* Casing for the prototype TwinTab x 6 dock.
*----------------------------------------------------------------------------*
* This generates the STL for a case to fit the stripboard prototype of the
* dock.
*---------------------------------------------------------------------------*/
include <clixxio_specs.scad>;

SLIPPAGE      = 0.5;          // Add this to allow for slippage
PITCH         = 2.54;         // Hole pitch (0.1")
BOUNDARY_TOP  = 0;            // Boundary to add at top (in pitch)
BOUNDARY_BOT  = 3;            // Bounadary to add at bottom (in pitch)
BOUNDARY_SIDE = 6;            // Boundary to add at sides (in pitch)
CASE_DEPTH    = 15;           // Total depth of the case
BOARD_WIDTH   = 21 * PITCH;   // Width of the PCB
BOARD_HEIGHT  = 25 * PITCH;   // Height of the PCB
SHELL_SIZE    = 2.5 * PITCH;  // Depth of the shell top

POSITIONS = [ // Position of each slot (in pitch)
  [ 0, 1 ],  [ 0, 8 ],  [ 0, 15 ],
  [ 15, 1 ], [ 15, 8 ], [ 15, 15 ],
  ];

/** Generate a shape that can be used to cut out space for the tab and header.
 *
 * x, y  - specify the co-ordinates of the top left hand side of the header.
 * depth - how deep to make the object (on the z axis)
 */
module TwinTabCutout(x, y, slip = SLIPPAGE, depth = 4) {
  translate(v = [ (TWIN_TAB_HEADER / 2) + x, slip + y, 0 ]) {
    union() {
      // Make the header
      cube(size = [ TWIN_TAB_HEADER + (2 * slip), HEADER_HEIGHT + (2 * slip), 2 * depth ], center = true);
      // Make space for the tabs
      translate(v = [ 0, -(TAB_HEIGHT + HEADER_HEIGHT) / 2, 0 ]) {
        cube(size = [ (2 * TAB_WIDTH) + TWIN_TAB_GAP + (2 * slip), TAB_HEIGHT + (2 * slip), 2 * depth ], center = true);
        }
      }
    }
  }

/** Generate the main case
 */
module MainCase() {
  difference() {
    cube(size = [ (21 + BOUNDARY_SIDE * 2) * PITCH, (25 + BOUNDARY_TOP + BOUNDARY_BOT) * PITCH, CASE_DEPTH ], center = false);
    // Cut out space for the slots
    for(pos = POSITIONS) {
      TwinTabCutout((BOUNDARY_SIDE + pos[0]) * PITCH, (BOUNDARY_BOT + pos[1]) * PITCH, SLIPPAGE, CASE_DEPTH * 2);
      }
    // Create a gap for the circuit board
    translate(v = [ BOUNDARY_SIDE * PITCH, BOUNDARY_BOT * PITCH, SHELL_SIZE ]) {
      cube(size = [ BOARD_WIDTH, BOARD_HEIGHT + PITCH, CASE_DEPTH ], center = false);
      }
    }
  }

/** Case lid
 */
module CaseLid() {
  union() {
    intersection() {
      cube(size = [ 2 * BOARD_WIDTH, 2 * (BOARD_HEIGHT + PITCH), CASE_DEPTH - SHELL_SIZE - (2 * PITCH) ], center = false);
      for(pos = POSITIONS) {
        TwinTabCutout((BOUNDARY_SIDE + pos[0]) * PITCH, (BOUNDARY_BOT + pos[1]) * PITCH, 0, CASE_DEPTH);
        }
      }
    translate(v = [ BOUNDARY_SIDE * PITCH, BOUNDARY_BOT * PITCH, 0 ]) {
      cube(size = [ BOARD_WIDTH, BOARD_HEIGHT + PITCH, CASE_DEPTH - SHELL_SIZE - (2 * PITCH) ], center = false);
      }
    }
  }

MainCase();
// Comment out the above line and uncomment the following line for the lid.
// CaseLid();

