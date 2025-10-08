within Modelitek.Sensors.Examples;

model EnergyMeterExample
  Buildings.Fluid.Sources.Boundary_pT boundary_pT(T = 273.15 + 30, nPorts = 1, p = 1200, redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction") annotation(
    Placement(transformation(origin = {83, 61}, extent = {{10, -10}, {-10, 10}})));
  EnergyMeter energyMeter(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction")  annotation(
    Placement(transformation(origin = {38, 46}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT1(T = 273.15 + 30, nPorts = 1, p = 1200, redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction") annotation(
    Placement(transformation(origin = {1, 25}, extent = {{-10, -10}, {10, 10}})));
  TemperatureFlow temperatureFlow(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction")  annotation(
    Placement(transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine sine(amplitude = 500, f = 1e-4, offset = 250)  annotation(
    Placement(transformation(origin = {-80, 92}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y = 1) "constant here, but can vary over time" annotation(
    Placement(transformation(origin = {-6, 125}, extent = {{-82, -74}, {-62, -54}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(nPorts = 1, redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", use_m_flow_in = true, use_T_in = true)  annotation(
    Placement(transformation(origin = {88, 24}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.RealExpression flow1(y = 1.15) "1 for winter" annotation(
    Placement(transformation(origin = {61, 96}, extent = {{82, -74}, {62, -54}})));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 20, f = 1e-6, offset = 273.15 +25) annotation(
    Placement(transformation(origin = {134, 4}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.RealExpression WinterMode1(y = 1) "1 for winter" annotation(
    Placement(transformation(origin = {-5, 105}, extent = {{-82, -74}, {-62, -54}})));
  ExtractEnergy extractEnergy(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction")  annotation(
    Placement(transformation(origin = {-40, 62}, extent = {{-15, -10}, {15, 10}})));
equation
  connect(flow1.y, boundary1.m_flow_in) annotation(
    Line(points = {{122, 32}, {100, 32}}, color = {0, 0, 127}));
  connect(sine1.y, boundary1.T_in) annotation(
    Line(points = {{123, 4}, {115, 4}, {115, 28}, {99, 28}}, color = {0, 0, 127}));
  connect(energyMeter.port_b, boundary_pT.ports[1]) annotation(
    Line(points = {{42.5, 54}, {59.5, 54}, {59.5, 61}, {73, 61}}, color = {0, 127, 255}));
  connect(boundary_pT1.ports[1], energyMeter.port_b1) annotation(
    Line(points = {{11, 25}, {11, 40.5}, {34, 40.5}}, color = {0, 127, 255}));
  connect(temperatureFlow.port_b, energyMeter.port_a) annotation(
    Line(points = {{10, 62}, {17, 62}, {17, 54}, {33, 54}}, color = {0, 127, 255}));
  connect(energyMeter.port_a2, boundary1.ports[1]) annotation(
    Line(points = {{42, 40}, {62, 40}, {62, 24}, {78, 24}}, color = {0, 127, 255}));
  connect(sine.y, extractEnergy.P_demand) annotation(
    Line(points = {{-69, 92}, {-57, 92}, {-57, 68}, {-47, 68}}, color = {0, 0, 127}));
  connect(Q_flow.y, extractEnergy.Q_flow) annotation(
    Line(points = {{-67, 61}, {-46, 61}, {-46, 64}}, color = {0, 0, 127}));
  connect(WinterMode1.y, extractEnergy.seasonMode) annotation(
    Line(points = {{-66, 41}, {-54, 41}, {-54, 57}, {-46, 57}}, color = {0, 0, 127}));
  connect(extractEnergy.port_b, temperatureFlow.port_a) annotation(
    Line(points = {{-34, 61}, {-10, 61}, {-10, 62}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, 120}, {160, -20}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
  experiment(StartTime = 0, StopTime = 1e+5, Tolerance = 1e-06, Interval = 600),
  Documentation(info = "<html><head></head><body><strong data-start=\"1649\" data-end=\"1676\">Purpose of the example:</strong><br><div>
<ul data-start=\"1680\" data-end=\"2146\">
<li data-start=\"1680\" data-end=\"1810\">
<p data-start=\"1682\" data-end=\"1810\">Illustrates how <strong data-start=\"1698\" data-end=\"1733\">heat extraction (<code data-start=\"1716\" data-end=\"1730\">ExtractEnergy</code>)</strong> and <strong data-start=\"1738\" data-end=\"1773\">energy metering (<code data-start=\"1757\" data-end=\"1770\">EnergyMeter</code>)</strong> can be combined into a small loop.</p>
</li>
<li data-start=\"1811\" data-end=\"1951\">
<p data-start=\"1813\" data-end=\"1951\">Provides a minimal testbed to validate the behavior of&nbsp;<strong data-start=\"1698\" data-end=\"1733\"><code data-start=\"1716\" data-end=\"1730\">ExtractEnergy&nbsp;</code></strong>safety logic (minimum power threshold, season mode, minimum flow protection) and the correct operation of <code data-start=\"2130\" data-end=\"2143\">EnergyMeter</code>.</p></li>
</ul>
<p data-start=\"2148\" data-end=\"2197\"><strong data-start=\"2148\" data-end=\"2161\">Use case:</strong><br data-start=\"2161\" data-end=\"2164\">
This type of setup is useful for:</p>
<ul data-start=\"2198\" data-end=\"2440\">
<li data-start=\"2198\" data-end=\"2287\">
<p data-start=\"2200\" data-end=\"2287\">Testing the integration of components before embedding them in a full building model.</p>
</li>
<li data-start=\"2288\" data-end=\"2352\">
<p data-start=\"2290\" data-end=\"2352\">Checking cumulative energy balances in simplified scenarios.</p>
</li>
<li data-start=\"2353\" data-end=\"2440\">
<p data-start=\"2355\" data-end=\"2440\">Demonstrating how to couple external control signals with fluid-based energy flows.</p></li></ul><!--EndFragment--></div></body></html>"),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end EnergyMeterExample;
