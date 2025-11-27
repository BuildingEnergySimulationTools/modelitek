within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model test_hp_matrix
  HPmatrix hPmatrix(LRcontmin = 0.4)  annotation(
    Placement(transformation(origin = {4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression tamont(y = -7)  annotation(
    Placement(transformation(origin = {-72, -28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression taval(y = 42.5) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 1000, duration = 1000)  annotation(
    Placement(transformation(origin = {-70, -62}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(tamont.y, hPmatrix.t_amont) annotation(
    Line(points = {{-61, -28}, {-34.5, -28}, {-34.5, -8}, {-6, -8}}, color = {0, 0, 127}));
  connect(taval.y, hPmatrix.t_aval) annotation(
    Line(points = {{-60, 6}, {-40, 6}, {-40, 2}, {-6, 2}}, color = {0, 0, 127}));
  connect(ramp.y, hPmatrix.Q_req) annotation(
    Line(points = {{-58, -62}, {-28, -62}, {-28, -10}, {-6, -10}}, color = {0, 0, 127}));
end test_hp_matrix;
