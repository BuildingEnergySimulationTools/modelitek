within Modelitek.SolarCollector.Examples;

model Example_SolarCollector
  final package MediumA = Media.PropyleneGlycolWater(property_T = 273.15 + 20, X_a = 0.37, T_min = 200) "Medium model for glycol";
  FluidPortSolarCollector fluidPortSolarCollector(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction") annotation(
    Placement(transformation(origin = {-29, 72}, extent = {{-32, -25}, {32, 25}})));
  Modelica.Blocks.Sources.Sine I_rad(amplitude = 500, f = 1.16E-5, offset = 250) annotation(
    Placement(transformation(origin = {-86, 101}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Sine T_ext(amplitude = 8.5, f = 1.16E-5, offset = 273.15 + 20) annotation(
    Placement(transformation(origin = {-86, 84}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Sources.Sine Wind_speed(amplitude = 15, f = 0.02, offset = 7.5) annotation(
    Placement(transformation(origin = {-86, 65}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Fluid.Sources.Boundary_pT boundary1(nPorts = 1, redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction") annotation(
    Placement(transformation(origin = {38, 44}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", use_m_flow_in = true, use_T_in = true, nPorts = 1) annotation(
    Placement(transformation(origin = {-112, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression constantFluidflow(y = 1.0) "kg/s" annotation(
    Placement(transformation(origin = {-74, 110}, extent = {{-82, -74}, {-62, -54}})));
  Modelica.Blocks.Sources.Sine Tfluid(amplitude = 15, f = 1e-4, offset = 273.15 + 20) annotation(
    Placement(transformation(origin = {-144, 30}, extent = {{-5, -5}, {5, 5}})));
equation
  connect(fluidPortSolarCollector.port_b, boundary1.ports[1]) annotation(
    Line(points = {{2, 50}, {2, 44}, {28, 44}}, color = {0, 127, 255}));
  connect(I_rad.y, fluidPortSolarCollector.Irad) annotation(
    Line(points = {{-80, 102}, {-72, 102}, {-72, 80}, {-48, 80}}, color = {0, 0, 127}));
  connect(T_ext.y, fluidPortSolarCollector.Text) annotation(
    Line(points = {{-80, 84}, {-76, 84}, {-76, 70}, {-48, 70}}, color = {0, 0, 127}));
  connect(Wind_speed.y, fluidPortSolarCollector.Wspeed) annotation(
    Line(points = {{-80, 66}, {-68, 66}, {-68, 60}, {-48, 60}}, color = {0, 0, 127}));
  connect(boundary.ports[1], fluidPortSolarCollector.port_a) annotation(
    Line(points = {{-102, 36}, {-70, 36}, {-70, 50}, {-60, 50}}, color = {0, 127, 255}));
  connect(constantFluidflow.y, boundary.m_flow_in) annotation(
    Line(points = {{-134, 46}, {-124, 46}, {-124, 44}}, color = {0, 0, 127}));
  connect(Tfluid.y, boundary.T_in) annotation(
    Line(points = {{-138, 30}, {-134, 30}, {-134, 40}, {-124, 40}}, color = {0, 0, 127}));
  annotation(
  Documentation(info = "
<html>
<head></head>
<body>
<h4>Example_SolarCollector</h4>

<p>
This example demonstrates the use of <code>FluidPortSolarCollector</code> in a simple test setup.  
It connects the collector to fluid boundary conditions and applies time-varying environmental inputs.
</p>

<h5>Configuration</h5>
<ul>
  <li><b>I_rad</b>: sinusoidal solar irradiance input [W/m²]</li>
  <li><b>T_ext</b>: sinusoidal ambient temperature input [K]</li>
  <li><b>Wind_speed</b>: sinusoidal wind speed input [m/s]</li>
  <li><b>Tfluid</b>: varying inlet fluid temperature [K]</li>
  <li><b>constantFluidflow</b>: constant mass flow rate through the collector [kg/s]</li>
</ul>

<h5>Purpose</h5>
<p>
The model is designed to test and illustrate the dynamic response of the solar collector model
under varying solar, thermal, and hydraulic conditions. It can serve as a validation or 
demonstration case for building system integration.
</p>
</body>
</html>"),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-160, 120}, {60, 20}})),
    experiment(StartTime = 0, StopTime = 180000, Tolerance = 1e-06, Interval = 3600),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end Example_SolarCollector;
