within Modelitek.Controls.Examples;

model SimpleWaterControl
  Modelica.Blocks.Sources.Sine Text_winter(f = 1.12E-5, amplitude = 4, offset = 273.15 + 7) annotation(
    Placement(transformation(origin = {-112, -122}, extent = {{-10, -10}, {10, 10}})));
  Hvac.HeatingSetpointSimple heatingSetpointSimple annotation(
    Placement(transformation(origin = {-18, -120}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(Text_winter.y, heatingSetpointSimple.Text) annotation(
    Line(points = {{-100, -122}, {-26, -122}, {-26, -116}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html><head></head><body><h4><br></h4><ul>
</ul>

</body></html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {0, -140}}), graphics = {Rectangle(origin = {-88, -121}, fillColor = {170, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-50, 21}, {50, -21}}), Text(origin = {-58, -136}, extent = {{-30, 2}, {30, -2}}, textString = "Conditions")}),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 2000),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts -d=aliasConflicts",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end SimpleWaterControl;
