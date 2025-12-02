within Modelitek.Hvac.Boilers.Examples;

model GasBoiler
  Modelitek.Hvac.Boilers.GasBoiler gasBoiler(cfg(P_nom = 200, redeclare Modelitek.Hvac.Boilers.BoilerData.GasBoiler_LT400 coeffs, redeclare Modelitek.Hvac.Boilers.BoilerData.GasBoilerCondensation therm)) annotation(
    Placement(transformation(origin = {12, 9}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine Tamb(amplitude = 5, f = 1/60/60/24, offset = 18)  annotation(
    Placement(transformation(origin = {-58, -14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Pulse pulse(amplitude = 15, width = 75, period = 86400, offset = 25)  annotation(
    Placement(transformation(origin = {-58, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine Q_req(amplitude = 75e3, f = 1/60/60/24, offset = 150e3) annotation(
    Placement(transformation(origin = {-59, 53}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(Tamb.y, gasBoiler.T_amb) annotation(
    Line(points = {{-46, -14}, {-30, -14}, {-30, 2}, {0, 2}}, color = {0, 0, 127}));
  connect(pulse.y, gasBoiler.T_out) annotation(
    Line(points = {{-47, 20}, {-30, 20}, {-30, 9}, {0, 9}}, color = {0, 0, 127}));
  connect(Q_req.y, gasBoiler.Q_req) annotation(
    Line(points = {{-48, 53}, {-24, 53}, {-24, 17}, {0, 17}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-80, 80}, {40, -40}})),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
  experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end GasBoiler;
