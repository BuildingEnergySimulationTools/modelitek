within Modelitek.Controls.Data;

record SetpointParams
  parameter Boolean usePoints = true;

  // Mode 1 : 2 points
  parameter Real Text1;
  parameter Real Tset1;
  parameter Real Text2;
  parameter Real Tset2;

  // Mode 2 : équation explicite
  parameter Real a;
  parameter Real b;
end SetpointParams;
