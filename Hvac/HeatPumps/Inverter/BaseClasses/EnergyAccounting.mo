within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;

model EnergyAccounting
  // Entrées
  Modelica.Blocks.Interfaces.RealInput P_utile
    annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput P_abs
    annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_chauffage
    annotation(Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_clim
    annotation(Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_ECS
    annotation(Placement(transformation(extent={{-120,-100},{-100,-80}})));

 // Intégrateurs pour SCOP
Modelica.Blocks.Continuous.Integrator E_utile(y_start=0)
  annotation(Placement(transformation(extent={{-40,60},{-20,80}})));
Modelica.Blocks.Continuous.Integrator E_abs(y_start=0)
  annotation(Placement(transformation(extent={{-40,20},{-20,40}})));



  // Sorties
  Modelica.Blocks.Interfaces.RealOutput Q_ch
    annotation(Placement(transformation(origin = {0, -20}, extent = {{100, 80}, {120, 100}}), iconTransformation(origin = {0, -18}, extent = {{100, 80}, {120, 100}})));
  Modelica.Blocks.Interfaces.RealOutput Q_clim
    annotation(Placement(transformation(origin = {0, -20}, extent = {{100, 40}, {120, 60}}), iconTransformation(origin = {0, -18}, extent = {{100, 40}, {120, 60}})));
  Modelica.Blocks.Interfaces.RealOutput Q_ECS
    annotation(Placement(transformation(origin = {0, -20}, extent = {{100, 0}, {120, 20}}), iconTransformation(origin = {0, -18}, extent = {{100, 0}, {120, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_tot
    annotation(Placement(transformation(origin = {0, -20}, extent = {{100, -40}, {120, -20}}), iconTransformation(origin = {0, -18}, extent = {{100, -40}, {120, -20}})));
  Modelica.Blocks.Interfaces.RealOutput SCOP
    annotation(Placement(transformation(origin = {0, -20}, extent = {{100, -80}, {120, -60}}), iconTransformation(origin = {0, -18}, extent = {{100, -80}, {120, -60}})));

protected 
  Real COP_inst;

equation
connect(P_utile, E_utile.u);
connect(P_abs, E_abs.u);

SCOP = if E_abs.y > 0 then E_utile.y / E_abs.y else 0;

  Q_ch   = if mode_chauffage then P_utile else 0;
  Q_clim = if mode_clim then P_utile else 0;
  Q_ECS  = if mode_ECS then P_utile else 0;
  Q_tot  = Q_ch + Q_clim + Q_ECS;

  COP_inst = if P_abs > 0 then P_utile / P_abs else 0;
//  SCOP = COP_inst;


annotation(
    Icon(coordinateSystem(extent = {{-120, 80}, {120, -100}}), graphics = {Rectangle(origin = {0, -11}, fillColor = {255, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 89}, {100, -89}}), Text(origin = {-14, 109}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
    Diagram(graphics));
end EnergyAccounting;
