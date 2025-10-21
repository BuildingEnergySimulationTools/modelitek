within Modelitek.Hvac.Tanks.BaseClasses;

block TankPowerRequest

  replaceable package Medium = Buildings.Media.Water
    "Medium model"
    annotation (choicesAllMatching=true);
  // --- Paramètres
  parameter Real T_set = 333.15 "60°C, température cible [K]";
  parameter Real dT_hys = 5 "Bande hystérésis [K]";
  parameter Real VTan = 5 "Volume du ballon [m3]";
  parameter Real f_top = 0.30 "Fraction de volume haut utile";
  parameter Real tau_charge = 1800 "Temps de remontée visé [s]";
  parameter Real p_nom = 3e5 "Pression nominale pour calcul cp [Pa]";

  // --- Entrées
  Modelica.Blocks.Interfaces.RealInput T_top "Température haut ballon [K]"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput T_bot "Température bas ballon [K]"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput m_flow "Débit PAC [kg/s]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput T_HP_out_max "Température max sortie PAC [K]"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Q_losses "Pertes thermiques [W]"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  // --- Sortie
  Modelica.Blocks.Interfaces.RealOutput Q_req "Puissance demandée à la PAC [W]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected 
  Medium.ThermodynamicState sta = Medium.setState_pTX(p_nom, T_top, Medium.X_default);
  Real rho = Medium.density(sta);
  Real cp_top = Medium.specificHeatCapacityCp(sta);

  Medium.ThermodynamicState staBot = Medium.setState_pTX(p_nom, T_bot, Medium.X_default);
  Real cp_bot = Medium.specificHeatCapacityCp(staBot);

  Real C_eff = rho*cp_top*(VTan*f_top);
  Boolean on(start=true, fixed=true);
  Real Q_ch;
  Real Q_max;
public
equation
  // Hystérésis
  on = if T_top < (T_set - dT_hys) then true
       else if T_top > T_set then false
       else pre(on);

  // Puissance de recharge visée
  Q_ch = C_eff/tau_charge * max(0, T_set - T_top);

  // Limite hydraulique
  Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot);

  // Demande finale
  Q_req = if on then min(Q_losses + Q_ch, Q_max) else 0;

annotation(
    Icon(graphics = {Rectangle(origin = {-2, 0}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Cross, extent = {{-104, 100}, {104, -100}}), Text(origin = {-8, 15}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
    Diagram(graphics));
end TankPowerRequest;
