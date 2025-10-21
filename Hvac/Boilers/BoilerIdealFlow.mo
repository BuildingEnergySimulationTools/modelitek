within Modelitek.Hvac.Boilers;

model BoilerIdealFlow
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation(
    choicesAllMatching = true);
  parameter Real efficiency = 0.9 "Boiler efficiency (0..1)";
  // Ports
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));
  // Inputs/Outputs
  Modelica.Blocks.Interfaces.RealInput T_consigne(unit = "K") "Consigne température sortie" annotation(
    Placement(transformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, -58}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_boil(unit = "W") "Puissance thermique fournie (utile)" annotation(
    Placement(transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {4, 58}, extent = {{-20, -20}, {20, 20}})));
  // Source de température idéale
  Buildings.Fluid.Sources.Boundary_pT boilerBoundary(redeclare package Medium = Medium, use_T_in = false, nPorts = 1) annotation(
    Placement(transformation(origin = {54, -24}, extent = {{-40, -10}, {-60, 10}})));
  // Capteurs
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium) annotation(
    Placement(transformation(extent = {{-60, -10}, {-40, 10}})));
  Buildings.Fluid.Sensors.Temperature senTretour(redeclare package Medium = Medium, warnAboutOnePortConnection = false) annotation(
    Placement(transformation(origin = {-76, 38}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {59, 0}, extent = {{-10, -10}, {10, 10}})));
protected
  Medium.ThermodynamicState state_retour annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));
equation
// Etat thermo au retour pour calcul Cp
  state_retour = Medium.setState_pTX(p = port_a.p, T = senTretour.T, X = Medium.X_default);
// Puissance utile
  Q_boil = efficiency*max(0, senMasFlo.m_flow)*Medium.specificHeatCapacityCp(state_retour)*(T_consigne - senTretour.T);
  connect(port_a, senTretour.port) annotation(
    Line(points = {{-100, 0}, {-76, 0}, {-76, 28}}));
  connect(port_a, senMasFlo.port_a) annotation(
    Line(points = {{-100, 0}, {-60, 0}}));
  connect(senMasFlo.port_b, boilerBoundary.ports[1]) annotation(
    Line(points = {{-40, 0}, {-22, 0}, {-22, -24}, {-6, -24}}, color = {0, 127, 255}));
  connect(port_a, senTretour.port) annotation(
    Line(points = {{-100, 0}, {-40, 0}, {-40, 30}}));
  connect(boundary.ports[1], port_b) annotation(
    Line(points = {{69, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(senMasFlo.m_flow, boundary.m_flow_in) annotation(
    Line(points = {{-50, 12}, {-48, 12}, {-48, 8}, {48, 8}}, color = {0, 0, 127}));
  connect(T_consigne, boundary.T_in) annotation(
    Line(points = {{0, -80}, {38, -80}, {38, 4}, {48, 4}}, color = {0, 0, 127}));
  annotation(
    uses(Buildings(version = "12.1.0"), Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics),
    Icon(graphics = {Rectangle(origin = {5, 3}, fillColor = {255, 0, 0}, fillPattern = FillPattern.VerticalCylinder, extent = {{95, -61}, {-95, 61}}), Text(origin = {-4, 104}, textColor = {0, 0, 255}, extent = {{-100, 20}, {100, -20}}, textString = "%name")}));
end BoilerIdealFlow;
