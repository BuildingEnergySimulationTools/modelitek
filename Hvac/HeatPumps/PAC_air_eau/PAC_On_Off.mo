within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model PAC_On_Off
parameter Real Waux=200"Puissance des auxilières";
parameter Real dT_pince=5"Pincement entre l'entrée et la sortie de la PAC";
parameter Integer Statut_valeurs=3 "Statut valeurs , 1 : certifiés, 2 : justifiés, 3 : par défaut " ;
parameter Boolean Charger_fichier_nappe =true;
parameter String chemin_fichier_COP="";
  parameter String chemin_fichier_Pabs="";
  parameter String chemin_fichier_EER="";
parameter Real COP_pivot_ECS = 2.81 "COP à renseigner pour le remplissage par défaut de la nappe de COP de l'ECS";
parameter Real COP_pivot_ch= 2.81 "COP à renseigner pour le remplissage par défaut de la nappe de COP du chauffage";
parameter Real EER_pivot_clim= 2.81"EER à renseigner pour le remplissage par défaut de la nappe de COP de climatisation";
parameter Real Pabs_pivot_ECS=3830"Pabs à renseigner pour le remplissage par défaut de la nappe de puissance de l'ECS";
parameter Real Pabs_pivot_ch=3830"Pabs à renseigner pour le remplissage par défaut de la nappe de puissance de chauffage";
parameter Real Pabs_pivot_clim=3830 "Pabs à renseigner pour le remplissage par défaut de la nappe de puissance de climatisation";




  PAC_air_eau.Remplissage_COP remplissage_COP_ecs(COP_pivot = COP_pivot_ECS, Charger_fichier_nappe = Charger_fichier_nappe, Statut_valeurs_Cop = Statut_valeurs, chemin_fichier = chemin_fichier_COP)  annotation(
    Placement(visible = true, transformation(origin = {-40, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.Remplissage_COP remplissage_COP_ch(COP_pivot = COP_pivot_ch, Charger_fichier_nappe = Charger_fichier_nappe, Statut_valeurs_Cop = Statut_valeurs, chemin_fichier = chemin_fichier_COP)  annotation(
    Placement(visible = true, transformation(origin = {-40, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.Remplissage_Pabs remplissage_Pabs_ecs(Charger_fichier_nappe = Charger_fichier_nappe,Pabs_pivot = Pabs_pivot_ECS, Statut_valeurs_Pabs = Statut_valeurs, chemin_fichier = chemin_fichier_Pabs)  annotation(
    Placement(visible = true, transformation(origin = {-40, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.Remplissage_Pabs remplissage_Pabs_ch(Charger_fichier_nappe = Charger_fichier_nappe, Pabs_pivot = Pabs_pivot_ch, Statut_valeurs_Pabs = Statut_valeurs, chemin_fichier = chemin_fichier_Pabs)  annotation(
    Placement(visible = true, transformation(origin = {-40, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.Remplissage_EER remplissage_EER(Charger_fichier_nappe = Charger_fichier_nappe,EER_pivot = EER_pivot_clim, Statut_valeurs_EER = Statut_valeurs, chemin_fichier = chemin_fichier_EER)  annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.Remplissage_Pabs_froid remplissage_Pabs_froid(Charger_fichier_nappe = Charger_fichier_nappe, P_abs_pivot = Pabs_pivot_clim, Statut_valeurs_P_abs = Statut_valeurs, chemin_fichier = chemin_fichier_Pabs)  annotation(
    Placement(visible = true, transformation(origin = {-40, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_amont annotation(
    Placement(visible = true, transformation(origin = {-174, 42}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {138, 46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant T_aval_CH(k = 65)  annotation(
    Placement(visible = true, transformation(origin = {-136, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant T_aval_ECS(k = 45)  annotation(
    Placement(visible = true, transformation(origin = {-110, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant T_aval_clim(k = 7)  annotation(
    Placement(visible = true, transformation(origin = {-136, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.ControlePacOnOff controlePacOnOff(Waux = Waux, dT_pince = dT_pince)  annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Debit_ECS annotation(
    Placement(visible = true, transformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-141, 87}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput Debit_Tampon annotation(
    Placement(visible = true, transformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-141, -15}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput T_vers_ballon_ECS annotation(
    Placement(visible = true, transformation(origin = {112, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-141, 55}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput T_vers_ballon_tampon annotation(
    Placement(visible = true, transformation(origin = {112, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-142, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput Pfou annotation(
    Placement(visible = true, transformation(origin = {112, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput T_ballon_ECS annotation(
    Placement(visible = true, transformation(origin = {111, 27}, extent = {{11, -11}, {-11, 11}}, rotation = 0), iconTransformation(origin = {-142, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput T_ballon_tampon annotation(
    Placement(visible = true, transformation(origin = {111, 9}, extent = {{11, -11}, {-11, 11}}, rotation = 0), iconTransformation(origin = {-141, -79}, extent = {{9, -9}, {-9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput P_ch annotation(
    Placement(visible = true, transformation(origin = {44, 124}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {60, 122}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  PAC_air_eau.Mode_ch_clim mode_ch_clim(Mode(fixed = true))  annotation(
    Placement(visible = true, transformation(origin = {30, 76}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput P_clim annotation(
    Placement(visible = true, transformation(origin = {16, 124}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {-48, 122}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput phi_rejet annotation(
    Placement(visible = true, transformation(origin = {40, -88}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(T_aval_CH.y, remplissage_COP_ecs.Taval) annotation(
    Line(points = {{-125, 2}, {-84, 2}, {-84, 52}, {-52, 52}}, color = {0, 0, 127}));
  connect(T_aval_CH.y, remplissage_Pabs_ecs.Taval) annotation(
    Line(points = {{-125, 2}, {-84, 2}, {-84, 36}, {-52, 36}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_COP_ecs.Tamont) annotation(
    Line(points = {{-174, 42}, {-112, 42}, {-112, 44}, {-52, 44}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_Pabs_ecs.Tamont) annotation(
    Line(points = {{-174, 42}, {-92, 42}, {-92, 29}, {-52, 29}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_COP_ch.Tamont) annotation(
    Line(points = {{-174, 42}, {-92, 42}, {-92, 9}, {-52, 9}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_Pabs_ch.Tamont) annotation(
    Line(points = {{-174, 42}, {-92, 42}, {-92, -8}, {-52, -8}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_EER.Tamont) annotation(
    Line(points = {{-174, 42}, {-92, 42}, {-92, -24}, {-52, -24}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_Pabs_froid.Tamont) annotation(
    Line(points = {{-174, 42}, {-92, 42}, {-92, -42}, {-52, -42}}, color = {0, 0, 127}));
  connect(T_aval_clim.y, remplissage_Pabs_froid.Taval) annotation(
    Line(points = {{-125, -52}, {-70, -52}, {-70, -34}, {-52, -34}}, color = {0, 0, 127}));
  connect(T_aval_clim.y, remplissage_EER.Taval) annotation(
    Line(points = {{-125, -52}, {-70, -52}, {-70, -16}, {-52, -16}}, color = {0, 0, 127}));
  connect(T_aval_ECS.y, remplissage_Pabs_ch.Taval) annotation(
    Line(points = {{-98, -18}, {-76, -18}, {-76, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(T_aval_ECS.y, remplissage_COP_ch.Taval) annotation(
    Line(points = {{-98, -18}, {-76, -18}, {-76, 16}, {-52, 16}}, color = {0, 0, 127}));
  connect(remplissage_COP_ecs.COP, controlePacOnOff.COP_ECS) annotation(
    Line(points = {{-28, 48}, {-16, 48}, {-16, 28}, {6, 28}}, color = {0, 0, 127}));
  connect(remplissage_Pabs_ecs.Pabs, controlePacOnOff.Pabs_ECS) annotation(
    Line(points = {{-28, 32}, {-22, 32}, {-22, 22}, {6, 22}}, color = {0, 0, 127}));
  connect(remplissage_COP_ch.COP, controlePacOnOff.COP_ch) annotation(
    Line(points = {{-28, 12}, {-10, 12}, {-10, 13}, {6, 13}}, color = {0, 0, 127}));
  connect(remplissage_Pabs_ch.Pabs, controlePacOnOff.Pabs_ch) annotation(
    Line(points = {{-28, -4}, {-10, -4}, {-10, 6}, {6, 6}}, color = {0, 0, 127}));
  connect(remplissage_Pabs_froid.P_abs, controlePacOnOff.Pabs_EER) annotation(
    Line(points = {{-28, -38}, {-2, -38}, {-2, -13}, {6, -13}}, color = {0, 0, 127}));
  connect(remplissage_EER.EER, controlePacOnOff.EER) annotation(
    Line(points = {{-28, -20}, {-8, -20}, {-8, -5}, {6, -5}}, color = {0, 0, 127}));
  connect(controlePacOnOff.Debit_ECS, Debit_ECS) annotation(
    Line(points = {{71, 26}, {80, 26}, {80, 58}, {110, 58}}, color = {0, 0, 127}));
  connect(controlePacOnOff.Debit_Tampon, Debit_Tampon) annotation(
    Line(points = {{71, 19}, {88, 19}, {88, 42}, {110, 42}}, color = {0, 0, 127}));
  connect(controlePacOnOff.T_vers_ballon_ECS, T_vers_ballon_ECS) annotation(
    Line(points = {{71, -11}, {93, -11}, {93, -10}, {112, -10}}, color = {0, 0, 127}));
  connect(controlePacOnOff.T_vers_ballon_Tampon, T_vers_ballon_tampon) annotation(
    Line(points = {{71, -19}, {90, -19}, {90, -24}, {112, -24}}, color = {0, 0, 127}));
  connect(controlePacOnOff.P_fou, Pfou) annotation(
    Line(points = {{71, -26}, {88, -26}, {88, -40}, {112, -40}}, color = {0, 0, 127}));
  connect(T_ballon_ECS, controlePacOnOff.T_ballon_ECS) annotation(
    Line(points = {{111, 27}, {96, 27}, {96, 11}, {70, 11}}, color = {0, 0, 127}));
  connect(T_ballon_tampon, controlePacOnOff.T_ballon_Tampon) annotation(
    Line(points = {{112, 10}, {90, 10}, {90, 0}, {70, 0}}, color = {0, 0, 127}));
  connect(mode_ch_clim.Mode, controlePacOnOff.Mode_ch_clim) annotation(
    Line(points = {{31, 58}, {32, 58}, {32, 34}}, color = {255, 127, 0}));
  connect(P_ch, mode_ch_clim.Pch) annotation(
    Line(points = {{44, 124}, {44, 104}, {38, 104}, {38, 94}}, color = {0, 0, 127}));
  connect(P_clim, mode_ch_clim.Pclim) annotation(
    Line(points = {{16, 124}, {16, 106}, {26, 106}, {26, 94}}, color = {0, 0, 127}));
  connect(controlePacOnOff.phi_rejet, phi_rejet) annotation(
    Line(points = {{38, -32}, {40, -32}, {40, -88}}, color = {0, 0, 127}));
  annotation(
     
    Diagram(coordinateSystem(extent = {{-200, 140}, {120, -80}})),
    Icon(graphics = {Rectangle(origin = {-3, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-129, -100}, {129, 100}}), Rectangle(origin = {-101, 3}, fillColor = {255, 2, 2}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Rectangle(origin = {100, 3}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Line(origin = {4.18599, 70.814}, points = {{-90.186, 3.18599}, {79.814, 3.18599}, {79.814, 3.18599}}), Ellipse(origin = {3, -51}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {-0.757248, -50.9645}, points = {{-15.2428, -1.03549}, {14.7572, -15.0355}, {14.7572, 14.9645}, {-15.2428, -1.03549}}), Line(origin = {53, -52}, points = {{-31, 0}, {31, 0}, {31, 0}}), Line(origin = {-51, -52}, points = {{35, 0}, {-35, 0}, {-35, 0}}), Polygon(origin = {-8, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{-12, 10}, {-12, -10}, {12, 0}, {12, 0}, {-12, 10}}), Polygon(origin = {15, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{11, 10}, {11, -10}, {-11, 0}, {11, 10}, {11, 10}})}),
    Documentation(info = "<html><head></head><body>Modèle de pompe à chaleur On/off air/eau fonctionnant sur des nappes de COP.<div><br></div><div><font size=\"4\"><b><u>Paramètres :</u></b></font></div><div><font size=\"4\"><b><u><br></u></b></font></div><div><ul><li><font size=\"4\"><b>Waux </b>: Puissance des auxilières,</font></li><li><font size=\"4\"><b>dt_pince </b>: Pincement entre l'entrée et ma srtie de la PAC,</font></li><li><font size=\"4\"><b>Statut_valeurs </b>: 1 : certifiés , 2 : justifiés , 3 : par défaut ,</font></li><li><font size=\"4\"><b>COP_pivot_ECS</b> :<b> </b>COP à renseigner pour le remplissage par défaut de la nappe de COP de l'ECS,</font></li><li><font size=\"4\"><b>EER_pivot_clim</b> :<b>&nbsp;</b></font><span style=\"font-size: large;\">EER à renseigner pour le remplissage par défaut de la nappe de EER de la climatisation,</span></li><li><font size=\"4\"><b>Pabs_pivot_ECS </b>:&nbsp;</font><span style=\"font-size: large;\">Pabs à renseigner pour le remplissage par défaut de la nappe de Puissance absorbée</span><span style=\"font-size: large;\">&nbsp;pour l'ECS,</span></li><li><font size=\"4\"><b>Pabs_pivot_ch </b>:<b>&nbsp;</b></font><span style=\"font-size: large;\">Pabs à renseigner pour le remplissage par défaut de la nappe de Puissance absorbée</span><span style=\"font-size: large;\">&nbsp;pourle chauffage,</span></li><li><font size=\"4\"><b>Pabs_pivot_clim </b>:&nbsp;</font><span style=\"font-size: large;\">Pabs à renseigner pour le remplissage par défaut de la nappe de Puissance absorbée</span><span style=\"font-size: large;\">&nbsp;pourle climatisation,</span></li></ul></div><div><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px; white-space: normal;\">Exemple de fichier txt pour les nappes de COP.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px; white-space: normal;\"><pre>#1
double COP(3,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0
<br></pre><pre>Dans le cas de manque de données, il suffit de renseigner un COP pivot et Pabs pivot.</pre></div></pre></div></body></html>"));
end PAC_On_Off;
