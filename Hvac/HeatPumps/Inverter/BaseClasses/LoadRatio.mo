within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;


model LoadRatio
  parameter Boolean Inverter = true;
  parameter Real LR_contmin = 0.2;
  parameter Real CCP_LRcontmin = 0.9;
  parameter Real Taux = 0.05;

  // Entrées
  Modelica.Blocks.Interfaces.RealInput P_demande
    annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput COP_nom
    annotation(Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput Pabs_nom
    annotation(Placement(transformation(extent={{-120,-20},{-100,0}})));

  // Sorties
  Modelica.Blocks.Interfaces.RealOutput P_utile
    annotation(Placement(transformation(origin = {-114, 0}, extent = {{100, 60}, {120, 80}}), iconTransformation(origin = {-100, 0}, extent = {{100, 60}, {120, 80}})));
  Modelica.Blocks.Interfaces.RealOutput P_abs
    annotation(Placement(transformation(origin = {-114, 0}, extent = {{100, 20}, {120, 40}}), iconTransformation(origin = {-100, 0}, extent = {{100, 20}, {120, 40}})));
  Modelica.Blocks.Interfaces.RealOutput LR
    annotation(Placement(transformation(origin = {-114, 0}, extent = {{100, -20}, {120, 0}}), iconTransformation(origin = {-100, 0}, extent = {{100, -20}, {120, 0}})));

protected 
  Real COP_corr;

equation
  // Ratio de charge protégé contre la division par zéro
  LR = if noEvent(COP_nom * Pabs_nom > 1e-6) then 
         P_demande / (COP_nom * Pabs_nom) 
       else 0;

  if Inverter then
    // Correction du COP avec limitation LR
    COP_corr = COP_nom * (CCP_LRcontmin + (1 - CCP_LRcontmin)*
               (max(LR, LR_contmin) - LR_contmin)/(1 - LR_contmin));
  else
    // Tout ou rien
    COP_corr = COP_nom;
  end if;

  // Puissance utile et absorbée corrigées
  P_utile = COP_corr * Pabs_nom * LR;
  P_abs   = Pabs_nom * LR + Taux * Pabs_nom*(1 - LR);

annotation(
    Diagram(coordinateSystem(extent = {{-120, 80}, {0, -20}}), graphics),
    Icon(coordinateSystem(extent = {{-120, 80}, {20, -20}}), graphics = {Rectangle(origin = {-54, 30}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Solid, extent = {{58, -46}, {-58, 46}}), Text(origin = {-53, 108}, textColor = {0, 0, 255}, extent = {{-107, 26}, {107, -26}}, textString = "%name")}));
end LoadRatio;
