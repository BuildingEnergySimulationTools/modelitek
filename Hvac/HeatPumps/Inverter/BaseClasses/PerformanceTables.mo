within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;

model PerformanceTables
  // Paramètres RE2020
  parameter Boolean Charger_fichier_nappe = false;
  parameter String chemin_fichier_COP="";
  parameter String chemin_fichier_Pabs="";
  parameter String chemin_fichier_EER="";
  parameter Real COP_pivot = 3.0;
  parameter Real Pabs_pivot = 1000;
  parameter Real EER_pivot = 2.5;
  parameter Integer Statut_valeurs_Cop = 1;
  parameter Integer Statut_valeurs_Pabs = 1;
  parameter Integer Statut_valeurs_EER = 1;

  // Entrées
  Modelica.Blocks.Interfaces.RealInput T_am "Température amont (source)"
    annotation(Placement(transformation(extent = {{-120, 40}, {-100, 60}}), iconTransformation(origin = {2, -34}, extent = {{-120, 40}, {-100, 60}})));
  Modelica.Blocks.Interfaces.RealInput T_av "Température aval (consigne)"
    annotation(Placement(transformation(extent = {{-120, -20}, {-100, 0}}), iconTransformation(origin = {2, -34}, extent = {{-120, -20}, {-100, 0}})));

  // Sorties
  Modelica.Blocks.Interfaces.RealOutput COP "COP calculé"
    annotation(Placement(transformation(origin = {-138, 12}, extent = {{100, 40}, {120, 60}}), iconTransformation(origin = {2, -34}, extent = {{100, 40}, {120, 60}})));
  Modelica.Blocks.Interfaces.RealOutput EER "EER calculé"
    annotation(Placement(transformation(origin = {-138, 12}, extent = {{100, 0}, {120, 20}}), iconTransformation(origin = {2, -34}, extent = {{100, 0}, {120, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Pabs "Puissance absorbée"
    annotation(Placement(transformation(origin = {-138, 12}, extent = {{100, -40}, {120, -20}}), iconTransformation(origin = {2, -34}, extent = {{100, -40}, {120, -20}})));

protected 
  Real facteurCop;
  Real facteurPabs;

equation
  // Facteurs qualité valeurs
  facteurCop  = if Statut_valeurs_Cop == 1 then 1 else if Statut_valeurs_Cop == 2 then 0.9 else 0.8;
  facteurPabs = if Statut_valeurs_Pabs == 1 then 1 else if Statut_valeurs_Pabs == 2 then 1.05 else 1.1;

  // Mode simplifié → valeurs pivot (sinon remplacer par CombiTable2Ds)
  COP  = COP_pivot * facteurCop;
  EER  = EER_pivot;
  Pabs = Pabs_pivot * facteurPabs;


annotation(
    Diagram(coordinateSystem(extent = {{-120, 80}, {-20, -40}}), graphics),
Icon(graphics = {Rectangle(origin = {0, -20}, fillColor = {170, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-104, 74}, {104, -74}}), Text(origin = {-10, 81}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}, coordinateSystem(extent = {{-140, 120}, {120, -100}})));
end PerformanceTables;
