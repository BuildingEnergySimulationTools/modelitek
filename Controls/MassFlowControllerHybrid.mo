within Modelitek.Controls;

model MassFlowControllerHybrid "Débit = Q/(cp*ΔT) + PID sur ΔT"
  import Modelica.Units.SI;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    "Fluide (par défaut eau)"
    annotation(choicesAllMatching = true);

// --- Entrées ---
  Modelica.Blocks.Interfaces.RealInput Q_demand(unit="W")
    "Puissance demandée (W)"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T_depart(unit="K")
    "Température départ (K)"
    annotation(Placement(transformation(extent={{-140,-10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput T_retour(unit="K")
    "Température retour (K)"
    annotation(Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput DeltaT_set(unit="K")
    "ΔT consigne (K)"
    annotation(Placement(transformation(extent={{-140,-90},{-100,-50}})));

// --- Sortie ---
  Modelica.Blocks.Interfaces.RealOutput m_flow_cmd(unit="kg/s")
    "Débit massique commandé (kg/s)"
    annotation(Placement(transformation(origin = {20, 20}, extent = {{100, -20}, {140, 20}}), iconTransformation(extent = {{100, -20}, {140, 20}})));

// --- Paramètres utiles ---
  parameter SI.MassFlowRate m_flow_max=3 "Limite sup. de la pompe (kg/s)";
  parameter Real kPID=1 "Gain PID (positif)";
  parameter SI.Time Ti=10 "Temps intégration (s)";
  parameter SI.Time Td=0 "Dérivation (s), 0 = PI";
  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialOutput;

// --- Calcul feedforward m = Q/(cp*ΔT) ---
  Modelitek.Sensors.MassFlowCalculator mcalc(redeclare package Medium = Medium)
    "Débit théorique"
    annotation(Placement(transformation(origin={-16,54}, extent={{-10,-10},{10,10}})));

// --- Mesure ΔT = Tdep - Tret ---
  Modelica.Blocks.Math.Add deltaMeas(k2=-1)
    annotation(Placement(transformation(origin={-20,-20}, extent={{-10,-10},{10,10}})));

// --- PID sur (ΔT_mes - ΔT_set) (k > 0) ---
  Modelica.Blocks.Continuous.LimPID pid(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=kPID, Ti=Ti, Td=Td,
    yMin=0, yMax=m_flow_max,
    initType=initType, xi_start=0, y_start=0)
    annotation(Placement(transformation(origin={30,-30}, extent={{-10,-10},{10,10}})));

// --- Somme FF + PID ---
  Modelica.Blocks.Math.Add addFF annotation(Placement(transformation(origin={60,20}, extent={{-10,-10},{10,10}})));

// --- Limiteur physique ---
  Modelica.Blocks.Nonlinear.Limiter lim(uMin=0, uMax=m_flow_max)
    annotation(Placement(transformation(origin={92,20}, extent={{-10,-10},{10,10}})));

equation
// Feedforward
  connect(Q_demand, mcalc.Q_demand) annotation(
    Line(points={{-120,60},{-28,60}}, color={0,0,127}));
  connect(DeltaT_set, mcalc.DeltaT) annotation(
    Line(points={{-120,-70},{-80,-70},{-80,48},{-28,48}}, color={0,0,127}));
// ΔT mesuré
  connect(T_depart, deltaMeas.u1) annotation(
    Line(points={{-120,10},{-60,10},{-60,-14},{-30,-14}}, color={0,0,127}));
  connect(T_retour, deltaMeas.u2) annotation(
    Line(points={{-120,-30},{-60,-30},{-60,-26},{-30,-26}}, color={0,0,127}));
// PID sur (ΔT_mes - ΔT_set) => signe naturel : si ΔT_mes > ΔT_set => pid↑ => m_flow↑ => ΔT baisse
// Somme FF + PID
  connect(mcalc.m_flow_calc, addFF.u1) annotation(
    Line(points = {{-4, 54}, {40, 54}, {40, 26}, {50, 26}}, color = {0, 0, 127}));
  connect(pid.y, addFF.u2) annotation(
    Line(points={{41,-30},{48,-30},{48,14},{50,14}}, color={0,0,127}));

// Limiteur et sortie
  connect(addFF.y, lim.u) annotation(
    Line(points={{70,20},{80,20}}, color={0,0,127}));
  connect(lim.y, m_flow_cmd) annotation(
    Line(points={{103,20},{140, 20}}, color={0,0,127}));
  connect(pid.u_m, DeltaT_set) annotation(
    Line(points = {{30, -42}, {28, -42}, {28, -70}, {-120, -70}}, color = {0, 0, 127}));
  connect(deltaMeas.y, pid.u_s) annotation(
    Line(points = {{-8, -20}, {2, -20}, {2, -30}, {18, -30}}, color = {0, 0, 127}));
  annotation(
  Documentation(info= "<html><head></head><body><p>
This controller computes a mass flow command <code>m_flow_cmd</code> by combining:
</p>

<ul>
<li><b>Feedforward term</b>: theoretical flow based on the demanded power 
(Q_demand) and the setpoint temperature difference ΔT_set:
<pre>m = Q_demand / (cp * ΔT_set)</pre></li>

<li><b>PID correction</b>: feedback loop acting on the error between the 
measured temperature difference (T_depart – T_retour) and the setpoint ΔT_set.</li>
</ul>

<p>
The two contributions are summed and then limited between 0 and 
<code>m_flow_max</code>, representing the physical pump capacity.
</p>

<h4>Inputs</h4>
<ul>
<li><b>Q_demand [W]</b>: requested heating/cooling power</li>
<li><b>T_depart [K]</b>: supply temperature</li>
<li><b>T_retour [K]</b>: return temperature</li>
<li><b>DeltaT_set [K]</b>: desired temperature difference</li>
</ul>

<h4>Output</h4>
<ul>
<li><b>m_flow_cmd [kg/s]</b>: commanded mass flow rate</li>
</ul>

<h4>Parameters</h4>
<ul>
<li><b>m_flow_max</b>: maximum allowed flow</li>
<li><b>kPID, Ti, Td</b>: PID gains</li>
<li><b>initType</b>: initialization method</li>
</ul>

<p>
The model ensures robust ΔT control by combining feedforward estimation 
with closed-loop PID adjustment.
</p>
</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, fillPattern=FillPattern.Solid, fillColor={200,220,255}),
      Text(extent={{-90,70},{90,40}}, textString="m = Q/(cpΔT) + PID"),
      Text(extent={{-90,-40},{90,-70}}, textString="suivi ΔT (dep-ret)")
    }),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,100},{140,-100}}))
  );
end MassFlowControllerHybrid;
