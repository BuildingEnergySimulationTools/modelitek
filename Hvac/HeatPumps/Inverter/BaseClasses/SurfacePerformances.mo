within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;

model SurfacePerformances
  parameter Real COP_pivot;
  parameter Real Pabs_pivot;
  // Coefficients correctifs (identiques au modèle complet)
  parameter Real Cnnav_COP_23_32 = 1.1;
  parameter Real Cnnav_COP_42_32 = 0.8;
  parameter Real Cnnav_COP_51_42 = 0.8;
  parameter Real Cnnav_COP_60_51 = 0.8;
  parameter Real Cnnam_COP_3_1 = 1.1;
  parameter Real Cnnam_COP_6_1 = 0.9;
  parameter Real Cnnam_COP_8_1 = 1.2;
  parameter Real Cnnam_COP_13_1 = 1.3;
  // mêmes pour Pabs (comme modèle complet)
  parameter Real Cnnav_Pabs_23_32 = 1.09;
  parameter Real Cnnav_Pabs_42_32 = 0.9;
  parameter Real Cnnav_Pabs_51_42 = 0.915;
  parameter Real Cnnav_Pabs_60_51 = 0.91;
  parameter Real Cnnam_Pabs_3_1 = 1.05;
  parameter Real Cnnam_Pabs_6_1 = 0.95;
  parameter Real Cnnam_Pabs_8_1 = 1.1;
  parameter Real Cnnam_Pabs_13_1 = 1.15;
  // Entrées
  Modelica.Blocks.Interfaces.RealInput T_am annotation(
    Placement(transformation(origin = {-230, 124}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-96, 112}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput T_av annotation(
    Placement(transformation(origin = {-230, 104}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-96, 74}, extent = {{-11, -11}, {11, 11}})));
  // Sorties (COP et Pabs "réels")
  Modelica.Blocks.Interfaces.RealOutput COP annotation(
    Placement(transformation(origin = {-190, 104}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-8, 76}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealOutput Pabs annotation(
    Placement(transformation(origin = {-192, 124}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-8, 112}, extent = {{-11, -11}, {11, 11}})));
protected
  Real Corr_am;
  Real Corr_av;
public
algorithm
// Correction amont
  if T_am < 23 then
    Corr_am := Cnnav_COP_23_32;
  elseif T_am < 33 then
    Corr_am := 1.0;
  elseif T_am < 43 then
    Corr_am := Cnnav_COP_42_32;
  elseif T_am < 51 then
    Corr_am := Cnnav_COP_51_42;
  else
    Corr_am := Cnnav_COP_60_51;
  end if;
// Correction aval (selon T_aval chauff/ECS/clim)
  if T_av <= 30 then
    Corr_av := Cnnam_COP_3_1;
  elseif T_av <= 35 then
    Corr_av := Cnnam_COP_6_1;
  elseif T_av <= 45 then
    Corr_av := Cnnam_COP_8_1;
  else
    Corr_av := Cnnam_COP_13_1;
  end if;
  COP := COP_pivot*Corr_am*Corr_av;
  Pabs := Pabs_pivot*Corr_am*Corr_av;
  annotation(
    Diagram(coordinateSystem(extent = {{-240, 140}, {-180, 80}}), graphics),
    Icon(coordinateSystem(extent = {{-80, 120}, {-20, 60}}), graphics = {Rectangle(origin = {-51, 92}, fillPattern = FillPattern.Solid, extent = {{-33, 32}, {33, -32}}), Text(origin = {-54, 145}, textColor = {0, 0, 255}, extent = {{-60, 25}, {60, -25}}, textString = "%name")}));
end SurfacePerformances;
