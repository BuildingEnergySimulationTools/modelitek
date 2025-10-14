within Modelitek.Hvac.HeatPumps;

model HeatPump_COPs
parameter Real COP_nominal=3.0 "Heat Pump Coefficient Of Performance";
  parameter Integer Np_doc=8 "Number of datasheet performance points in table"; 
  parameter Real table[Np_doc, 2] = [-5, 0.64; 0, 0.75; 5, 0.83; 10, 0.92; 15, 0.96; 20, 0.99; 25, 1; 50, 1];
  
  Modelica.Blocks.Interfaces.RealInput T_ext(unit="C") annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_elec_in(unit="W") annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Tables.CombiTable1Ds Cop_1D(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = table)  annotation(
    Placement(visible = true, transformation(origin = {-36, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Power_to_building annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  Power_to_building = P_elec_in * COP_nominal * Cop_1D.y[1];
  connect(T_ext, Cop_1D.u) annotation(
    Line(points = {{-120, 30}, {-48, 30}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Rectangle(fillColor = {190, 190, 190}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {30, 0}, fillColor = {171, 171, 171}, fillPattern = FillPattern.Vertical, extent = {{-70, 100}, {70, -100}}), Ellipse(origin = {28, 3}, fillColor = {150, 150, 150}, fillPattern = FillPattern.Solid, extent = {{-62, 61}, {62, -61}}), Ellipse(origin = {28, 2}, fillColor = {86, 86, 86}, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Text(origin = {-69, -70}, extent = {{-27, 22}, {27, -22}}, textString = "HP")}));


equation

end HeatPump_COPs;
