within Modelitek.Hvac.HeatPumps.Examples;

model HPmatrixExample
  extends Modelica.Icons.Example;
  HPmatrix hPmatrix(cfg = HPData.AirWater_sup100kW(COP_pivot=3.))  annotation(
    Placement(transformation(origin = {4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression tamont(y = -7)  annotation(
    Placement(transformation(origin = {-72, -28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression taval(y = 42.5) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 100000, duration = 1000)  annotation(
    Placement(transformation(origin = {-70, -62}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(tamont.y, hPmatrix.t_amont) annotation(
    Line(points = {{-61, -28}, {-34.5, -28}, {-34.5, -8}, {-6, -8}}, color = {0, 0, 127}));
  connect(taval.y, hPmatrix.t_aval) annotation(
    Line(points = {{-60, 6}, {-40, 6}, {-40, 2}, {-6, 2}}, color = {0, 0, 127}));
  connect(ramp.y, hPmatrix.Q_req) annotation(
    Line(points = {{-58, -62}, {-28, -62}, {-28, -10}, {-6, -10}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 2),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end HPmatrixExample;
