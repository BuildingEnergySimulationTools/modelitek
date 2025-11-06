within Modelitek.Hvac.Tanks.BaseClasses;

block TankPowerRequest_twomodes

  replaceable package Medium = Buildings.Media.Water
    "Medium model"
    annotation (choicesAllMatching=true);

  // --- Paramètres
  parameter Real dT_hys = 5 "Bande hystérésis [K]";
  parameter Real VTan = 5 "Volume du ballon [m3]";
  parameter Real f_top = 0.30 "Fraction volume haut utile";
  parameter Real tau_charge = 1800 "Temps de remontée [s]";
  parameter Real p_nom = 3e5 "Pression nominale [Pa]";

  // --- Entrées
  Modelica.Blocks.Interfaces.BooleanInput Bool_summer
    "True = été (refroidissement)"
    annotation(Placement(transformation(extent={{-140,100},{-100,140}})));

  Modelica.Blocks.Interfaces.RealInput T_set_eff
    "Consigne actuelle du ballon [K]"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput T_top "Température haut ballon [K]"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_bot "Température bas ballon [K]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput m_flow "Débit PAC [kg/s]"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput T_HP_out_max "Température max sortie PAC [K]"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput Q_losses "Pertes thermiques [W]"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}})));

  // --- Sorties
  Modelica.Blocks.Interfaces.BooleanOutput besoinON
    "True si le ballon demande recharge"
    annotation(Placement(transformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q_req_th
    "Besoin thermique brut [W]"
    annotation(Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q_req
    "Puissance demandée à la PAC [W]"
    annotation(Placement(transformation(extent={{100,-20},{140,20}})));

protected 
  Medium.ThermodynamicState sta = Medium.setState_pTX(p_nom, T_top, Medium.X_default);
  Real rho = Medium.density(sta);
  Real cp_top = Medium.specificHeatCapacityCp(sta);

  Medium.ThermodynamicState staBot = Medium.setState_pTX(p_nom, T_bot, Medium.X_default);
  Real cp_bot = Medium.specificHeatCapacityCp(staBot);

  Real C_eff = rho * cp_top * (VTan * f_top);
  Boolean on(start=false, fixed=true);
  Real Q_ch;
  Real Q_max;

equation
  // --- Hystérésis selon la saison et la consigne effective
  if Bool_summer then
    // Été : recharge si le haut du ballon est TROP CHAUD
    on = if T_top > (T_set_eff + dT_hys) then true
         else if T_top < (T_set_eff - 0.5*dT_hys) then false
         else pre(on);
  else
    // Hiver : recharge si le haut du ballon est TROP FROID
    on = if T_top < (T_set_eff - dT_hys) then true
         else if T_top > (T_set_eff + 0.5*dT_hys) then false
         else pre(on);
  end if;


  besoinON = on;

  // --- Puissance de charge visée
  Q_ch = C_eff / tau_charge * max(0, if Bool_summer then (T_top - T_set_eff) else (T_set_eff - T_top));
  Q_req_th = if on then (Q_losses + Q_ch) else 0;
  Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot);
  Q_req = if on then min(Q_req_th, Q_max) else 0;

  annotation(
    Icon(graphics = {Rectangle(origin = {-2, 0}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Cross, extent = {{-104, 100}, {104, -100}}), Text(origin = {-24, 127}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}, coordinateSystem(extent = {{-160, 160}, {140, -140}})),
    Documentation(info="<html><h3>TankPowerRequest (saisonnier)</h3>
    <p>Version améliorée avec prise en compte de la saison <b>et</b> de la consigne effective.</p>
    <ul>
      <li><b>Entrée Bool_summer :</b> vrai = mode été (refroidissement)</li>
      <li><b>Entrée T_set_eff :</b> consigne dynamique issue du contrôleur de saison</li>
    </ul>
    <p>L'hystérésis et le calcul de puissance s’adaptent à la saison :</p>
    <ul>
      <li><b>Hiver :</b> recharge si T_top < T_set_eff - dT_hys</li>
      <li><b>Été :</b> recharge si T_top > T_set_eff + dT_hys</li>
    </ul></html>")
  ,
  Diagram(coordinateSystem(extent = {{-140, 140}, {140, -140}})));
end TankPowerRequest_twomodes;
