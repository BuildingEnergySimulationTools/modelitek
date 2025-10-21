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
    annotation(Placement(transformation(origin={-20,60}, extent={{-10,-10},{10,10}})));

  // --- Mesure ΔT = Tdep - Tret ---
  Modelica.Blocks.Math.Add deltaMeas(k2=-1)
    annotation(Placement(transformation(origin={-20,-20}, extent={{-10,-10},{10,10}})));

  // --- PID sur (ΔT_mes - ΔT_set) (k > 0) ---
  Modelica.Blocks.Continuous.LimPID pid(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=kPID, Ti=Ti, Td=Td,
    yMin=0, yMax=m_flow_max,
    initType=initType, xi_start=0, y_start=0)
    annotation(Placement(transformation(origin={30,-20}, extent={{-10,-10},{10,10}})));

  // --- Somme FF + PID ---
  Modelica.Blocks.Math.Add addFF
    annotation(Placement(transformation(origin={60,20}, extent={{-10,-10},{10,10}})));

  // --- Limiteur physique ---
  Modelica.Blocks.Nonlinear.Limiter lim(uMin=0, uMax=m_flow_max)
    annotation(Placement(transformation(origin={88,20}, extent={{-10,-10},{10,10}})));

equation
  // Feedforward
  connect(Q_demand, mcalc.Q_demand) annotation(
    Line(points={{-120,60},{-30,60}}, color={0,0,127}));
  connect(DeltaT_set, mcalc.DeltaT) annotation(
    Line(points={{-120,-70},{-80,-70},{-80,40},{-20,40},{-20,50}}, color={0,0,127}));

  // ΔT mesuré
  connect(T_depart, deltaMeas.u1) annotation(
    Line(points={{-120,10},{-60,10},{-60,-14},{-30,-14}}, color={0,0,127}));
  connect(T_retour, deltaMeas.u2) annotation(
    Line(points={{-120,-30},{-60,-30},{-60,-26},{-30,-26}}, color={0,0,127}));

  // PID sur (ΔT_mes - ΔT_set) => signe naturel : si ΔT_mes > ΔT_set => pid↑ => m_flow↑ => ΔT baisse
  connect(deltaMeas.y, pid.u_m) annotation(
    Line(points={{-10,-20},{20,-20}}, color={0,0,127}));
  connect(DeltaT_set, pid.u_s) annotation(
    Line(points={{-120,-70},{0,-70},{0,-32},{20,-32}}, color={0,0,127}));

  // Somme FF + PID
  connect(mcalc.m_flow_calc, addFF.u1) annotation(
    Line(points={{-10,60},{40,60},{40,26},{50,26}}, color={0,0,127}));
  connect(pid.y, addFF.u2) annotation(
    Line(points={{40,-20},{48,-20},{48,14},{50,14}}, color={0,0,127}));

  // Limiteur et sortie
  connect(addFF.y, lim.u) annotation(
    Line(points={{70,20},{78,20}}, color={0,0,127}));
  connect(lim.y, m_flow_cmd) annotation(
    Line(points={{98,20},{140, 20}}, color={0,0,127}));

  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, fillPattern=FillPattern.Solid, fillColor={200,220,255}),
      Text(extent={{-90,70},{90,40}}, textString="m = Q/(cpΔT) + PID"),
      Text(extent={{-90,-40},{90,-70}}, textString="suivi ΔT (dep-ret)")
    }),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,100},{140,-100}}))
  );
end MassFlowControllerHybrid;
