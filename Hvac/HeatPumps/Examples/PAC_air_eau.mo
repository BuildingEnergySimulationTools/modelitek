within Modelitek.Hvac.HeatPumps.Examples;

model PAC_air_eau
  Modelitek.Hvac.HeatPumps.PAC_air_eau.PAC_inverter pAC_inverter(Charger_fichier_nappe = false) annotation(
    Placement(transformation(origin = {-24, 6}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable Boundaries(columns = 2:9, fileName = "C:/Users/thubert/PycharmProjects/Newable/resources/Logement_Paris.txt", tableName = "table1", tableOnFile = true) annotation(
    Placement(transformation(origin = {-81, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression P_ECS(y = 0) annotation(
    Placement(transformation(origin = {-39, 79}, extent = {{-14, -7}, {14, 7}})));
  Modelica.Blocks.Sources.RealExpression P_froid(y = 0) annotation(
    Placement(transformation(origin = {-39, 60}, extent = {{-14, -7}, {14, 7}})));
equation
  connect(Boundaries.y[2], pAC_inverter.T_amont) annotation(
    Line(points = {{-70, 44}, {-60, 44}, {-60, 14}, {-38, 14}}, color = {0, 0, 127}));
  connect(Boundaries.y[8], pAC_inverter.Q_req_ch) annotation(
    Line(points = {{-70, 44}, {-22, 44}, {-22, 18}}, color = {0, 0, 127}));
  connect(P_ECS.y, pAC_inverter.Q_req_ECS) annotation(
    Line(points = {{-23.6, 79}, {-11.6, 79}, {-11.6, 18}}, color = {0, 0, 127}));
  connect(P_froid.y, pAC_inverter.Q_req_fr) annotation(
    Line(points = {{-23.6, 60}, {-15.6, 60}, {-15.6, 18}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, 100}, {0, -20}}), graphics),
    version = "",
    uses,
  experiment(StartTime = 0, StopTime = 1e+06, Tolerance = 1e-06, Interval = 3610.11),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts -d=aliasConflicts",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
  Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}));
end PAC_air_eau;
