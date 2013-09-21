/*---------------------------------------------------------------------------*
* Casing for the prototype TwinTab x 6 dock.
*----------------------------------------------------------------------------*
* This generates the STL for a case to fit the stripboard prototype of the
* dock.
*---------------------------------------------------------------------------*/
include <clixxio_specs.scad>;

// Add this to all dimensions to allow for slippage
SLIPPAGE = 0.5;

/** Generate a shape that can be used to cut out space for the tab and header.
 *
 * x, y  - specify the co-ordinates of the top left hand side of the header.
 * depth - how deep to make the object (on the z axis)
 */
module TwinTabCutout(x, y, depth = 4) {
  translate(v = [ (TWIN_TAB_HEADER / 2) + x, SLIPPAGE + y, 0 ]) {
    union() {
      // Make the header
      cube(size = [ TWIN_TAB_HEADER + (2 * SLIPPAGE), HEADER_HEIGHT + (2 * SLIPPAGE), 2 * depth ], center = true);
      // Make space for the tabs
      translate(v = [ 0, TAB_HEIGHT / 2, 0 ]) {
        cube(size = [ (2 * TAB_WIDTH) + TWIN_TAB_GAP + (2 * SLIPPAGE), TAB_HEIGHT + (2 * SLIPPAGE), 2 * depth ], center = true);
        }
      }
    }
/*
  translate(v = [ -(((TAB_WIDTH / 2) + SLIPPAGE + TWIN_TAB_GAP) / 2), TAB_HEIGHT / 2, 0 ]) {
    cube(size = [ TAB_WIDTH + (2 * SLIPPAGE), TAB_HEIGHT + (2 * SLIPPAGE), 2 * depth ], center = true);
    }
  translate(v = [ ((TAB_WIDTH / 2) + SLIPPAGE + TWIN_TAB_GAP / 2), TAB_HEIGHT / 2, 0 ]) {
    cube(size = [ TAB_WIDTH + (2 * SLIPPAGE), TAB_HEIGHT + (2 * SLIPPAGE), 2 * depth ], center = true);
    }
*/
  }

/** Main program
 */

PITCH         = 2.54;
BOUNDARY_TOP  = 9;
BOUNDARY_BOT  = 3;
BOUNDARY_SIDE = 6;

POSITIONS = [
  [ 0, 1 ],  [ 0, 8 ],  [ 0, 15 ],
  [ 15, 1 ], [ 15, 8 ], [ 15, 15 ],
  ];

difference() {
  cube(size = [ (21 + BOUNDARY_SIDE * 2) * PITCH, (25 + BOUNDARY_TOP + BOUNDARY_BOT) * PITCH, 2 ], center = false);
  for(pos = POSITIONS) {
    TwinTabCutout((BOUNDARY_SIDE + pos[0]) * PITCH, (BOUNDARY_BOT + pos[1]) * PITCH);
    }
  }


