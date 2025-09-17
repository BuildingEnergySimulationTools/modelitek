within Modelitek.Valves.Examples;

model DualSource
  replaceable package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220.0, X_a = 0.40);
  Modelica.Blocks.Sources.RealExpression constantFlow(y = 2) "kg/s" annotation(
    Placement(transformation(origin = {6, 69}, extent = {{-14, -7}, {14, 7}}, rotation = -90)));
  Modelica.Blocks.Sources.Sine Sine_temperature(amplitude = 20, f = 1/3600/2, offset = 273.15 + 60) annotation(
    Placement(transformation(origin = {-88, 40}, extent = {{-8, -8}, {8, 8}})));
  Buildings.Fluid.Sources.MassFlowSource_T source_CAPT(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-40, 14}, extent = {{-8, -8}, {8, 8}})));
  Buildings.Fluid.Sources.MassFlowSource_T source_PAC(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {60, 14}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine_temperature_downwards(amplitude = 7.5, f = 1/3600, offset = 273.15) annotation(
    Placement(transformation(origin = {113, -7}, extent = {{7, -7}, {-7, 7}})));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {62, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Buildings.Fluid.Sources.MassFlowSource_T source_aerotherm(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {64, -30}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT1(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {62, -6}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT2(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", nPorts = 1) annotation(
    Placement(transformation(origin = {-42, -16}, extent = {{6, -6}, {-6, 6}}, rotation = -180)));
  Modelica.Blocks.Sources.Step step(height = 1, offset = 0, startTime = 3600*1.5) annotation(
    Placement(transformation(origin = {-17, 39}, extent = {{-7, -7}, {7, 7}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_canal1(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = 1) "Outlet temperature of the heater" annotation(
    Placement(transformation(origin = {76.4546, 41.4616}, extent = {{-49.4546, -6.46153}, {-33.4546, 7.53844}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_canal2(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = 1) "Outlet temperature of the heater" annotation(
    Placement(transformation(origin = {84.4546, -1.5384}, extent = {{-49.4546, -6.46153}, {-33.4546, 7.53844}})));
  DualSourceSwitch dualSourceSwitch(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 220) "Propylene glycol water, 40% mass fraction") annotation(
    Placement(transformation(origin = {4, -2}, extent = {{-9, -10}, {9, 10}})));
equation
  connect(Sine_temperature.y, source_CAPT.T_in) annotation(
    Line(points = {{-79, 40}, {-63, 40}, {-63, 17}, {-50, 17}}, color = {0, 0, 127}));
  connect(sine_temperature_downwards.y, source_aerotherm.T_in) annotation(
    Line(points = {{105, -7}, {88, -7}, {88, -26}, {74, -26}}, color = {0, 0, 127}));
  connect(constantFlow.y, source_CAPT.m_flow_in) annotation(
    Line(points = {{6, 54}, {-58, 54}, {-58, 20}, {-50, 20}}, color = {0, 0, 127}));
  connect(constantFlow.y, source_PAC.m_flow_in) annotation(
    Line(points = {{6, 54}, {78, 54}, {78, 20}, {70, 20}}, color = {0, 0, 127}));
  connect(constantFlow.y, source_aerotherm.m_flow_in) annotation(
    Line(points = {{6, 54}, {78, 54}, {78, -24}, {74, -24}}, color = {0, 0, 127}));
  connect(sine_temperature_downwards.y, source_PAC.T_in) annotation(
    Line(points = {{105, -7}, {88, -7}, {88, 18}, {70, 18}}, color = {0, 0, 127}));
  connect(T_canal2.port_b, boundary_pT1.ports[1]) annotation(
    Line(points = {{51, -1}, {52, -1}, {52, -6}, {56, -6}}, color = {0, 127, 255}));
  connect(T_canal1.port_b, boundary_pT.ports[1]) annotation(
    Line(points = {{43, 42}, {50.5, 42}, {50.5, 40}, {56, 40}}, color = {0, 127, 255}));
  connect(source_CAPT.ports[1], dualSourceSwitch.port_a) annotation(
    Line(points = {{-32, 14}, {-20, 14}, {-20, -2}, {-4, -2}}, color = {0, 127, 255}));
  connect(step.y, dualSourceSwitch.y) annotation(
    Line(points = {{-10, 40}, {2, 40}, {2, 2}}, color = {0, 0, 127}));
  connect(boundary_pT2.ports[1], dualSourceSwitch.port_b) annotation(
    Line(points = {{-36, -16}, {-20, -16}, {-20, -4}, {-4, -4}}, color = {0, 127, 255}));
  connect(T_canal1.port_a, dualSourceSwitch.port_b2) annotation(
    Line(points = {{28, 42}, {22, 42}, {22, 4}, {12, 4}}, color = {0, 127, 255}));
  connect(dualSourceSwitch.port_a2, source_PAC.ports[1]) annotation(
    Line(points = {{12, 0}, {24, 0}, {24, 14}, {52, 14}}, color = {0, 127, 255}));
  connect(T_canal2.port_a, dualSourceSwitch.port_b1) annotation(
    Line(points = {{36, 0}, {28, 0}, {28, -6}, {12, -6}}, color = {0, 127, 255}));
  connect(dualSourceSwitch.port_a1, source_aerotherm.ports[1]) annotation(
    Line(points = {{12, -10}, {32, -10}, {32, -30}, {56, -30}}, color = {0, 127, 255}));
  annotation(
    Documentation(info = "
<html>
<h4>Example_DualSource</h4>
<p>
This example demonstrates the use of the <b>DualSourceSwitch</b> to select 
between two fluid sources depending on a control signal.
</p>

<h5>Description</h5>
<p>
The model connects three fluid sources:
<ul>
  <li><b>source_CAPT</b>: a collector source with a sine-varying inlet temperature,</li>
  <li><b>source_PAC</b>: a secondary source with a sine-varying temperature,</li>
  <li><b>source_aerotherm</b>: an additional source with time-varying temperature.</li>
</ul>
The mass flow rate of each source is fixed using <code>constantFlow</code>. 
The <code>DualSourceSwitch</code> component routes the flow from either 
source 1 or source 2 to the outlets depending on the input control signal <code>y</code>, 
here provided by a <code>Step</code> block.
</p>

<h5>Outputs</h5>
<p>
Two <code>TemperatureTwoPort</code> sensors are placed at the outlets of the switch 
(<code>T_canal1</code> and <code>T_canal2</code>) to monitor the resulting outlet temperatures.
</p>

<h5>Experiment setup</h5>
<p>
The simulation runs for 7200 s (2 hours) with a fixed interval of 60 s.  
The step control input changes at 1.5 hours, switching the selected source.
</p>
</html>
    "),
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {0, 128, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-34, 56}, {70, 0}, {-32, -58}, {-34, 56}}), Ellipse(lineColor = {0, 128, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-96, -100}, {104, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {0, 128, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-34, 56}, {70, 0}, {-32, -58}, {-34, 56}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-100, 80}, {140, -40}})),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 60),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end DualSource;
