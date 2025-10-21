within Modelitek.Hvac.Boilers;

model BoilerReal
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium 
    "Medium du fluide" annotation(choicesAllMatching=true);

  parameter Real efficiency = 0.9 "Boiler efficiency (0..1)";
  parameter Modelica.Units.SI.Volume V = 0.01 "Volume interne du boiler";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.2;

  // Ports fluide
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) 
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) 
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));

  // Entrée / sortie
  Modelica.Blocks.Interfaces.RealInput T_consigne(unit="K") 
    "Consigne température en sortie" 
    annotation(Placement(transformation(origin={0,-80}, extent={{-20,-20},{20,20}}),
                        iconTransformation(origin={0,-58}, extent={{-20,-20},{20,20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_boil(unit="W") 
    "Puissance thermique fournie (utile)" 
    annotation(Placement(transformation(origin={0,80}, extent={{-20,-20},{20,20}}),
                        iconTransformation(origin={4,58}, extent={{-20,-20},{20,20}})));

  // Volume interne
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V = V,
    nPorts=2,
    m_flow_nominal = m_flow_nominal) 
    annotation(Placement(transformation(origin={0,0}, extent={{-10,-10},{10,10}})));

  // Capteurs
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium) 
    annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sensors.Temperature senTretour(
    redeclare package Medium = Medium, 
    warnAboutOnePortConnection=false) 
    annotation(Placement(transformation(origin={-76,38}, extent={{-10,-10},{10,10}})));

  // Source de chaleur
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Qflow 
    annotation(Placement(transformation(origin={0,-40}, extent={{-10,-10},{10,10}})));

protected 
  Medium.ThermodynamicState state_retour;

equation 
  // Etat thermo au retour pour calculer Cp
  state_retour = Medium.setState_pTX(p=port_a.p, T=senTretour.T, X=Medium.X_default);

  // Calcul de la puissance utile
  Q_boil = efficiency * max(0, senMasFlo.m_flow) 
           * Medium.specificHeatCapacityCp(state_retour) 
           * (T_consigne - senTretour.T);

  // Connexions fluide
  connect(port_a, senMasFlo.port_a);
  connect(senMasFlo.port_b, vol.ports[1]);
  connect(port_b, vol.ports[2]);
  connect(port_a, senTretour.port);

  // Injection de chaleur
  connect(Qflow.port, vol.heatPort);
  connect(Qflow.Q_flow, Q_boil);

  annotation(
    uses(Buildings(version="12.1.0"), Modelica(version="4.0.0")),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(graphics={
      Rectangle(origin={5,3}, fillColor={255,0,0}, fillPattern=FillPattern.VerticalCylinder,
                extent={{95,-61},{-95,61}}),
      Text(origin={-4,104}, textColor={0,0,255}, extent={{-100,20},{100,-20}}, textString="%name")}));
end BoilerReal;
