within Modelitek.Hvac.HeatPumps.Examples;

model HPmatrixExample
  extends Modelica.Icons.Example;
  HPmatrix hPmatrix(cfg = HPData.AirWater_sup100kW(COP_pivot=2.81, Pabs_pivot_cop=37037))  annotation(
    Placement(transformation(origin = {4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression tamont(y = -7)  annotation(
    Placement(transformation(origin = {-72, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression taval(y = 42.5) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 100000, duration = 1000)  annotation(
    Placement(transformation(origin = {-72, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression Heat_cool(y = true)  annotation(
    Placement(transformation(origin = {-72, -26}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(taval.y, hPmatrix.t_aval) annotation(
    Line(points = {{-60, 6}, {-20, 6}, {-20, 4}, {-6, 4}}, color = {0, 0, 127}));
  connect(tamont.y, hPmatrix.t_amont) annotation(
    Line(points = {{-61, -10}, {-58, -10}, {-58, 0}, {-6, 0}}, color = {0, 0, 127}));
  connect(ramp.y, hPmatrix.Q_req) annotation(
    Line(points = {{-61, -62}, {-32, -62}, {-32, -12}, {-6, -12}}, color = {0, 0, 127}));
  connect(Heat_cool.y, hPmatrix.Heating) annotation(
    Line(points = {{-60, -26}, {-50, -26}, {-50, -6}, {-6, -6}}, color = {255, 0, 255}));

annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 2),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end HPmatrixExample;
