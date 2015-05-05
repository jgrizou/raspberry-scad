include <raspberry_pi_Bplus_def.scad>

module add_raspberry_pi_Bplus(center=true){

  if (center==true){
    translate([-RaspberryPiBplusLength/2, -RaspberryPiBplusWidth/2-RaspberryPiBplusJackConnectorOutter, -RaspberryPiBplusZoffset])
      add_raspberry_pi_Bplus(center=false);
  } else {
    import("raspberry_pi_Bplus.STL", convexity=10);
  }
}

module raspberry_pi_Bplus_hole_support(boardHeight=5, holeType="spike", center=true) {

  if (center==true){
    translate([-RaspberryPiBplusLength/2, -RaspberryPiBplusWidth/2, 0])
      raspberry_pi_Bplus_hole_support(boardHeight, holeType, center=false);
  } else {
    translate([RaspberryPiBplusHolesDistToSide, RaspberryPiBplusHolesDistToSide, 0]){
      add_hole_support(boardHeight, holeType);
      translate([RaspberryPiBplusBetweenHolesLength,0,0])
        add_hole_support(boardHeight, holeType);
      translate([0,RaspberryPiBplusBetweenHolesWidth,0])
        add_hole_support(boardHeight, holeType);
      translate([RaspberryPiBplusBetweenHolesLength,RaspberryPiBplusBetweenHolesWidth,0])
        add_hole_support(boardHeight, holeType);
    }
  }
}

module add_hole_support(boardHeight, holeType) {

  if (holeType == "cone"){
    cylinder(h=2*boardHeight, d1=RaspberryPiBplusHolesDiameter+1.25, d2=RaspberryPiBplusHolesDiameter-1.25);
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
  raspberry_pi_Bplus_hole_support(boardHeight, "cone");
  translate([0,0,boardHeight])
    add_raspberry_pi_Bplus();

  translate([0, 60, 0]){
    raspberry_pi_Bplus_hole_support(boardHeight, "screw");
    translate([0,0,boardHeight])
      add_raspberry_pi_Bplus();
  }

  translate([0, 120, 0]){
    raspberry_pi_Bplus_hole_support(boardHeight, "spike");
    translate([0,0,boardHeight])
      add_raspberry_pi_Bplus();
  }
}
