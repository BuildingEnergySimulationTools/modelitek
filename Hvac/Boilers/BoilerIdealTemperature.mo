within Modelitek.Hvac.Boilers;

model BoilerIdealTemperature
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation(
    choicesAllMatching = true);
  parameter Real efficiency = 0.9 "Boiler efficiency (0..1)";

  // === Ports ===
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));

  // === Entrées / Sorties ===
  Modelica.Blocks.Interfaces.RealInput T_consigne(unit="K")
    "Consigne température sortie"
    annotation(Placement(transformation(origin={0,-80},extent={{-20,-20},{20,20}}),
                         iconTransformation(origin={0,-58},extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_boil(unit="W")
    "Puissance utile [W]"
    annotation(Placement(transformation(origin={0,80},extent={{-20,-20},{20,20}}),
                         iconTransformation(origin={-18,58},extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_abs(unit="W")
    "Puissance absorbée [W]"
    annotation(Placement(transformation(origin={67,-40},extent={{-20,-20},{20,20}}),
                         iconTransformation(origin={39,-55},extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Interfaces.RealOutput E_boil(unit="kWh")
    "Énergie utile cumulée [kWh]"
    annotation(Placement(transformation(origin={-70,80},extent={{-20,-20},{20,20}}),
                         iconTransformation(origin={-60,58},extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Interfaces.RealOutput E_abs(unit="kWh")
    "Énergie absorbée cumulée (toujours croissante) [kWh]"
    annotation(Placement(transformation(origin={70,0},extent={{-20,-20},{20,20}}),
                         iconTransformation(origin={60,0},extent={{-20,-20},{20,20}})));

  // === Sous-blocs ===
  Buildings.Fluid.Sources.Boundary_pT boilerBoundary(
    redeclare package Medium = Medium, use_T_in = false, nPorts = 1);
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium);
  Buildings.Fluid.Sensors.Temperature senTretour(
    redeclare package Medium = Medium, warnAboutOnePortConnection=false);
  Buildings.Fluid.Sources.Boundary_pT boilerBoundary1(
    redeclare package Medium = Medium, nPorts = 1, use_T_in = true);
  Modelica.Blocks.Math.Abs absP "Valeur absolue de la puissance absorbée";
  Modelica.Blocks.Continuous.Integrator integ_Q_boil(k=1/3.6e6)
    "Énergie utile [kWh]";
  Modelica.Blocks.Continuous.Integrator integ_P_abs(k=1/3.6e6)
    "Énergie absorbée cumulée [kWh]";

protected
  Medium.ThermodynamicState state_retour;
  Real Cp "Chaleur massique [J/kg/K]";

equation
  // === Calculs thermiques ===
  state_retour = Medium.setState_pTX(p=port_a.p, T=senTretour.T, X=Medium.X_default);
  Cp = Medium.specificHeatCapacityCp(state_retour);

  // === Puissances ===
  Q_boil = max(0, senMasFlo.m_flow) * Cp * (T_consigne - senTretour.T) * efficiency;
  P_abs  = Q_boil / efficiency;

  // === Énergies cumulées (W·s → kWh) ===
  integ_Q_boil.u = Q_boil;
  integ_P_abs.u  = absP.y;

  connect(P_abs, absP.u);
  E_boil = integ_Q_boil.y;
  E_abs  = integ_P_abs.y;

  // === Connexions hydrauliques ===
  connect(port_a, senTretour.port);
  connect(port_a, senMasFlo.port_a);
  connect(senMasFlo.port_b, boilerBoundary.ports[1]);
  connect(T_consigne, boilerBoundary1.T_in);
  connect(boilerBoundary1.ports[1], port_b);

  annotation(
    uses(Buildings(version="12.1.0"), Modelica(version="4.0.0")),
    Icon(graphics={
      Rectangle(origin={5,3},fillColor={255,0,0},fillPattern=FillPattern.VerticalCylinder,
                extent={{95,-61},{-95,61}}),
      Text(origin={-4,104},textColor={0,0,255},
           extent={{-100,20},{100,-20}},textString="%name")}),
    Documentation(info="
      <html>
      <b>BoilerIdealTemperature</b><br>
      Chaudière idéale avec calcul des énergies cumulées et correction de signe.<br><br>

      <b>Sorties :</b><br>
      - Q_boil [W] : puissance utile<br>
      - P_abs [W] : puissance absorbée instantanée (signée)<br>
      - E_boil [kWh] : énergie utile cumulée<br>
      - E_abs [kWh] : énergie absorbée cumulée, toujours croissante<br><br>

      <b>Détails :</b><br>
      - Les intégrateurs convertissent W·s → kWh (1/3.6e6)<br>
      - E_abs utilise |P_abs| pour éviter les décroissances en cas de signe négatif<br>
      </html>")
  );
end BoilerIdealTemperature;
