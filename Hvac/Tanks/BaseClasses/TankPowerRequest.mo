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
Modelica.Blocks.Interfaces.BooleanOutput besoinON
  "True when tank requests heating"
  annotation(Placement(transformation(extent={{100,40},{140,80}})));
  
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
  Boolean on(start=false, fixed=true);
  Real Q_ch;
  Real Q_max;
equation
besoinON = on;

  // Hystérésis
  on = if T_top < (T_set - dT_hys) then true
       else if T_top > (T_set + dT_hys) then false
       else pre(on);

  // Puissance de recharge visée
  Q_ch = C_eff/tau_charge * max(0, T_set - T_top);

  // Limite hydraulique
  Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot);

  // Demande finale
  Q_req = if on then min(Q_losses + Q_ch, Q_max) else 0;

annotation(
    Documentation(info = "<html><head></head><body><p>
This block calculates the thermal power request <code>Q_req</code> that should be 
delivered by a heat pump to charge a fluid storage tank. The control is based on 
a hysteresis around a setpoint temperature at the top of the tank.
</p>

<h4>Inputs</h4>
<ul>
<li><b>T_top [K]</b>: top tank temperature</li>
<li><b>T_bot [K]</b>: bottom tank temperature</li>
<li><b>m_flow [kg/s]</b>: mass flow rate from the heat pump</li>
<li><b>T_HP_out_max [K]</b>: maximum outlet temperature of the heat pump</li>
<li><b>Q_losses [W]</b>: thermal losses of the tank</li>
</ul>

<h4>Output</h4>
<ul>
<li><b>Q_req [W]</b>: heating power requested from the heat pump</li>
</ul>

<h4>Parameters</h4>
<ul>
<li><b>T_set</b>: target top temperature (default 60°C)</li>
<li><b>dT_hys</b>: hysteresis band around the setpoint</li>
<li><b>VTan</b>: total tank volume</li>
<li><b>f_top</b>: fraction of the tank volume considered as 'useful top volume'</li>
<li><b>tau_charge</b>: desired charging time constant</li>
<li><b>p_nom</b>: nominal pressure for property evaluation</li>
</ul>

<h4>Control logic</h4>
<ul>
<li><b>On/off control with hysteresis</b>: the charging mode is activated when 
T_top falls below (T_set – dT_hys) and deactivated when T_top exceeds T_set.</li>

<li><b>Charging power target</b>: 
<pre>Q_ch = C_eff / tau_charge * max(0, T_set - T_top)</pre>
where C_eff is the effective thermal capacity of the top tank volume.</li>

<li><b>Hydraulic limitation</b>: 
<pre>Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot)</pre>
based on the available mass flow and the bottom temperature.</li>

<li><b>Final request</b>:
<pre>Q_req = if on then min(Q_losses + Q_ch, Q_max) else 0</pre></li>
</ul>

<p>
The block thus ensures that the heat pump request accounts for tank thermal inertia, 
losses, and hydraulic constraints, while avoiding short cycling via hysteresis.
</p>
</body></html>"),
    Icon(graphics = {Rectangle(origin = {-2, 0}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Cross, extent = {{-104, 100}, {104, -100}}), Text(origin = {-24, 127}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
    Diagram(graphics));
end TankPowerRequest;
