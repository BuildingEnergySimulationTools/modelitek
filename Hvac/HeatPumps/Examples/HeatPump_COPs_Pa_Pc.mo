within Modelitek.Hvac.HeatPumps.Examples;

model HeatPump_COPs_Pa_Pc
  Modelica.Blocks.Sources.Sine sine1(amplitude = 20, f = 1e-6, offset = 273.15 + 25) annotation(
    Placement(transformation(origin = {-89, -79}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT downstream_boundary(redeclare package Medium = Buildings.Media.Water "Water", T = 273.15 + 30, nPorts = 1, p = 1e5) annotation(
    Placement(transformation(origin = {84, -88}, extent = {{10, -10}, {-10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT upstream_boundary(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", T = 273.15 + 30, nPorts = 1, p = 1e5) annotation(
    Placement(transformation(origin = {-40, -132}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression T_constant_downstream(y = 273.15 + 18) "1 for winter" annotation(
    Placement(transformation(origin = {-29.8, -66}, extent = {{196.8, -74}, {148.8, -54}})));
  Modelica.Blocks.Sources.BooleanPulse on_off(width = 50, period = 750, startTime = 0)  annotation(
    Placement(transformation(origin = {-14, -190}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Pulse DHW_or_heating(width = 200, period = 750)  annotation(
    Placement(transformation(origin = {-92, -146}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT upstream_source(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.40, property_T = 293.15) "Propylene glycol water, 40% mass fraction", T = 273.15 + 30, nPorts = 1, p = 1e5, use_T_in = true) annotation(
    Placement(transformation(origin = {-42, -80}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT downstream_source(redeclare package Medium = Buildings.Media.Water "Water", T = 273.15 + 30, nPorts = 1, p = 1e5, use_T_in = true) annotation(
    Placement(transformation(origin = {83, -134}, extent = {{10, -10}, {-10, 10}})));
  Modelitek.Hvac.HeatPumps.HeatPump_COPs_Pa_Pc heatPump_COPs_new(redeclare package Medium_source = Buildings.Media.Antifreeze.PropyleneGlycolWater(X_a = 0.37, property_T = 220) "Propylene glycol water, 40% mass fraction", redeclare package Medium_load = Buildings.Media.Water "Water")  annotation(
    Placement(transformation(origin = {28, -108}, extent = {{-16, -18}, {16, 18}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression Period(y = 0) annotation(
    Placement(transformation(origin = {57, -100}, extent = {{-82, -74}, {-62, -54}})));
equation
 connect(sine1.y, upstream_source.T_in) annotation(
    Line(points = {{-78, -78}, {-54, -78}, {-54, -76}}, color = {0, 0, 127}));
 connect(DHW_or_heating.y, heatPump_COPs_new.demande) annotation(
    Line(points = {{-81, -146}, {11, -146}, {12, -122}}, color = {0, 0, 127}));
 connect(Period.y, heatPump_COPs_new.period) annotation(
    Line(points = {{-4, -164}, {22, -164}, {22, -122}}, color = {0, 0, 127}));
 connect(on_off.y, heatPump_COPs_new.y) annotation(
    Line(points = {{-2, -190}, {32, -190}, {32, -122}}, color = {255, 0, 255}));
 connect(upstream_boundary.ports[1], heatPump_COPs_new.port_b_source) annotation(
    Line(points = {{-30, -132}, {16, -132}, {16, -122}}, color = {0, 127, 255}));
 connect(upstream_source.ports[1], heatPump_COPs_new.port_a_source) annotation(
    Line(points = {{-32, -80}, {16, -80}, {16, -94}}, color = {0, 127, 255}));
 connect(downstream_source.ports[1], heatPump_COPs_new.port_a_loa) annotation(
    Line(points = {{74, -134}, {38, -134}, {38, -120}}, color = {0, 127, 255}));
 connect(T_constant_downstream.y, downstream_source.T_in) annotation(
    Line(points = {{116, -130}, {96, -130}}, color = {0, 0, 127}));
 connect(heatPump_COPs_new.port_b_loa, downstream_boundary.ports[1]) annotation(
    Line(points = {{38, -94}, {40, -94}, {40, -88}, {74, -88}}, color = {0, 127, 255}));
  annotation(
    Documentation(info = "<html><head></head><body>
<h4>Overview</h4>
<p>
The <code>HeatPump_COPs_Pa_Pc</code> example demonstrates the use of the
<code>HeatPump_COPs_Pa_Pc</code> model with tabulated performance data (Pa, Pc, COP).
It connects the heat pump to source and load boundaries with prescribed temperatures,
and shows how the component responds to on/off activation and demand signals.
</p>

<h4>Inputs</h4>
<ul>
<li><b>sine1 (K):</b> Source-side inlet temperature variation (sinusoidal).</li>
<li><b>T_constant_downstream (K):</b> Constant load-side inlet temperature.</li>
<li><b>on_off (Boolean):</b> Pulse signal to switch the heat pump on and off.</li>
<li><b>DHW_or_heating (Boolean):</b> Demand signal (DHW vs. heating mode selection).</li>
<li><b>Period (-):</b> Operating mode indicator (0 = winter, 1 = summer, intermediate values for mid-season).</li>
</ul>

<h4>Connections</h4>
<ul>
<li><b>upstream_source:</b> Boundary condition for source-side fluid with time-varying temperature.</li>
<li><b>upstream_boundary:</b> Reference boundary for source return flow.</li>
<li><b>downstream_source:</b> Boundary condition for load-side fluid with prescribed inlet temperature.</li>
<li><b>downstream_boundary:</b> Reference boundary for load return flow.</li>
</ul>

<h4>Outputs of HeatPump_COPs_Pa_Pc</h4>
<ul>
<li><b>P_th (W):</b> Instantaneous delivered thermal power to the load.</li>
<li><b>P_th_cumul (kWh):</b> Cumulative delivered thermal energy.</li>
<li><b>P_elec (W):</b> Instantaneous electrical compressor power.</li>
<li><b>P_elec_cumul (kWh):</b> Cumulative compressor electrical consumption.</li>
<li><b>COP (-):</b> Coefficient of performance, ratio of delivered thermal power to electrical power.</li>
</ul>

<h4>Notes</h4>
<ul>
<li>The source medium is a glycol-water mixture (40% mass fraction), while the load medium is water.</li>
<li>This example is not a full heating system but a performance test setup for the heat pump model.</li>
<li>The pulse signals for <code>on_off</code> and <code>DHW_or_heating</code> illustrate the switching behavior between different operating conditions.</li>
<li>Energy outputs are reported in kWh, computed via time integration of power flows.</li>
</ul>
</body></html>"),
    Diagram(coordinateSystem(extent = {{-120, -60}, {180, -200}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    experiment(StartTime = 0, StopTime = 100000, Tolerance = 1e-06, Interval = 2000),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end HeatPump_COPs_Pa_Pc;
