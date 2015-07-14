include <raspberry_pi_Bplus_def.scad>

module add_raspberry_pi_Bplus(center=true){

  if (center==true){
    translate([-RaspberryPiBplusLength/2, -RaspberryPiBplusWidth/2-RaspberryPiBplusJackConnectorOutter, -RaspberryPiBplusZoffset])
      add_raspberry_pi_Bplus(center=false);
  } else {
    import("raspberry_pi_Bplus.STL", convexity=10);
  }
}

module add_vertical_raspberry_pi_Bplus(center=true){

  if (center==true){
    translate([0,RaspberryPiBplusThickness/2,RaspberryPiBplusWidth/2])
      rotate([90,180,0])
        add_raspberry_pi_Bplus(center=true);
  } else {
    translate([RaspberryPiBplusLength/2,RaspberryPiBplusThickness/2,RaspberryPiBplusWidth/2])
      rotate([90,180,0])
        add_raspberry_pi_Bplus(center=true);
  }
}


module raspberry_pi_Bplus_hole_support(boardHeight=RaspberryPiBplusBoardHeight, holeType="spike", center=true) {

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
      cylinder(h=boardHeight, d=RaspberryPiBplusHoleOuterSupportDiameter);
      cylinder(h=boardHeight, d=RaspberryPiBplusScrewDiameter);
    }
  }

  if (holeType == "spike"){
    cylinder(h=boardHeight, d=RaspberryPiBplusHoleOuterSupportDiameter);
    cylinder(h=boardHeight+5, d=RaspberryPiBplusScrewDiameter);
  }

  if (holeType == "hole"){
    cylinder(h=boardHeight, d=RaspberryPiBplusScrewDiameter);
  }

}

module add_side_support(boardHeight=5, wallThickness=2) {

  grooveWidth = RaspberryPiBplusThickness + 2*RaspberryPiBplusThicknessTolerance;

  totalWidth = grooveWidth + 2*wallThickness;
  totalLength = RaspberryPiBplusLength + 2*wallThickness + 2*RaspberryPiBplusThicknessTolerance;

  wallHeight = RaspberryPiBplusHolesDistToSide + RaspberryPiBplusHoleOuterSupportDiameter/2;

  // height support
  translate([0,0,boardHeight/2])
    cube([totalLength, totalWidth, boardHeight], center=true);

  // right side
  translate([totalLength/2-wallThickness/2,0,boardHeight+wallHeight/2])
    cube([wallThickness, totalWidth, wallHeight], center=true);

  translate([RaspberryPiBplusLength/2-wallHeight/2+RaspberryPiBplusThicknessTolerance/2,-totalWidth/2+wallThickness/2,boardHeight+wallHeight/2])
    cube([wallHeight+RaspberryPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  translate([RaspberryPiBplusLength/2-wallHeight/2+RaspberryPiBplusThicknessTolerance/2,totalWidth/2-wallThickness/2,boardHeight+wallHeight/2])
    cube([wallHeight+RaspberryPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  //usbside
  translate([-totalLength/2+wallThickness/2,totalWidth/4-RaspberryPiBplusThickness/4,boardHeight+wallHeight/2])
    cube([wallThickness, totalWidth/2+RaspberryPiBplusThickness/2, wallHeight], center=true);

  translate([-RaspberryPiBplusLength/2+wallHeight/2-RaspberryPiBplusThicknessTolerance/2,totalWidth/2-wallThickness/2,boardHeight+wallHeight/2])
    cube([wallHeight+RaspberryPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  // middle
  translate([RaspberryPiBplusLength/2-RaspberryPiBplusBetweenHolesLength-wallHeight/2,-totalWidth/2+wallThickness/2,boardHeight+wallHeight/2])
    cube([wallHeight, wallThickness, wallHeight], center=true);

  translate([RaspberryPiBplusLength/2-RaspberryPiBplusBetweenHolesLength-wallHeight/2,totalWidth/2-wallThickness/2,boardHeight+wallHeight/2])
    cube([wallHeight, wallThickness, wallHeight], center=true);

}

module add_raspberry_camera_holder(cameraHeight=5, wallThickness=1) {

  grooveWidth = CameraPiThickness + 2*CameraPiBplusThicknessTolerance;

  totalWidth = grooveWidth + 2*wallThickness;
  totalLength = CameraPiWidth + 2*wallThickness + 2*CameraPiBplusThicknessTolerance;

  wallHeight = CameraPiLength - CameraPiMiddleHolesDistToClosestSide;

  wallOverlapWithBoard = CameraPiHolesDistToSide;

  // height support
  translate([0,0,cameraHeight/2])
    cube([totalLength, totalWidth, cameraHeight], center=true);

  // right side
  translate([totalLength/2-wallThickness/2,0,cameraHeight+wallHeight/2])
    cube([wallThickness, totalWidth, wallHeight], center=true);

  translate([CameraPiWidth/2-wallOverlapWithBoard/2+CameraPiBplusThicknessTolerance/2,-totalWidth/2+wallThickness/2,cameraHeight+wallHeight/2])
    cube([wallOverlapWithBoard+CameraPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  translate([CameraPiWidth/2-wallOverlapWithBoard/2+CameraPiBplusThicknessTolerance/2,totalWidth/2-wallThickness/2,cameraHeight+wallHeight/2])
    cube([wallOverlapWithBoard+CameraPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  // left side
  translate([-totalLength/2+wallThickness/2,0,cameraHeight+wallHeight/2])
    cube([wallThickness, totalWidth, wallHeight], center=true);

  translate([-CameraPiWidth/2+wallOverlapWithBoard/2-CameraPiBplusThicknessTolerance/2,-totalWidth/2+wallThickness/2,cameraHeight+wallHeight/2])
    cube([wallOverlapWithBoard+CameraPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);

  translate([-CameraPiWidth/2+wallOverlapWithBoard/2-CameraPiBplusThicknessTolerance/2,totalWidth/2-wallThickness/2,cameraHeight+wallHeight/2])
    cube([wallOverlapWithBoard+CameraPiBplusThicknessTolerance, wallThickness, wallHeight], center=true);
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

  translate([0, 60, 0]) {
    raspberry_pi_Bplus_hole_support(boardHeight, "screw");
    translate([0,0,boardHeight])
      add_raspberry_pi_Bplus();
  }

  translate([0, 120, 0]) {
    raspberry_pi_Bplus_hole_support(boardHeight, "spike");
    translate([0,0,boardHeight])
      add_raspberry_pi_Bplus();
  }

  translate([100,0,0]) {
    add_side_support(boardHeight);
    translate([0,0,boardHeight])
      add_vertical_raspberry_pi_Bplus();
  }

  translate([-100,0,0]) {
    add_raspberry_camera_holder();
    translate([0,0,CameraPiLength/2+boardHeight])
      cube([CameraPiWidth, CameraPiThickness, CameraPiLength], center=true);
  }


}
