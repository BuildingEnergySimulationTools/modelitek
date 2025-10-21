within Modelitek.Hvac.Boilers.Examples;

model BoilerOnDemand_example
  Modelica.Blocks.Sources.Sine sine1(amplitude = 20, f = 1e-6, offset = 273.15 + 25) annotation(
    Placement(transformation(origin = {-101, 15}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression T_sp(y = 60 + 273.15) annotation(
    Placement(transformation(origin = {-40, 39}, extent = {{-14, -7}, {14, 7}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(use_m_flow_in = true, use_T_in = true, nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {-52, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Flowrate(y = 2) annotation(
    Placement(transformation(origin = {-89, 53}, extent = {{-14, -7}, {14, 7}})));
  Buildings.Fluid.Sources.Boundary_pT downstream_boundary(redeclare package Medium = Buildings.Media.Water "Water", T = 273.15 + 30, nPorts = 1, p = 1e5) annotation(
    Placement(transformation(origin = {37, -5}, extent = {{10, -10}, {-10, 10}})));
  Modelitek.Hvac.Boilers.BoilerOnDemand boilerOnDemand(redeclare package Medium = Buildings.Media.Water "Water", efficiency = 0.8) annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -5}, {10, 5}})));
  Modelica.Blocks.Sources.Pulse pulse(period = 3600, amplitude = 5400) annotation(
    Placement(transformation(origin = {-64, -10}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.Temperature senTem(redeclare package Medium = Buildings.Media.Water "Water") annotation(
    Placement(transformation(origin = {-4, 28}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(sine1.y, boundary.T_in) annotation(
    Line(points = {{-90, 16}, {-64, 16}}, color = {0, 0, 127}));
  connect(Flowrate.y, boundary.m_flow_in) annotation(
    Line(points = {{-74, 53}, {-64, 53}, {-64, 20}}, color = {0, 0, 127}));
  connect(boundary.ports[1], boilerOnDemand.port_a) annotation(
    Line(points = {{-42, 12}, {-28, 12}, {-28, -3}, {-12, -3}}, color = {0, 127, 255}));
  connect(T_sp.y, boilerOnDemand.T_consigne) annotation(
    Line(points = {{-25, 39}, {-20, 39}, {-20, 4}, {-10, 4}}, color = {0, 0, 127}));
  connect(pulse.y, boilerOnDemand.P_demand) annotation(
    Line(points = {{-52, -10}, {-12, -10}, {-12, 12}}, color = {0, 0, 127}));
  connect(boilerOnDemand.port_b, senTem.port) annotation(
    Line(points = {{0, -2}, {16, -2}, {16, 18}, {-4, 18}}, color = {0, 127, 255}));
  connect(boilerOnDemand.port_b, downstream_boundary.ports[1]) annotation(
    Line(points = {{0, -2}, {28, -2}, {28, -4}}, color = {0, 127, 255}));
  annotation(
    Documentation(info = "
<html>
<head></head>
<body>
<h4>Boiler_example</h4>

<p>
This example demonstrates how to use the <code>Boiler</code> component from <code>Modelitek.Hvac</code> in a simple hydronic heating loop.
</p>

<p>
The setup consists of:
<ul>
  <li>A mass flow source (<code>MassFlowSource_T</code>) that supplies water at a prescribed mass flow rate and temperature. 
      The inlet temperature is driven by a sinusoidal signal, and the mass flow rate is fixed by a constant expression.</li>
  <li>A <code>Boiler</code> model that heats the incoming water to match a prescribed setpoint temperature.</li>
  <li>A downstream boundary (<code>Boundary_pT</code>) that fixes the outlet pressure and provides a sink for the heated water.</li>
  <li>A temperature setpoint (<code>T_sp</code>) defined as a constant expression (60&nbsp;°C).</li>
</ul>
</p>

<p>
The boiler receives the cold water flow, applies the necessary heat input to reach the setpoint temperature, and outputs 
the thermal power required. This allows testing of the boiler's control behavior and its interaction with fluid flow and temperature.
</p>

<p>
This example can be used as a reference for integrating the <code>Boiler</code> block into larger HVAC or building system models.
</p>
</body>
</html>
    "),
    Diagram(coordinateSystem(extent = {{-120, 60}, {60, -20}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    experiment(StartTime = 0, StopTime = 1e6, Tolerance = 1e-06, Interval = 300),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts ",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end BoilerOnDemand_example;
