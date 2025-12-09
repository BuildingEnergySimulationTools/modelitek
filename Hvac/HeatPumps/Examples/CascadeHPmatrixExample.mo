within Modelitek.Hvac.HeatPumps.Examples;

model CascadeHPmatrixExample
  extends Modelica.Icons.Example;
  
  parameter Real COP_pivot = 3.;
  parameter Modelica.Units.SI.Power Pabs_pivot_cop = 33333;
  
  parameter Real EER_pivot = 3.;
  parameter Modelica.Units.SI.Power Pabs_pivot_eer = 33333;
  
  parameter Modelica.Units.SI.Power Qreq = 115000*4;
  parameter Modelica.Units.SI.Time slope_duration = 100000;
  Modelica.Blocks.Sources.RealExpression tamont(y = -7)  annotation(
    Placement(transformation(origin = {-72, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression taval(y = 42.5) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = Qreq, duration = slope_duration)  annotation(
    Placement(transformation(origin = {-72, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression Heat_cool(y = true)  annotation(
    Placement(transformation(origin = {-72, -26}, extent = {{-10, -10}, {10, 10}})));
  CascadeHP cascadeHP(n_hp = 3, cfg=Modelitek.Hvac.HeatPumps.HPData.AirWater_AquaSnap140P(), tau = 600)  annotation(
    Placement(transformation(origin = {6, -6}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(ramp.y, cascadeHP.Q_req) annotation(
    Line(points = {{-60, -62}, {-40, -62}, {-40, 2}, {-6, 2}}, color = {0, 0, 127}));
  connect(tamont.y, cascadeHP.T_amont) annotation(
    Line(points = {{-60, -10}, {-28, -10}, {-28, -2}, {-6, -2}, {-6, -4}}, color = {0, 0, 127}));
  connect(taval.y, cascadeHP.T_aval) annotation(
    Line(points = {{-60, 6}, {-34, 6}, {-34, -10}, {-4, -10}}, color = {0, 0, 127}));
  connect(Heat_cool.y, cascadeHP.heating) annotation(
    Line(points = {{-60, -26}, {-24, -26}, {-24, -8}, {-6, -8}}, color = {255, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 100000, Tolerance = 1e-06, Interval = 200),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
  Diagram(coordinateSystem(extent = {{-100, 20}, {20, -80}})));
end CascadeHPmatrixExample;
