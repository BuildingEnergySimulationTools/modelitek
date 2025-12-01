within Modelitek.Hvac.HeatPumps.Inverter;


model PAC_inverter
  // ===== Paramètres généraux =====
  parameter Boolean Inverter = true "true = modulation, false = TOR";
  parameter Integer loi_multi_zone = 1 "loi calcul taux de charge";
  // ===== Paramètres des nappes =====
  parameter Boolean Charger_fichier_nappe = false
    "true = lecture fichier nappe, false = valeurs par défaut";
  parameter String chemin_fichier_COP="";
  parameter String chemin_fichier_Pabs="";
  parameter String chemin_fichier_EER="";

// ===== Pivots =====
  parameter Real COP_pivot = 3.0 "COP au point pivot (7°C / 32.5°C)";
  parameter Real Pabs_pivot = 3830 "Puissance absorbée au point pivot [W]";
  parameter Real EER_pivot = 2.8 "EER au point pivot";

// ===== Statuts =====
  parameter Integer Statut_valeurs_Cop = 3 "1: Certifiées, 2: Justifiées, 3: Défaut";
  parameter Integer Statut_valeurs_Pabs = 3 "1: Certifiées, 2: Justifiées, 3: Défaut";
  parameter Integer Statut_valeurs_EER = 3 "1: Certifiées, 2: Justifiées, 3: Défaut";

// ===== Loi Inverter =====
  parameter Real LR_contmin = 0.2 "Taux de charge minimal";
  parameter Real CCP_LRcontmin = 0.9 "Ratio COP/EER au LR min";
  parameter Real Taux = 0.05 "Ratio auxiliaires à charge nulle";

// ===== Limites de fonctionnement =====
  parameter Boolean Lim_Theta = true "Activation limites température";
  parameter Real Theta_min_am = -10 "Température amont minimale (°C)";
  parameter Real Theta_max_am =  40 "Température amont maximale (°C)";
  parameter Real Theta_min_av =   5 "Température aval minimale (°C)";
  parameter Real Theta_max_av =  65 "Température aval maximale (°C)";
  // ===== Entrées =====
  Modelica.Blocks.Interfaces.RealInput T_am "Température source (°C)"
    annotation(Placement(transformation(extent = {{-120, 100}, {-100, 120}}), iconTransformation(origin = {-22, -40}, extent = {{-120, 100}, {-100, 120}})));
  Modelica.Blocks.Interfaces.RealInput T_aval "Température départ (°C)"
    annotation(Placement(transformation(extent = {{-120, 60}, {-100, 80}}), iconTransformation(origin = {-22, -24}, extent = {{-120, 60}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput P_demande "Puissance demandée (W)"
    annotation(Placement(transformation(extent = {{-120, 20}, {-100, 40}}), iconTransformation(origin = {-22, -6}, extent = {{-120, 20}, {-100, 40}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_chauffage
    annotation(Placement(transformation(extent = {{-120, -20}, {-100, 0}}), iconTransformation(origin = {-22, -4}, extent = {{-120, -20}, {-100, 0}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_clim
    annotation(Placement(transformation(extent = {{-120, -60}, {-100, -40}}), iconTransformation(origin = {-22, 12}, extent = {{-120, -60}, {-100, -40}})));
  Modelica.Blocks.Interfaces.BooleanInput mode_ECS
    annotation(Placement(transformation(extent = {{-120, -100}, {-100, -80}}), iconTransformation(origin = {-22, 28}, extent = {{-120, -100}, {-100, -80}})));

// ===== Sorties =====
  Modelica.Blocks.Interfaces.RealOutput P_utile
    annotation(Placement(transformation(origin = {-22, -62}, extent = {{100, 100}, {120, 120}}), iconTransformation(origin = {14, -50}, extent = {{100, 100}, {120, 120}})));
  Modelica.Blocks.Interfaces.RealOutput P_abs
    annotation(Placement(transformation(origin = {-22, -62}, extent = {{100, 60}, {120, 80}}), iconTransformation(origin = {14, -50}, extent = {{100, 60}, {120, 80}})));
  Modelica.Blocks.Interfaces.RealOutput COP
    annotation(Placement(transformation(origin = {-22, -62}, extent = {{100, 20}, {120, 40}}), iconTransformation(origin = {14, -50}, extent = {{100, 20}, {120, 40}})));
  Modelica.Blocks.Interfaces.RealOutput SCOP
    annotation(Placement(transformation(origin = {-22, -62}, extent = {{100, -20}, {120, 0}}), iconTransformation(origin = {14, -50}, extent = {{100, -20}, {120, 0}})));

// ===== Sous-modèles remplissage =====
  BaseClasses.Remplissage_COP rempCOP(
    COP_pivot=COP_pivot,
    Statut_valeurs_Cop=Statut_valeurs_Cop,
    Charger_fichier_nappe=Charger_fichier_nappe,
    chemin_fichier=chemin_fichier_COP)
    annotation(Placement(transformation(extent={{-60,40},{-40,60}})));

  BaseClasses.Remplissage_Pabs rempPabs(
    Pabs_pivot=Pabs_pivot,
    Statut_valeurs_Pabs=Statut_valeurs_Pabs,
    Charger_fichier_nappe=Charger_fichier_nappe,
    chemin_fichier=chemin_fichier_Pabs)
    annotation(Placement(transformation(extent={{-60,0},{-40,20}})));


  BaseClasses.Remplissage_EER rempEER(
    EER_pivot=EER_pivot,
    Statut_valeurs_EER=Statut_valeurs_EER,
    Charger_fichier_nappe=Charger_fichier_nappe,
    chemin_fichier=chemin_fichier_EER)
    annotation(Placement(transformation(extent={{-60,-40},{-40,-20}})));

// ===== Sous-modèles techniques =====
  BaseClasses.LoadRatio lr(
    Inverter=Inverter,
    LR_contmin=LR_contmin,
    CCP_LRcontmin=CCP_LRcontmin,
    Taux=Taux, mode_LR = loi_multi_zone)
    annotation(Placement(transformation(origin = {4, 0}, extent = {{0, 20}, {20, 40}})));

  BaseClasses.TemperatureLimits lim(
    Lim_Theta=Lim_Theta,
    Theta_min_am = Theta_min_am,
    Theta_max_am = Theta_max_am,
    Theta_min_av = Theta_min_av,
    Theta_max_av = Theta_max_av)
    annotation(Placement(transformation(origin = {-2, 42}, extent = {{40, 20}, {60, 40}})));

  BaseClasses.EnergyAccounting bilan
    annotation(Placement(transformation(origin = {34, -16}, extent = {{0, -40}, {20, -20}})));

  Modelica.Blocks.Logical.Switch switchCOP_EER
    annotation(Placement(transformation(origin = {-4, 0}, extent = {{-20, 10}, {0, -10}}, rotation = -0)));

equation
  P_utile = lr.P_utile * (if lim.actif then 1 else 0);
  connect(T_aval, rempCOP.Taval) annotation(
    Line(points = {{-110, 70}, {-74, 70}, {-74, 54}, {-62, 54}}, color = {0, 0, 127}));
  connect(T_aval, rempPabs.Taval) annotation(
    Line(points = {{-110, 70}, {-74, 70}, {-74, 14}, {-62, 14}}, color = {0, 0, 127}));
  connect(T_aval, rempEER.Taval) annotation(
    Line(points = {{-110, 70}, {-74, 70}, {-74, -26}, {-62, -26}}, color = {0, 0, 127}));
  connect(T_am, rempCOP.Tamont) annotation(
    Line(points = {{-110, 110}, {-78, 110}, {-78, 46}, {-62, 46}}, color = {0, 0, 127}));
  connect(T_am, rempPabs.Tamont) annotation(
    Line(points = {{-110, 110}, {-78, 110}, {-78, 6}, {-62, 6}}, color = {0, 0, 127}));
  connect(T_am, rempEER.Tamont) annotation(
    Line(points = {{-110, 110}, {-78, 110}, {-78, -34}, {-62, -34}}, color = {0, 0, 127}));
  connect(P_demande, lr.P_demande) annotation(
    Line(points = {{-110, 30}, {-20, 30}, {-20, 38}, {5, 38}}, color = {0, 0, 127}));
  connect(switchCOP_EER.y, lr.COP_nom) annotation(
    Line(points = {{-3, 0}, {0, 0}, {0, 30}, {5, 30}}, color = {0, 0, 127}));
  connect(rempPabs.Pabs, lr.Pabs_nom) annotation(
    Line(points = {{-38, 10}, {-34, 10}, {-34, 22}, {5, 22}}, color = {0, 0, 127}));
  connect(mode_chauffage, bilan.mode_chauffage) annotation(
    Line(points = {{-110, -10}, {-90, -10}, {-90, -46}, {35, -46}}, color = {255, 0, 255}));
  connect(mode_clim, bilan.mode_clim) annotation(
    Line(points = {{-110, -50}, {35, -50}}, color = {255, 0, 255}));
  connect(mode_ECS, bilan.mode_ECS) annotation(
    Line(points = {{-110, -90}, {-94, -90}, {-94, -55}, {35, -55}}, color = {255, 0, 255}));
  connect(lr.P_utile, bilan.P_utile) annotation(
    Line(points = {{22, 38}, {28, 38}, {28, -38}, {34, -38}}, color = {0, 0, 127}));
  connect(lr.P_abs, bilan.P_abs) annotation(
    Line(points = {{22, 30}, {26, 30}, {26, -42}, {34, -42}}, color = {0, 0, 127}));
  connect(T_am, lim.T_am) annotation(
    Line(points = {{-110, 110}, {-6, 110}, {-6, 79}, {39, 79}}, color = {0, 0, 127}));
  connect(T_aval, lim.T_av) annotation(
    Line(points = {{-110, 70}, {39, 70}, {39, 72}}, color = {0, 0, 127}));
  connect(lr.P_abs, lim.P_in) annotation(
    Line(points = {{22, 30}, {26, 30}, {26, 66}, {40, 66}}, color = {0, 0, 127}));
  connect(bilan.SCOP, SCOP) annotation(
    Line(points = {{54, -54}, {68, -54}, {68, -72}, {88, -72}}, color = {0, 0, 127}));
  connect(lim.P_out, P_abs) annotation(
    Line(points = {{56, 68}, {64, 68}, {64, 8}, {88, 8}}, color = {0, 0, 127}));
  connect(bilan.COP_inst, COP) annotation(
    Line(points = {{54, -52}, {68, -52}, {68, -32}, {88, -32}}, color = {0, 0, 127}));
  connect(mode_clim, switchCOP_EER.u2) annotation(
    Line(points = {{-110, -50}, {-34, -50}, {-34, 0}, {-26, 0}}, color = {255, 0, 255}));
  connect(rempEER.EER, switchCOP_EER.u1) annotation(
    Line(points = {{-38, -30}, {-26, -30}, {-26, -8}}, color = {0, 0, 127}));
  connect(rempCOP.COP, switchCOP_EER.u3) annotation(
    Line(points = {{-38, 50}, {-30, 50}, {-30, 8}, {-26, 8}}, color = {0, 0, 127}));

annotation(
Documentation(info = 
"<html>
<head></head>
<body>
<h2>Modèle PAC_inverter</h2>
<p>
Ce modèle représente une pompe à chaleur air/eau (chauffage, rafraîchissement, ECS),
conforme aux hypothèses RT2012/RE2020. 
Il combine les sous-modèles de performance (COP, Pabs, EER), la gestion Inverter/Tout ou Rien,
les limites de fonctionnement et la comptabilité énergétique.
</p>

<h3>Paramètres principaux</h3>

<ul>
  <li><b>Inverter</b> (Boolean) : 
    <ul>
      <li>true = PAC modulante (Inverter)</li>
      <li>false = PAC tout ou rien (TOR)</li>
    </ul>
  </li>

  <li><b>Charger_fichier_nappe</b> (Boolean) : 
    <ul>
      <li>true = les performances COP, Pabs, EER sont lues dans des fichiers txt (nappes normalisées)</li>
      <li>false = utilisation des valeurs par défaut construites à partir des pivots et coefficients</li>
    </ul>
  </li>

  <li><b>chemin_fichier_COP / chemin_fichier_Pabs / chemin_fichier_EER</b> (String) : 
    chemins vers les fichiers txt contenant les nappes correspondantes.</li>

  <li><b>COP_pivot</b> (Real) : 
    valeur du COP nominal au point pivot (T_am = 7 °C, T_av = 32.5 °C).</li>

  <li><b>Pabs_pivot</b> (Real) : 
    puissance absorbée nominale [W] au point pivot (T_am = 7 °C, T_av = 32.5 °C).</li>

  <li><b>EER_pivot</b> (Real) : 
    valeur du rendement frigorifique au point pivot.</li>

  <li><b>Statut_valeurs_Cop / Statut_valeurs_Pabs / Statut_valeurs_EER</b> (Integer) :
    <ul>
      <li>1 = valeurs certifiées</li>
      <li>2 = valeurs justifiées (appliquées avec un facteur correctif 0.9)</li>
      <li>3 = valeurs par défaut (appliquées avec un facteur correctif 0.8)</li>
    </ul>
  </li>

  <li><b>LR_contmin</b> (Real) : 
    taux de charge minimal en mode Inverter (0 &lt; LR &lt; 1).</li>

  <li><b>CCP_LRcontmin</b> (Real) : 
    ratio du COP (ou EER) à charge minimale sur le COP (ou EER) à pleine charge.</li>

  <li><b>Taux</b> (Real) : 
    ratio de la puissance auxiliaire consommée à charge nulle sur la puissance absorbée nominale.</li>

  <li><b>Lim_Theta</b> (Boolean) : 
    activation ou non des limites de fonctionnement en température amont et aval.</li>
</ul>

<h3>Entrées</h3>
<ul>
  <li><b>T_am</b> (°C) : température amont (source extérieure).</li>
  <li><b>T_aval</b> (°C) : température de départ (selon consigne chauffage, ECS, clim).</li>
  <li><b>P_demande</b> (W) : puissance demandée par l'installation.</li>
  <li><b>mode_chauffage</b> (Bool) : indicateur de mode chauffage.</li>
  <li><b>mode_clim</b> (Bool) : indicateur de mode rafraîchissement.</li>
  <li><b>mode_ECS</b> (Bool) : indicateur de mode eau chaude sanitaire.</li>
</ul>

<h3>Sorties</h3>
<ul>
  <li><b>P_utile</b> (W) : puissance utile fournie.</li>
  <li><b>P_abs</b> (W) : puissance absorbée par la PAC.</li>
  <li><b>COP</b> (-) : coefficient de performance instantané.</li>
  <li><b>SCOP</b> (-) : coefficient de performance saisonnier (calculé par bilan énergétique).</li>
</ul>

<h3>Fonctionnement</h3>
<p>
Le modèle combine :
</p>
<ul>
  <li>Les sous-modèles de remplissage COP, Pabs, EER (avec nappes ou pivots).</li>
  <li>Le calcul du taux de charge (LoadRatio), avec loi Inverter si activée.</li>
  <li>Les limites de fonctionnement (TemperatureLimits) qui coupent la PAC hors plage.</li>
  <li>La comptabilité énergétique (EnergyAccounting) pour le suivi des énergies et du SCOP.</li>
</ul>

</body>
</html>"
),
    Diagram(coordinateSystem(extent = {{-120, 120}, {100, -100}})),
    Icon(graphics = {Rectangle(origin = {-11, 3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-103, -85}, {103, 85}}), Rectangle(origin = {-101, 3}, fillColor = {255, 2, 2}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Rectangle(origin = {98, 3}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Line(origin = {4.18599, 70.814}, points = {{-90.186, 3.18599}, {79.814, 3.18599}, {79.814, 3.18599}}), Ellipse(origin = {3, -53}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {53, -52}, points = {{-31, 0}, {31, 0}, {31, 0}}), Line(origin = {-51, -52}, points = {{35, 0}, {-35, 0}, {-35, 0}}), Polygon(origin = {-8, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{-12, 10}, {-12, -10}, {12, 0}, {12, 0}, {-12, 10}}), Polygon(origin = {15, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{11, 10}, {11, -10}, {-11, 0}, {11, 10}, {11, 10}}), Text(origin = {14, 127}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts ",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end PAC_inverter;
