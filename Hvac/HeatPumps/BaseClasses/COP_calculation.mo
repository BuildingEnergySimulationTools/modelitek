within Modelitek.Hvac.HeatPumps.BaseClasses;
block COP_calculation
  "Output the product of a gain value with the input signal"
  Modelica.Blocks.Interfaces.RealInput T_amont(final unit = "K", displayUnit = "degC") "Température entrée amont PAC" annotation(
    Placement(visible = true,transformation(origin = {-98, 70}, extent = {{-24, -24}, {24, 24}}, rotation = 0), iconTransformation(origin = {-84, 84}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP(final unit = "") "COP" annotation(
    Placement(visible = true,transformation(extent = {{56, -98}, {126, -28}}, rotation = 0), iconTransformation(extent = {{78, -28}, {118, 12}}, rotation = 0)));

  parameter Real time_data(start = 1, unit = "s") "Fréquence de données [s]";
  Real a;
  Real b;
  Modelica.Blocks.Interfaces.RealInput xA(displayUnit = "degC", unit = "K") annotation(
    Placement(visible = true, transformation(origin = {-96, 28}, extent = {{-24, -24}, {24, 24}}, rotation = 0), iconTransformation(origin = {-84, 28}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xB(displayUnit = "degC", unit = "K") annotation(
    Placement(visible = true, transformation(origin = {-96, -6}, extent = {{-24, -24}, {24, 24}}, rotation = 0), iconTransformation(origin = {-84, -10}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yA(displayUnit = "degC", unit = "K") annotation(
    Placement(visible = true, transformation(origin = {-94, -40}, extent = {{-24, -24}, {24, 24}}, rotation = 0), iconTransformation(origin = {-85, -47}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput yB(displayUnit = "degC", unit = "K") annotation(
    Placement(visible = true, transformation(origin = {-94, -76}, extent = {{-24, -24}, {24, 24}}, rotation = 0), iconTransformation(origin = {-86, -86}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
equation
  a = (yB - yA) / (xB - xA);
  b = yA - a * xA;
  COP = a * T_amont + b;
 
end COP_calculation;
