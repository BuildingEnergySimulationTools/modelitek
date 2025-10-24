within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;

model TemperatureLimits
  parameter Boolean Lim_Theta = true "Activer limites";
  parameter Real Theta_min_am = -10 "Min amont (°C)";
  parameter Real Theta_max_am =  40 "Max amont (°C)";
  parameter Real Theta_min_av =   5 "Min aval  (°C)";
  parameter Real Theta_max_av =  65 "Max aval  (°C)";

  Modelica.Blocks.Interfaces.RealInput  T_am  "°C"
    annotation(Placement(transformation(extent = {{-120, 40}, {-100, 60}}), iconTransformation(origin = {0, 12}, extent = {{-120, 40}, {-100, 60}})));
  Modelica.Blocks.Interfaces.RealInput  T_av  "°C"
    annotation(Placement(transformation(extent = {{-120, 0}, {-100, 20}}), iconTransformation(origin = {0, 12}, extent = {{-120, 0}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealInput  P_in  "W"
    annotation(Placement(transformation(extent = {{-120, -40}, {-100, -20}}), iconTransformation(origin = {0, 12}, extent = {{-120, -40}, {-100, -20}})));

  Modelica.Blocks.Interfaces.RealOutput P_out "W limité"
    annotation(Placement(transformation(origin = {-140, -20}, extent = {{100, 0}, {120, 20}}), iconTransformation(origin = {-98, -14}, extent = {{100, 0}, {120, 20}})));
  Modelica.Blocks.Interfaces.BooleanOutput actif
    "true si PAC autorisée (dans les limites)"
    annotation(Placement(transformation(origin = {-140, -20}, extent = {{100, 40}, {120, 60}}), iconTransformation(origin = {-98, -14}, extent = {{100, 40}, {120, 60}})));

protected
  // Constantes pour les seuils
  Modelica.Blocks.Sources.Constant c_min_am(k=Theta_min_am);
  Modelica.Blocks.Sources.Constant c_max_am(k=Theta_max_am);
  Modelica.Blocks.Sources.Constant c_min_av(k=Theta_min_av);
  Modelica.Blocks.Sources.Constant c_max_av(k=Theta_max_av);

  // Comparateurs
  Modelica.Blocks.Logical.GreaterEqual am_ge_min;
  Modelica.Blocks.Logical.LessEqual    am_le_max;
  Modelica.Blocks.Logical.GreaterEqual av_ge_min;
  Modelica.Blocks.Logical.LessEqual    av_le_max;

  // Combinaison logique
  Modelica.Blocks.Logical.And and1, and2, ok;

  // Switch de puissance
  Modelica.Blocks.Logical.Switch sw;
  Modelica.Blocks.Sources.Constant zero(k=0);

equation
  // Comparateurs amont
  connect(T_am, am_ge_min.u1);
  connect(c_min_am.y, am_ge_min.u2);

  connect(T_am, am_le_max.u1);
  connect(c_max_am.y, am_le_max.u2);

  // Comparateurs aval
  connect(T_av, av_ge_min.u1);
  connect(c_min_av.y, av_ge_min.u2);

  connect(T_av, av_le_max.u1);
  connect(c_max_av.y, av_le_max.u2);

  // Combinaisons logiques
  connect(am_ge_min.y, and1.u1);
  connect(am_le_max.y, and1.u2);

  connect(av_ge_min.y, and2.u1);
  connect(av_le_max.y, and2.u2);

  connect(and1.y, ok.u1);
  connect(and2.y, ok.u2);

  // Activation
  actif = if Lim_Theta then ok.y else true;

  // Limitation de puissance
  connect(actif, sw.u2);
  connect(P_in,  sw.u1);
  connect(zero.y, sw.u3);
  connect(sw.y, P_out);

  annotation(
    Diagram(coordinateSystem(extent = {{-120, 60}, {-20, -40}})),
    Icon(graphics = {Rectangle(origin = {-50, 27}, fillColor = {255, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-50, 53}, {50, -53}}), Text(origin = {-48, 100}, textColor = {0, 0, 255}, extent = {{-100, 24}, {100, -24}}, textString = "%name")}, coordinateSystem(extent = {{-120, 80}, {20, -40}})));
end TemperatureLimits;
