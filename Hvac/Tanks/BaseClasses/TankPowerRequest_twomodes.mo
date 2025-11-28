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

  // Température servante (été → haut, hiver → bas)
  Real T_ctrl "Température pivot pour pilotage du ballon";

  // Delta entre consigne et température pivot
  Real dT_ctrl "Écart à la consigne selon saison";

  // Puissance max possible
  Real Q_ch;
  Real Q_max;

algorithm 
  // ==========================================================
  //      Température servante (été = T_top, hiver = T_bot)
  // ==========================================================
  T_ctrl := if Bool_summer then T_top else T_bot;

  // ==========================================================
  //      Delta selon saison (ne sert plus à ON/OFF !)
  // ==========================================================
  dT_ctrl := if Bool_summer
                then (T_top - T_set_eff)
                else (T_set_eff - T_bot);

  // ==========================================================
  //      Anticipation calendaire
  // ==========================================================
  inhibit_tank_charge :=
      (time > (t_summer - anticipation_summer)) and (time < t_summer);

  boost_tank_charge :=
      (time > (t_winter - anticipation_winter)) and (time < t_winter);

  // ==========================================================
  //      HYSTERESIS robuste, (problème anti-chattering géré##)
  // ==========================================================

  if Bool_summer then
    // === Été : pilotage sur T_top ===
    if T_top > T_set_eff + dT_hys then
      on := true;
    elseif T_top < T_set_eff - dT_hys then
      on := false;
    else
      on := pre(on);
    end if;

  else
    // === Hiver : pilotage sur T_bottom ===
    if T_bot < T_set_eff - dT_hys then
      on := true;
    elseif T_bot > T_set_eff + dT_hys then
      on := false;
    else
      on := pre(on);
    end if;
  end if;

  // ==========================================================
  //      Logique combinée avec anticipations
  // ==========================================================
  besoin_effectif :=
    if inhibit_tank_charge then false
    elseif boost_tank_charge then true
    else on;

  // ==========================================================
  //      Sécurité hiver : si le bas est assez chaud → stop
  // ==========================================================
  if not Bool_summer then
    if T_bot >= T_set_eff + 0.2 then
        besoin_effectif := false;
    end if;
  end if;

equation
  besoinON = besoin_effectif;

  // ==========================================================
  //      Puissance de charge visée
  // ==========================================================
  Q_ch = if besoin_effectif then 
           C_eff / tau_charge * max(0, dT_ctrl)
         else 0;

  // ==========================================================
  //      Besoin thermique brut
  // ==========================================================
  Q_req_th = if besoin_effectif then (Q_losses + Q_ch) else 0;

  // ==========================================================
  //      Limitation par la PAC
  // ==========================================================
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
<h3>TankPowerRequest (corrigé été/hiver + anticipations + anti-chattering)</h3>
<p>
Pilotage cohérent du ballon :
<ul>
<li><b>Été :</b> régulation sur <code>T_top</code>.</li>
<li><b>Hiver :</b> régulation sur <code>T_bottom</code>.</li>
<li>Hystérésis complète (pas de chattering).</li>
<li>Anticipations saisonnières.</li>
<li>Coupure automatique si le bas est déjà chaud.</li>
<li>Limitation par la puissance PAC.</li>
</ul>
</p>
</html>")
  );
end TankPowerRequest_twomodes;
