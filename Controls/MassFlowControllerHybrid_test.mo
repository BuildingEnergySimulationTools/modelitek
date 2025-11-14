within Modelitek.Controls;

model MassFlowControllerHybrid_test "Débit = Q/(cp*ΔT) + PID sur ΔT"
  import Modelica.Units.SI;
  replaceable package Medium = Modelica.Media.Water.StandardWater "Fluide (par défaut eau)"
    annotation(choicesAllMatching = true);

  // --- Entrées ---
  Modelica.Blocks.Interfaces.BooleanInput isSummer "true if cooling mode"
    annotation(Placement(transformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealInput Q_demand(unit="W") "Puissance demandée (W)"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput T_depart(unit="K") "Température départ (K)"
    annotation(Placement(transformation(extent={{-140,-10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput T_retour(unit="K") "Température retour (K)"
    annotation(Placement(transformation(extent={{-140,-50},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput DeltaT_set(unit="K") "ΔT consigne (K)"
    annotation(Placement(transformation(extent={{-140,-90},{-100,-50}})));

  // --- Sortie ---
  Modelica.Blocks.Interfaces.RealOutput m_flow_cmd(unit="kg/s") "Débit massique commandé (kg/s)"
    annotation(Placement(transformation(extent={{100,0},{140,40}})));

  // --- Paramètres utiles ---
  parameter SI.MassFlowRate m_flow_max=3 "Limite sup. de la pompe (kg/s)";
  parameter Real kPID=1 "Gain PID (positif)";
  parameter SI.Time Ti=10 "Temps intégration (s)";
  parameter SI.Time Td=0 "Dérivation (s), 0 = PI";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialOutput;

  // --- Calcul feedforward m = Q/(cp*ΔT) ---
  Sensors.MassFlowCalculator mcalc(redeclare package Medium = Medium)
    "Débit théorique"
    annotation(Placement(transformation(origin={-16,54}, extent={{-10,-10},{10,10}})));

  // --- Mesure ΔT = Tdep - Tret ---
  Modelica.Blocks.Math.Add deltaMeas(k2=-1)
    annotation(Placement(transformation(origin={-20,-20}, extent={{-10,-10},{10,10}})));

  // --- PID sur (ΔT_mes - ΔT_set) ---
  Modelica.Blocks.Continuous.LimPID pid(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=kPID, Ti=Ti, Td=Td,
    yMin=0, yMax=m_flow_max,
    initType=initType, xi_start=0, y_start=0)
    annotation(Placement(transformation(origin={30,-30}, extent={{-10,-10},{10,10}})));

  // --- Gain de signe saisonnier ---
  Modelica.Blocks.Math.BooleanToReal signConv(realTrue=-1, realFalse=1)
    annotation(Placement(transformation(origin={54,-30}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Product pidSigned
    annotation(Placement(transformation(origin={70,-10}, extent={{-10,-10},{10,10}})));

  // --- Somme FF + PID ---
  Modelica.Blocks.Math.Add addFF
    annotation(Placement(transformation(origin={90,20}, extent={{-10,-10},{10,10}})));

  // --- Limiteur physique ---
  Modelica.Blocks.Nonlinear.Limiter lim(uMin=0, uMax=m_flow_max)
    annotation(Placement(transformation(origin={120,20}, extent={{-10,-10},{10,10}})));

equation
  // Feedforward
  connect(Q_demand, mcalc.Q_demand);
  connect(DeltaT_set, mcalc.DeltaT);

  // ΔT mesuré
  connect(T_depart, deltaMeas.u1);
  connect(T_retour, deltaMeas.u2);

  // PID sur ΔT_mes - ΔT_set
  connect(deltaMeas.y, pid.u_s);
  connect(DeltaT_set, pid.u_m);

  // Signe saisonnier
  connect(isSummer, signConv.u);
  connect(pid.y, pidSigned.u1);
  connect(signConv.y, pidSigned.u2);

  // Somme FF + PID_signed
  connect(mcalc.m_flow_calc, addFF.u1);
  connect(pidSigned.y, addFF.u2);

  // Limiteur et sortie
  connect(addFF.y, lim.u);
  connect(lim.y, m_flow_cmd);

  annotation(
    Documentation(info="
    <html>
    <p>
    Hybrid mass flow controller combining:
    <ul>
      <li>Feedforward: m = Q / (cp * ΔT_set)</li>
      <li>PID correction on ΔT_mes - ΔT_set</li>
    </ul>
    Automatically reverses PID sign in cooling mode (isSummer = true).
    </p>
    </html>
    "),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-100,100},{100,-100}}, fillPattern=FillPattern.Solid, fillColor={200,220,255}),
        Text(extent={{-90,70},{90,40}}, textString="m = Q/(cpΔT) + PID"),
        Text(extent={{-90,-40},{90,-70}}, textString="auto sign PID")
      }),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,100},{140,-100}}))
  );
end MassFlowControllerHybrid_test;
