within Modelitek.Hvac.Boilers;

model BoilerOnDemand
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium = Buildings.Media.Air "Moist air"), choice(redeclare package Medium = Buildings.Media.Water "Water"), choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.2;
  parameter Modelica.Units.SI.Volume V = 0.01;
  parameter Real efficiency = 0.9 "Boiler efficiency (0..1)";
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts = 2, redeclare package Medium = Medium, V = V, m_flow_nominal = m_flow_nominal) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput T_consigne(unit = "K") "Température de consigne" annotation(
    Placement(transformation(origin = {-92, -56}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-50, 76}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(transformation(origin = {-32, -58}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.Temperature senTretour(redeclare package Medium = Medium, warnAboutOnePortConnection = false) annotation(
    Placement(transformation(origin = {-40, 38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput P_demand(unit = "W") "in watts" annotation(
    Placement(transformation(origin = {-99, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-57, 152}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_boil(unit = "W") "Puissance thermique fournie" annotation(
    Placement(transformation(origin = {90, 20}, extent = {{-10, -10}, {10, 10}})));
protected
  Medium.ThermodynamicState state_retour annotation(
    Placement(transformation(origin = {-74, 84}, extent = {{-10, -10}, {10, 10}})));
equation
// Calcul limité par P_demand
  prescribedHeatFlow.Q_flow = min(efficiency*max(0, senMasFlo.m_flow)*Medium.specificHeatCapacityCp(state_retour)*(T_consigne - senTretour.T), P_demand);
  Q_boil = prescribedHeatFlow.Q_flow;
// Envoi de la puissance au heatPort
  connect(vol.ports[1], port_b) annotation(
    Line(points = {{0, -10}, {0, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(port_a, senMasFlo.port_a) annotation(
    Line(points = {{-60, 0}, {-42, 0}}));
  connect(senMasFlo.port_b, vol.ports[2]) annotation(
    Line(points = {{-22, 0}, {0, 0}, {0, -10}}, color = {0, 127, 255}));
  connect(port_a, senTretour.port) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, 28}}, color = {0, 127, 255}));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation(
    Line(points = {{-22, -58}, {-22, -21}, {-10, -21}, {-10, 0}}, color = {191, 0, 0}));
// Etat thermo pour Cp au retour
  state_retour = Medium.setState_pTX(p = port_a.p, T = senTretour.T, X = Medium.X_default);
  annotation(
    uses(Buildings(version = "12.1.0"), Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(graphics = {Text(origin = {-4, 104}, textColor = {0, 0, 255}, extent = {{-100, 20}, {100, -20}}, textString = "%name"), Rectangle(origin = {0, 29}, fillColor = {255, 0, 0}, fillPattern = FillPattern.VerticalCylinder, extent = {{62, -37}, {-62, 37}})}, coordinateSystem(extent = {{-100, 80}, {100, -20}})));
end BoilerOnDemand;
