within Modelitek.Valves.Examples;

model LoopForControlledTemperature
  replaceable package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220.0, X_a = 0.40);
  Modelica.Blocks.Sources.RealExpression constantFlow(y = 2) "kg/s" annotation(
    Placement(transformation(origin = {80, 51}, extent = {{-14, -7}, {14, 7}}, rotation = -90)));
  Modelica.Blocks.Sources.Sine Sine_temperature(amplitude = 16, f = 1/3600/2, offset = 273.15 + 30) annotation(
    Placement(transformation(origin = {-88, 40}, extent = {{-8, -8}, {8, 8}})));
  Buildings.Fluid.Sources.MassFlowSource_T source_CAPT(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-40, 14}, extent = {{-8, -8}, {8, 8}})));
  Buildings.Fluid.Sources.MassFlowSource_T source_aerotherm(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {66, -8}, extent = {{8, -8}, {-8, 8}})));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT1(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1) annotation(
    Placement(transformation(origin = {66, 14}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT2(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1) annotation(
    Placement(transformation(origin = {-38, -8}, extent = {{6, -6}, {-6, 6}}, rotation = -180)));
  FeedbackLoop feedbackLoop(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", Ti = 50, controllerType = Modelica.Blocks.Types.SimpleController.PID) annotation(
    Placement(transformation(origin = {14, 2}, extent = {{-12, -20}, {12, 20}})));
  Modelica.Blocks.Sources.RealExpression T_constant(y = 273.15 + 10) "kg/s" annotation(
    Placement(transformation(origin = {110, -10}, extent = {{14, -7}, {-14, 7}}, rotation = -0)));
  Modelica.Blocks.Sources.TimeTable T_set(table = [0, 273.15 + 15; 3600, 273.15 + 20; 7200, 273.15 + 10]) annotation(
    Placement(transformation(origin = {-22, 60}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_afterloop(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = 1) annotation(
    Placement(transformation(origin = {82.4546, 13.4616}, extent = {{-49.4546, -6.46153}, {-33.4546, 7.53844}})));
equation
  connect(source_CAPT.ports[1], feedbackLoop.port_source_in) annotation(
    Line(points = {{-32, 14}, {4, 14}}, color = {0, 127, 255}));
  connect(source_aerotherm.ports[1], feedbackLoop.port_sink_in) annotation(
    Line(points = {{58, -8}, {24, -8}}, color = {0, 127, 255}));
  connect(boundary_pT2.ports[1], feedbackLoop.port_source_out) annotation(
    Line(points = {{-32, -8}, {4, -8}}, color = {0, 127, 255}));
  connect(Sine_temperature.y, source_CAPT.T_in) annotation(
    Line(points = {{-80, 40}, {-64, 40}, {-64, 18}, {-50, 18}}, color = {0, 0, 127}));
  connect(source_CAPT.m_flow_in, constantFlow.y) annotation(
    Line(points = {{-50, 20}, {-56, 20}, {-56, 36}, {80, 36}}, color = {0, 0, 127}));
  connect(constantFlow.y, source_aerotherm.m_flow_in) annotation(
    Line(points = {{80, 36}, {80, -2}, {76, -2}}, color = {0, 0, 127}));
  connect(T_set.y, feedbackLoop.T_set) annotation(
    Line(points = {{-11, 60}, {-11, 26}, {14, 26}, {14, 18}}, color = {0, 0, 127}));
  connect(feedbackLoop.port_sink_out, T_afterloop.port_a) annotation(
    Line(points = {{24, 14}, {34, 14}}, color = {0, 127, 255}));
  connect(T_afterloop.port_b, boundary_pT1.ports[1]) annotation(
    Line(points = {{50, 14}, {60, 14}}, color = {0, 127, 255}));
  connect(T_constant.y, source_aerotherm.T_in) annotation(
    Line(points = {{94, -10}, {82, -10}, {82, -4}, {76, -4}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "
<html>
<h4>Example_Feedback</h4>
<p>
This example demonstrates the use of the <b>FeedbackLoop</b> model to regulate 
the outlet temperature of a hydraulic system using a PI controller and a 
three-way valve.
</p>

<h5>Description</h5>
<p>
Two variable-temperature sources are connected through the <code>FeedbackLoop</code>:
<ul>
  <li><b>source_CAPT</b>: provides a sine-varying inlet temperature,</li>
  <li><b>source_aerotherm</b>: provides a secondary time-varying inlet temperature.</li>
</ul>
A fixed mass flow rate is imposed for both sources using <code>constantFlow</code>. 
The <code>FeedbackLoop</code> compares the measured outlet temperature with a 
time-varying setpoint <code>T_set</code> (expressed in Kelvin). The PI controller 
adjusts the three-way valve position to maintain the desired outlet temperature.
</p>

<h5>Setpoint</h5>
<p>
The setpoint <code>T_set</code> is defined in Kelvin. In this case study it can 
be constant (e.g. 283.15 K = 10 °C) or time-dependent (e.g. using a 
<code>Step</code> or <code>TimeTable</code> source). Changing the setpoint 
illustrates the response of the control loop:
<ul>
  <li>When <code>T_set</code> is lower than the measured outlet temperature, 
      the valve reduces the contribution of the hotter source.</li>
  <li>When <code>T_set</code> is higher, the valve increases the contribution 
      of the hotter source.</li>
</ul>
</p>

<h5>Experiment setup</h5>
<p>
The simulation runs for 7200 s (2 hours) with a fixed output interval of 60 s.
The setpoint and the source temperatures vary over time, showing how the 
<code>FeedbackLoop</code> maintains the outlet temperature close to its target.
</p>
</html>
    "),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {0, 128, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-34, 56}, {70, 0}, {-32, -58}, {-34, 56}}), Ellipse(lineColor = {0, 128, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-96, -100}, {104, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {0, 128, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-34, 56}, {70, 0}, {-32, -58}, {-34, 56}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-100, 100}, {140, -40}})),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 60),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end LoopForControlledTemperature;
