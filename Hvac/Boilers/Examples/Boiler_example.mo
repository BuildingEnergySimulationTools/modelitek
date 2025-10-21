within Modelitek.Hvac.Boilers.Examples;

model Boiler_example
  Modelica.Blocks.Sources.Sine sine1(amplitude = 20, f = 1e-6, offset = 273.15 + 25) annotation(
    Placement(transformation(origin = {-101, 15}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression T_sp(y = 60 + 273.15) annotation(
    Placement(transformation(origin = {-44, 41}, extent = {{-14, -7}, {14, 7}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(use_m_flow_in = true, use_T_in = true, nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {-52, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Flowrate(y = 2) annotation(
    Placement(transformation(origin = {-89, 53}, extent = {{-14, -7}, {14, 7}})));
  Buildings.Fluid.Sources.Boundary_pT downstream_boundary(redeclare package Medium = Buildings.Media.Water "Water", T = 273.15 + 30, nPorts = 1, p = 1e5) annotation(
    Placement(transformation(origin = {47, -3}, extent = {{10, -10}, {-10, 10}})));
  Buildings.Fluid.Sensors.Temperature senTem(redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {14, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelitek.Hvac.Boilers.BoilerReal boilerReal(redeclare package Medium = Buildings.Media.Water "Water", efficiency = 0.5) annotation(
    Placement(transformation(origin = {-20, 14}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary111(redeclare package Medium = Buildings.Media.Water "Water", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-64, -56}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT downstream_boundary111(redeclare package Medium = Buildings.Media.Water "Water", T = 273.15 + 30, nPorts = 1, p = 1e5) annotation(
    Placement(transformation(origin = {35, -73}, extent = {{10, -10}, {-10, 10}})));
  Buildings.Fluid.Sensors.Temperature senTem111(redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {2, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelitek.Hvac.Boilers.BoilerIdealFlow boilerIdeal(redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {-24, -54}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(sine1.y, boundary.T_in) annotation(
    Line(points = {{-90, 16}, {-64, 16}}, color = {0, 0, 127}));
  connect(Flowrate.y, boundary.m_flow_in) annotation(
    Line(points = {{-74, 53}, {-64, 53}, {-64, 20}}, color = {0, 0, 127}));
  connect(boundary.ports[1], boilerReal.port_a) annotation(
    Line(points = {{-42, 12}, {-30, 12}, {-30, 14}}, color = {0, 127, 255}));
  connect(boilerReal.port_b, downstream_boundary.ports[1]) annotation(
    Line(points = {{-10, 14}, {38, 14}, {38, -2}}, color = {0, 127, 255}));
  connect(boilerReal.port_b, senTem.port) annotation(
    Line(points = {{-10, 14}, {14, 14}, {14, 34}}, color = {0, 127, 255}));
  connect(T_sp.y, boilerReal.T_consigne) annotation(
    Line(points = {{-29, 41}, {-29, 8}, {-20, 8}}, color = {0, 0, 127}));
  connect(boundary111.ports[1], boilerIdeal.port_a) annotation(
    Line(points = {{-54, -56}, {-34, -56}, {-34, -54}}, color = {0, 127, 255}));
  connect(boilerIdeal.port_b, downstream_boundary111.ports[1]) annotation(
    Line(points = {{-14, -54}, {6, -54}, {6, -72}, {26, -72}}, color = {0, 127, 255}));
  connect(boilerIdeal.port_b, senTem111.port) annotation(
    Line(points = {{-14, -54}, {2, -54}, {2, -36}}, color = {0, 127, 255}));
  connect(sine1.y, boundary111.T_in) annotation(
    Line(points = {{-90, 16}, {-92, 16}, {-92, -52}, {-76, -52}}, color = {0, 0, 127}));
  connect(Flowrate.y, boundary111.m_flow_in) annotation(
    Line(points = {{-74, 54}, {-76, 54}, {-76, -48}}, color = {0, 0, 127}));
  connect(T_sp.y, boilerIdeal.T_consigne) annotation(
    Line(points = {{-28, 42}, {-24, 42}, {-24, -60}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "
<html>
<head></head>
<body>
<h4>Boiler_example</h4>

<p>
This example demonstrates and compares two different boiler models from 
<code>Modelitek.Hvac.Boilers</code> in a simple hydronic heating loop.
</p>

<p>
The setup consists of two parallel test cases:
<ul>
  <li><b>BoilerReal</b>: a more physical formulation where the boiler is modeled with 
      an internal <code>MixingVolume</code> that stores energy, computes fluid enthalpy, 
      and injects heat using <code>PrescribedHeatFlow</code>. 
      The outlet temperature responds dynamically to inlet conditions, heat demand, 
      and boiler efficiency.</li>
  <li><b>BoilerIdealFlow</b>: an idealized boiler representation where the outlet flow 
      is re-injected directly at the target setpoint temperature. 
      This bypasses the volume dynamics and enforces the outlet temperature instantaneously, 
      making it useful for control testing or conceptual studies.</li>
</ul>
</p>

<p>
Both boiler variants are connected between a <code>MassFlowSource_T</

</body>
</html>
    "),
    Diagram(coordinateSystem(extent = {{-120, 60}, {60, -100}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    experiment(StartTime = 0, StopTime = 1e6, Tolerance = 1e-06, Interval = 300),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts ",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end Boiler_example;
