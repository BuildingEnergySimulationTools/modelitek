within Modelitek.Hvac.Tanks.BaseClasses;

block TankPowerRequest_twomodes
  replaceable package Medium = Buildings.Media.Water
    "Medium model"
    annotation (choicesAllMatching=true);

  // === PARAMÈTRES GÉNÉRAUX ===
  parameter Real dT_hys = 5 "Bande hystérésis [K]";
  parameter Real VTan = 5 "Volume du ballon [m3]";
  parameter Real f_top = 0.30 "Fraction volume haut utile";
  parameter Real tau_charge = 1800 "Temps de remontée [s]";
  parameter Real p_nom = 3e5 "Pression nominale [Pa]";

  // === CALENDRIER SAISONNIER ===
  parameter Modelica.Units.SI.Time t_summer = 10.8864e6 "Date passage été [s]";
  parameter Modelica.Units.SI.Time t_winter = 25.4016e6 "Date passage hiver [s]";
  parameter Modelica.Units.SI.Time anticipation_summer = 3*24*3600
    "Anticipation avant été [s]";
  parameter Modelica.Units.SI.Time anticipation_winter = 3*24*3600
    "Anticipation avant hiver [s]";

  // === ENTRÉES ===
  Modelica.Blocks.Interfaces.BooleanInput Bool_summer
    "True = été (refroidissement)"
    annotation(Placement(transformation(extent={{-140,100},{-100,140}})));

  Modelica.Blocks.Interfaces.RealInput T_set_eff
    "Consigne actuelle du ballon [K]"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput T_top "Température haut ballon [K]"
    annotation(Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_bot "Température bas ballon [K]"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput m_flow "Débit PAC [kg/s]"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput T_HP_out_max "Température max sortie PAC [K]"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput Q_losses "Pertes thermiques [W]"
    annotation(Placement(transformation(extent={{-140,-140},{-100,-100}})));

  // === SORTIES ===
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
  Boolean inhibit_tank_charge;
  Boolean boost_tank_charge;
  Boolean besoin_effectif;
  Real Q_ch;
  Real Q_max;

algorithm 
  // --- Anticipation calendaire
  inhibit_tank_charge :=
      (time > (t_summer - anticipation_summer)) and (time < t_summer);

  boost_tank_charge :=
      (time > (t_winter - anticipation_winter)) and (time < t_winter);

  // --- Hystérésis classique selon la saison
  if Bool_summer then
    on := if T_top > (T_set_eff + dT_hys) then true
          else if T_top < (T_set_eff - 0.5*dT_hys) then false
          else pre(on);
  else
    on := if T_top < (T_set_eff - dT_hys) then true
          else if T_top > (T_set_eff + 0.5*dT_hys) then false
          else pre(on);
  end if;

  // --- Logique combinée
  besoin_effectif :=
    if inhibit_tank_charge then false
    else if boost_tank_charge then true
    else on;

equation
  besoinON = besoin_effectif;

  // --- Puissance de charge visée
  Q_ch = C_eff / tau_charge *
         max(0, if Bool_summer then (T_top - T_set_eff)
                              else (T_set_eff - T_top));
  Q_req_th = if besoin_effectif then (Q_losses + Q_ch) else 0;
  Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot);
  Q_req = if besoin_effectif then min(Q_req_th, Q_max) else 0;

  annotation(
    Icon(graphics = {
      Rectangle(origin = {-2, 0}, fillColor = {85, 255, 255},
        fillPattern = FillPattern.Cross, extent = {{-104, 100}, {104, -100}}),
      Text(origin = {-24, 127}, textColor = {0, 0, 255},
        extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
    Documentation(info="
<html>
<h3>TankPowerRequest (saisonnier + anticipation calendaire)</h3>
<p>Intègre la gestion de l’hystérésis selon la saison et une anticipation avant le passage été/hiver basée sur les dates du calendrier.</p>
<ul>
<li><b>Anticipation été :</b> empêche la recharge dans les jours précédant <code>t_summer</code>.</li>
<li><b>Anticipation hiver :</b> autorise une précharge dans les jours précédant <code>t_winter</code>.</li>
<li><b>Entrée Bool_summer :</b> indique la saison active (true = été).</li>
<li><b>besoinON :</b> combine hystérésis et anticipation calendaire.</li>
</ul>
</html>")
  );
end TankPowerRequest_twomodes;
