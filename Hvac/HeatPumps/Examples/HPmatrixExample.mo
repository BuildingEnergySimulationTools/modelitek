within Modelitek.Hvac.HeatPumps.Examples;

model HPmatrixExample
  extends Modelica.Icons.Example;
  
  parameter Real COP_pivot = 3.;
  parameter Modelica.Units.SI.Power Pabs_pivot_cop = 33333;
  
  parameter Real EER_pivot = 3.;
  parameter Modelica.Units.SI.Power Pabs_pivot_eer = 33333;
  
  parameter Modelica.Units.SI.Power Qreq = 100000;
  parameter Modelica.Units.SI.Time slope_duration = 100000;
  
  
  HPmatrix hPmatrix(cfg = HPData.AirWater_sup100kW(
    COP_pivot=COP_pivot, 
    Pabs_pivot_cop=Pabs_pivot_cop,
    eer_pivot=EER_pivot,
    Pabs_pivot_eer=Pabs_pivot_eer,
    CcpLRcontmin = 1.
  ))  annotation(
    Placement(transformation(origin = {4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression tamont(y = -7)  annotation(
    Placement(transformation(origin = {-72, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression taval(y = 42.5) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = Qreq, duration = slope_duration)  annotation(
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
    experiment(StartTime = 0, StopTime = 100000, Tolerance = 1e-06, Interval = 200),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end HPmatrixExample;
