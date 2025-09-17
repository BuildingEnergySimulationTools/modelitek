within Modelitek.Utilities.Examples;

model Validation_TRI
  Modelica.Blocks.Sources.RealExpression Volume_storage(y = 4) "m3" annotation(
    Placement(transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Total_surface_of_collector(y = 110) "m²" annotation(
    Placement(transformation(origin = {-30, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression SavedEnergy(y = 3E3) "kWh" annotation(
    Placement(transformation(origin = {-30, -26}, extent = {{-10, -10}, {10, 10}})));
  ROI_Calculator rOI_Calculator annotation(
    Placement(transformation(origin = {20, -2}, extent = {{-12, -12}, {12, 12}})));
equation
  connect(Total_surface_of_collector.y, rOI_Calculator.Area) annotation(
    Line(points = {{-18, 6}, {8, 6}}, color = {0, 0, 127}));
  connect(Volume_storage.y, rOI_Calculator.Volume) annotation(
    Line(points = {{-18, -10}, {-12, -10}, {-12, 0}, {8, 0}}, color = {0, 0, 127}));
  connect(SavedEnergy.y, rOI_Calculator.EnergySaved) annotation(
    Line(points = {{-19, -26}, {-6, -26}, {-6, -4}, {8, -4}}, color = {0, 0, 127}));
protected
  annotation(
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    Diagram(coordinateSystem(extent = {{-40, 20}, {40, -40}})),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts ",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end Validation_TRI;
