include <raspberry_pi_Bplus_def.scad>

module add_rasperry_pi_Bplus(center=true){

  if (center==true){
    translate([-RasperryPiBplusLength/2, -RasperryPiBplusWidth/2-RasperryPiBplusJackConnectorOutter, -RasperryPiBplusZoffset])
      add_rasperry_pi_Bplus(center=false);
  } else {
    import("raspberry_pi_Bplus.STL", convexity=10);
  }
}

module rasperry_pi_Bplus_hole_support(boardHeight=5, holeType="cone", center=true) {

  if (center==true){
    translate([-RasperryPiBplusLength/2, -RasperryPiBplusWidth/2, 0])
      rasperry_pi_Bplus_hole_support(boardHeight, holeType, center=false);
  } else {
    translate([RasperryPiBplusHolesDistToSide, RasperryPiBplusHolesDistToSide, 0]){
      add_hole_support(boardHeight, holeType);
      translate([RasperryPiBplusBetweenHolesLength,0,0])
        add_hole_support(boardHeight, holeType);
      translate([0,RasperryPiBplusBetweenHolesWidth,0])
        add_hole_support(boardHeight, holeType);
      translate([RasperryPiBplusBetweenHolesLength,RasperryPiBplusBetweenHolesWidth,0])
        add_hole_support(boardHeight, holeType);
    }
  }
}

module add_hole_support(boardHeight, holeType) {

  if (holeType == "cone"){
    cylinder(h=2*boardHeight, d1=RasperryPiBplusHolesDiameter+1.25, d2=RasperryPiBplusHolesDiameter-1.25);
  }

  if (holeType == "screw"){
    difference(){
      cylinder(h=boardHeight, d=6);
      cylinder(h=boardHeight, d=2.5);
    }
  }

  if (holeType == "spike"){
    cylinder(h=boardHeight, d=6);
    cylinder(h=boardHeight+5, d=2.5);
  }

}

// Testing
echo("##########");
echo("In raspberry_pi_B+_tools.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

use <../robotis-scad/dynamixel/xl320.scad>

p = 1;
boardHeight = 5;
if (p==1) {
  rasperry_pi_Bplus_hole_support(boardHeight, "cone");
  translate([0,0,boardHeight])
    add_rasperry_pi_Bplus();

  translate([0, 60, 0]){
    rasperry_pi_Bplus_hole_support(boardHeight, "screw");
    translate([0,0,boardHeight])
      add_rasperry_pi_Bplus();
  }

  translate([0, 120, 0]){
    rasperry_pi_Bplus_hole_support(boardHeight, "spike");
    translate([0,0,boardHeight])
      add_rasperry_pi_Bplus();
  }
}
