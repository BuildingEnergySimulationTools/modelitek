within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model PAC_inverter
  parameter Boolean Charger_fichier_nappe = true "Choisir le mode de rensignement des caractristiques de la PAC : Renseigner le nappe de COP par un fichier txt ou renseinger un COP pivot  ";
  parameter String chemin_fichier_COP = "" "Pour plus d'information sur le format du fichier txt à importer, veuillez consulter le descriptif du modèle PAC";
  parameter String chemin_fichier_Pabs = "";
  parameter String chemin_fichier_EER = """Pour plus d'information sur le format du fichier txt à importer, veuillez consulter le descriptif du modèle PAC";
  parameter Real EER_pivot = 2.81 "Valeur par défaut du EER ";
  parameter Real COP_pivot = 2.81 "Valeur par défaut du COP pour une température amont = 32.5°C (départ=35°C/retour=30°C) et une température avale = 9.5°C (ou départ=7°C/Retour=12°C)";
  parameter Real Pabs_pivot = 3830 "Valeur par défaut de la puissance absorbée pour une température amont = 32.5°C (départ=35°C/retour=30°C) et une température avale = 9.5°C (ou départ=7°C/Retour=12°C)";
  parameter Integer Statut_valeurs_Cop = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  parameter Integer Statut_valeurs_Pabs = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  
  parameter Integer Statut_valeurs = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  Boolean Inverter = true "true si PAC à régulation de puissance / false si PAC Tout ou Rien";
  parameter Real LR_contmin = 0.2 "Taux de charge minimal si PAC inverter (0<LR_contmin<1)";
  parameter Real T_aval_ECS = 60 "Température de consigne départ ECS";
  parameter Real T_aval_Chauffage = 45 "Température de consigne départ chauffage";
  parameter Real T_aval_Clim = 7 "Température de consigne départ climatisation";
  Real T_aval_inst;
  parameter Real Theta_max_av(unit = "(°C)") = 65 "Température limite maximale départ avale";
  parameter Real Theta_min_am(unit = "(°C)") = -10 "Température limite minimale amont";
  parameter Real Theta_min_av(unit = "(°C)") = 5 "Température limite minimale avale ";
  parameter Real Theta_max_am(unit = "(°C)") = 40 "Température limite maximale amont";
  parameter Boolean Lim_Theta = false "Activation limites des températures de fonctionnement amont et avale PAC";
  parameter Real CCP_LRcontmin(unit = "(0-1)") = 1 "Ratio du COP (ou EER) au taux de charge LRcontmin sur le COP (ou EER) à pleine charge";
  parameter Real Taux(unit = "(0-1)") = 0.02 "Ratio puissance auxiliaire à charge nulle sur la puissance absorbée à plein charge au point pivot ";
  parameter Real Deq = 0.5 "Durée équivalente liée aux irréversibilités";
  parameter Integer Dfou0_ch = 6 "32: Plancher ou plafond intégré au bâti, 19: Radiateur ou plafond d'inertie moyenne, 6: VCV, plancher et plafond d'inertie faible, 2: Systèmes à air";
  //Durée de fonctionnement à charge tendant vers 0
  parameter Integer Dfou0_ref = 6 "32: Plancher ou plafond intégré au bâti, 19: Radiateur ou plafond d'inertie moyenne, 6: VCV, plancher et plafond d'inertie faible, 2: Systèmes à air";
  //Durée de fonctionnement à charge tendant vers 0
  Modelica.Blocks.Interfaces.RealOutput Q_fou "Quantité fournie au bâtiment" annotation(
    Placement(visible = true, transformation(origin = {306, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-143, 63}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_cons "Quantité d'énergie consommée par le générateur" annotation(
    Placement(visible = true, transformation(origin = {304, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-66, -110}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput eta_eff "Effiacité effective du générateur" annotation(
    Placement(visible = true, transformation(origin = {362, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput phi_rejet "Quantité d'énergie rejetée à la source" annotation(
    Placement(visible = true, transformation(origin = {356, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {137, -9}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_rest "Energie restant à fournir au bâtiment" annotation(
    Placement(visible = true, transformation(origin = {304, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Q_req_ch "Besoin du bâtiment" annotation(
    Placement(visible = true, transformation(origin = {-232, -130}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-28, 112}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amont "Température amont de la source" annotation(
    Placement(visible = true, transformation(origin = {-165, 77}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {137, 75}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  //Activation de la limite sur les températures amont et/ou avale (=0 non active, =1 active)
  Modelica.Blocks.Interfaces.RealInput Q_req_ECS annotation(
    Placement(visible = true, transformation(origin = {-231, -9}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-118, 112}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Q_req_fr annotation(
    Placement(visible = true, transformation(origin = {-230, 124}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-72, 112}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression Emetteur_fr(y = Dfou0_ref) annotation(
    Placement(transformation(origin = {93, -23}, extent = {{-9, -7}, {9, 7}})));
  Modelica.Blocks.Sources.BooleanExpression Lim_theta(y = Lim_Theta) annotation(
    Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -6}, {10, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Product Pfou_pc_brut_ch_ECS annotation(
    Placement(visible = true, transformation(origin = {-41, -65}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  PAC_air_eau.Calcul_phi_rejet_ECS calcul_phi_rejet_ECS annotation(
    Placement(transformation(origin = {229, -89}, extent = {{-7, -7}, {7, 7}})));
  PAC_air_eau.Limit_temp_refr limit_temp_refr(Theta_max_am = Theta_max_am, Theta_min_av = Theta_min_av) annotation(
    Placement(visible = true, transformation(origin = {-13, 17}, extent = {{-7, 7}, {7, -7}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Emetteur_ch(y = Dfou0_ch) annotation(
    Placement(visible = true, transformation(origin = {95, -37}, extent = {{-9, -7}, {9, 7}}, rotation = 0)));
  PAC_air_eau.Calcul_chauf_clim calcul_chauf(CCP_LRcontmin = CCP_LRcontmin, Deq = Deq, LR_contmin = LR_contmin, Taux = Taux) annotation(
    Placement(transformation(origin = {128, -82}, extent = {{-10, -10}, {10, 10}})));
  PAC_air_eau.LR LR_clim annotation(
    Placement(visible = true, transformation(origin = {56, 10}, extent = {{-6, 6}, {6, -6}}, rotation = 0)));
  PAC_air_eau.Calcul_phi_rejet_ch calcul_phi_rejet_ch annotation(
    Placement(visible = true, transformation(origin = {167, -111}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Product Pfou_pc_brut_ref annotation(
    Placement(transformation(origin = {-45, -21}, extent = {{-7, -7}, {7, 7}})));
  PAC_air_eau.Calcul_chauf_clim calcul_clim(CCP_LRcontmin = CCP_LRcontmin, Deq = Deq, LR_contmin = LR_contmin, Taux = Taux) annotation(
    Placement(visible = true, transformation(origin = {126, -2}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  PAC_air_eau.LR LR_ch annotation(
    Placement(visible = true, transformation(origin = {58, -86}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  PAC_air_eau.Calcul_ECS calcul_ECS(Taux = Taux) annotation(
    Placement(visible = true, transformation(origin = {185, -61}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  PAC_air_eau.Limit_temp_ch_ECS limit_temp_ch_ECS(Theta_max_av = Theta_max_av, Theta_min_am = Theta_min_am) annotation(
    Placement(visible = true, transformation(origin = {-1, -77}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {39, -41}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Calcul_phi_rejet_clim calcul_phi_rejet_clim annotation(
    Placement(transformation(origin = {168, 76}, extent = {{-6, -6}, {6, 6}})));
  PAC_air_eau.Remplissage_Pabs remplissage_Pabs(Charger_fichier_nappe = Charger_fichier_nappe, Pabs_pivot = Pabs_pivot, Statut_valeurs_Pabs = Statut_valeurs_Pabs, chemin_fichier = chemin_fichier_Pabs) annotation(
    Placement(visible = true, transformation(origin = {-108, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_aval annotation(
    Placement(visible = true, transformation(origin = {-128, -154}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-142, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Taux_couverture annotation(
    Placement(visible = true, transformation(origin = {558, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {136, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrat_Q_req_ECS(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {366, 126}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrat_Q_req_ch(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {304, -130}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrat_Q_req_fr(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {218, 154}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.MultiSum multiSum(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {420, 108}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {458, 102}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 100) annotation(
    Placement(visible = true, transformation(origin = {507, 161}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  PAC_air_eau.T_aval_MODE t_aval_MODE(T_aval_Chauffage = T_aval_Chauffage, T_aval_Clim = T_aval_Clim, T_aval_ECS = T_aval_ECS) annotation(
    Placement(visible = true, transformation(origin = {-166, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.ModeFonc modeFonc_Qfou annotation(
    Placement(visible = true, transformation(origin = {282, 76}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  PAC_air_eau.ModeFonc modeFonc_Q_rest annotation(
    Placement(visible = true, transformation(origin = {280, 12}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  PAC_air_eau.ModeFonc modeFonc_eta_eff annotation(
    Placement(visible = true, transformation(origin = {280, -48}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  PAC_air_eau.ModeFonc modeFonc_Phi_rejet annotation(
    Placement(visible = true, transformation(origin = {280, -88}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  PAC_air_eau.ModeFonc modeFonc_Qcons annotation(
    Placement(visible = true, transformation(origin = {280, -8}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrat_Q_cons(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {350, -16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Econso_PAC annotation(
    Placement(visible = true, transformation(origin = {596, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-24, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.Integrator integrat_Q_rest(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {350, 16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrate_Q_fou(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {352, 80}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput SCOP_ch annotation(
    Placement(visible = true, transformation(origin = {588, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {136, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_retour_froid annotation(
    Placement(visible = true, transformation(origin = {-94, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-142, 4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //parametres de remplissage de la nappe de COP
  Modelica.Blocks.Interfaces.RealOutput Econso_PAC_ECS annotation(
    Placement(visible = true, transformation(origin = {596, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {66, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.Integrator EconsoPAC_ECS(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {462, -46}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {427, -47}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {362, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator EconsoPAC_ch(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {498, -90}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Econso_PAC_ch annotation(
    Placement(visible = true, transformation(origin = {596, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {22, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {463, -91}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {421, -91}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
 Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {526, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {401, 25}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not2 annotation(
    Placement(visible = true, transformation(origin = {353, 53}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator Q_fou_ch(k = 1 / 3.6e6) annotation(
    Placement(visible = true, transformation(origin = {438, 24}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput Besoins_ECS annotation(
    Placement(visible = true, transformation(origin = {410, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {21, 111}, extent = {{-11, -11}, {11, 11}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealOutput Besoins_chauf annotation(
    Placement(visible = true, transformation(origin = {340, 202}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {111, 111}, extent = {{-11, -11}, {11, 11}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealOutput Besoins_raf annotation(
    Placement(visible = true, transformation(origin = {250, 206}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {65, 111}, extent = {{-11, -11}, {11, 11}}, rotation = 90)));
 Modelica.Blocks.Math.Division division2 annotation(
    Placement(visible = true, transformation(origin = {526, 66}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput SCOP annotation(
    Placement(visible = true, transformation(origin = {588, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {136, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 PAC_air_eau.Remplissage_EER remplissage_EER(Charger_fichier_nappe = Charger_fichier_nappe, EER_pivot = EER_pivot, Statut_valeurs_EER = Statut_valeurs, chemin_fichier = chemin_fichier_EER)  annotation(
    Placement(transformation(origin = {-96, 4}, extent = {{-10, -10}, {10, 10}})));
protected
  parameter Real COP_util_23 = COP_pivot * Cnnav_COP_23_32;
  parameter Real COP_util_33 = COP_pivot;
  parameter Real COP_util_43 = COP_pivot * Cnnav_COP_42_32;
  parameter Real COP_util_53 = COP_util_43 * Cnnav_COP_51_42;
  parameter Real COP_util_63 = COP_util_53 * Cnnav_COP_60_51;
  parameter Real COP_util_22 = COP_util_23 * Cnnam_COP_6_1;
  parameter Real COP_util_32 = COP_util_33 * Cnnam_COP_6_1;
  parameter Real COP_util_42 = COP_util_43 * Cnnam_COP_6_1;
  parameter Real COP_util_52 = COP_util_53 * Cnnam_COP_6_1;
  parameter Real COP_util_62 = COP_util_63 * Cnnam_COP_6_1;
  parameter Real COP_util_24 = COP_util_23 * Cnnam_COP_3_1;
  parameter Real COP_util_34 = COP_util_33 * Cnnam_COP_3_1;
  parameter Real COP_util_44 = COP_util_43 * Cnnam_COP_3_1;
  parameter Real COP_util_54 = COP_util_53 * Cnnam_COP_3_1;
  parameter Real COP_util_64 = COP_util_63 * Cnnam_COP_3_1;
  parameter Real COP_util_25 = COP_util_23 * Cnnam_COP_8_1;
  parameter Real COP_util_35 = COP_util_33 * Cnnam_COP_8_1;
  parameter Real COP_util_45 = COP_util_43 * Cnnam_COP_8_1;
  parameter Real COP_util_55 = COP_util_53 * Cnnam_COP_8_1;
  parameter Real COP_util_65 = COP_util_63 * Cnnam_COP_8_1;
  parameter Real COP_util_26 = COP_util_23 * Cnnam_COP_13_1;
  parameter Real COP_util_36 = COP_util_33 * Cnnam_COP_13_1;
  parameter Real COP_util_46 = COP_util_43 * Cnnam_COP_13_1;
  parameter Real COP_util_56 = COP_util_53 * Cnnam_COP_13_1;
  parameter Real COP_util_66 = COP_util_63 * Cnnam_COP_13_1;
  parameter Real Pabs_util_23 = Pabs_pivot * Cnnav_Pabs_23_32;
  parameter Real Pabs_util_33 = Pabs_pivot;
  parameter Real Pabs_util_43 = Pabs_pivot * Cnnav_Pabs_42_32;
  parameter Real Pabs_util_53 = Pabs_util_43 * Cnnav_Pabs_51_42;
  parameter Real Pabs_util_63 = Pabs_util_53 * Cnnav_Pabs_60_51;
  parameter Real Pabs_util_22 = Pabs_util_23 * Cnnam_Pabs_6_1;
  parameter Real Pabs_util_32 = Pabs_util_33 * Cnnam_Pabs_6_1;
  parameter Real Pabs_util_42 = Pabs_util_43 * Cnnam_Pabs_6_1;
  parameter Real Pabs_util_52 = Pabs_util_53 * Cnnam_Pabs_6_1;
  parameter Real Pabs_util_62 = Pabs_util_63 * Cnnam_Pabs_6_1;
  parameter Real Pabs_util_24 = Pabs_util_23 * Cnnam_Pabs_3_1;
  parameter Real Pabs_util_34 = Pabs_util_33 * Cnnam_Pabs_3_1;
  parameter Real Pabs_util_44 = Pabs_util_43 * Cnnam_Pabs_3_1;
  parameter Real Pabs_util_54 = Pabs_util_53 * Cnnam_Pabs_3_1;
  parameter Real Pabs_util_64 = Pabs_util_63 * Cnnam_Pabs_3_1;
  parameter Real Pabs_util_25 = Pabs_util_23 * Cnnam_Pabs_8_1;
  parameter Real Pabs_util_35 = Pabs_util_33 * Cnnam_Pabs_8_1;
  parameter Real Pabs_util_45 = Pabs_util_43 * Cnnam_Pabs_8_1;
  parameter Real Pabs_util_55 = Pabs_util_53 * Cnnam_Pabs_8_1;
  parameter Real Pabs_util_65 = Pabs_util_63 * Cnnam_Pabs_8_1;
  parameter Real Pabs_util_26 = Pabs_util_23 * Cnnam_Pabs_13_1;
  parameter Real Pabs_util_36 = Pabs_util_33 * Cnnam_Pabs_13_1;
  parameter Real Pabs_util_46 = Pabs_util_43 * Cnnam_Pabs_13_1;
  parameter Real Pabs_util_56 = Pabs_util_53 * Cnnam_Pabs_13_1;
  parameter Real Pabs_util_66 = Pabs_util_63 * Cnnam_Pabs_13_1;

  PAC_air_eau.Remplissage_COP remplissage_COP(COP_pivot = COP_pivot, Charger_fichier_nappe = Charger_fichier_nappe, Statut_valeurs_Cop = Statut_valeurs_Pabs, chemin_fichier = chemin_fichier_COP) annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real Cnnav_COP_42_32 = 0.8;
  parameter Real Cnnav_COP_51_42 = 0.8;
  parameter Real Cnnav_COP_23_32 = 1.1;
  parameter Real Cnnav_COP_60_51 = 0.8;
  parameter Real Cnnam_COP_3_1 = 1.1;
  parameter Real Cnnam_COP_8_1 = 1.2;
  parameter Real Cnnam_COP_6_1 = 0.9;
  parameter Real Cnnam_COP_13_1 = 1.3;
  parameter Real COP_util_11 = 0;
  parameter Real COP_11 = 0;
  parameter Real COP_util_12 = -5;
  parameter Real COP_util_13 = 0;
  parameter Real COP_util_14 = 5;
  parameter Real COP_util_15 = 10;
  parameter Real COP_util_16 = 15;
  parameter Real COP_util_21 = 23.5;
  parameter Real COP_util_31 = 32.5;
  parameter Real COP_util_41 = 42.5;
  parameter Real COP_util_51 = 51;
  parameter Real COP_util_61 = 60;
  parameter Real Cnnav_Pabs_42_32 = 0.9;
  parameter Real Cnnav_Pabs_51_42 = 0.915;
  parameter Real Cnnav_Pabs_23_32 = 1.09;
  parameter Real Cnnav_Pabs_60_51 = 0.91;
  parameter Real Cnnam_Pabs_3_1 = 1.05;
  parameter Real Cnnam_Pabs_8_1 = 1.1;
  parameter Real Cnnam_Pabs_6_1 = 0.95;
  parameter Real Cnnam_Pabs_13_1 = 1.15;
  parameter Real Pabs_util_11 = 0;
  parameter Real Pabs_util_12 = -5;
  parameter Real Pabs_util_13 = 0;
  parameter Real Pabs_util_14 = 5;
  parameter Real Pabs_util_15 = 10;
  parameter Real Pabs_util_16 = 15;
  parameter Real Pabs_util_21 = 23.5;
  parameter Real Pabs_util_31 = 32.5;
  parameter Real Pabs_util_41 = 42.5;
  parameter Real Pabs_util_51 = 51;
  parameter Real Pabs_util_61 = 60;
equation
  calcul_chauf.Inverter = Inverter;
  calcul_clim.Inverter = Inverter;
  if Q_req_ECS > 0 then
    T_aval_inst = 60;
  else
    if Q_req_ch > 0 then
      T_aval_inst = 45;
    else
      T_aval_inst = 7;
    end if;
  end if;
  connect(Emetteur_ch.y, calcul_chauf.Dfou0) annotation(
    Line(points = {{104.9, -37}, {104.9, -71}, {134, -71}}, color = {0, 0, 127}));
  connect(limit_temp_refr.Pfou_pc, LR_clim.P_fou_PC) annotation(
    Line(points = {{-5.3, 12.94}, {7.7, 12.94}, {7.7, 6.94}, {48.2, 6.94}}, color = {0, 0, 127}));
  connect(calcul_ECS.P_fou_LR, calcul_phi_rejet_ECS.P_fou_LR) annotation(
    Line(points = {{194.9, -53.62}, {204.9, -53.62}, {204.9, -93}, {221, -93}}, color = {0, 0, 127}));
  connect(limit_temp_ch_ECS.Pfou_pc, calcul_ECS.P_fou_PC) annotation(
    Line(points = {{6.7, -72.94}, {19.7, -72.94}, {19.7, -61.94}, {173.7, -61.94}}, color = {0, 0, 127}));
  connect(Pfou_pc_brut_ch_ECS.y, calcul_chauf.P_fou_pc_brut) annotation(
    Line(points = {{-33.3, -65}, {8.7, -65}, {8.7, -79}, {117, -79}}, color = {0, 0, 127}));
  connect(calcul_chauf.P_comp_LR, calcul_phi_rejet_ch.P_comp_LR) annotation(
    Line(points = {{139, -86}, {144, -86}, {144, -106.2}, {160, -106.2}}, color = {0, 0, 127}));
  connect(Lim_theta.y, limit_temp_refr.Lim_Theta) annotation(
    Line(points = {{-27, -44}, {-13, -44}, {-13, 9}}, color = {255, 0, 255}));
  connect(limit_temp_ch_ECS.Qres_ch, LR_ch.Qrest_act) annotation(
    Line(points = {{6.7, -79.38}, {15.7, -79.38}, {15.7, -90.38}, {49.7, -90.38}}, color = {0, 0, 127}));
  connect(Pfou_pc_brut_ref.y, calcul_clim.P_fou_pc_brut) annotation(
    Line(points = {{-37, -21}, {26.7, -21}, {26.7, -6}, {115.7, -6}}, color = {0, 0, 127}));
  connect(LR_clim.LR, calcul_clim.LR) annotation(
    Line(points = {{63.32, 6.16}, {90.32, 6.16}, {90.32, 0.66}, {115.32, 0.66}}, color = {0, 0, 127}));
  connect(limit_temp_ch_ECS.Pfou_pc, LR_ch.P_fou_PC) annotation(
    Line(points = {{6.7, -72.94}, {27.45, -72.94}, {27.45, -82.94}, {50.2, -82.94}}, color = {0, 0, 127}));
  connect(LR_clim.P_fou_LR, calcul_clim.P_fou_LR) annotation(
    Line(points = {{63.32, 10}, {89.32, 10}, {89.32, 6}, {115.32, 6}}, color = {0, 0, 127}));
  connect(Emetteur_fr.y, calcul_clim.Dfou0) annotation(
    Line(points = {{103, -23}, {134, -23}, {134, -13}, {131.9, -13}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, LR_ch.I_ECS_seule) annotation(
    Line(points = {{46.7, -41}, {57.7, -41}, {57.7, -79}}, color = {255, 0, 255}));
  connect(Lim_theta.y, limit_temp_ch_ECS.Lim_Theta) annotation(
    Line(points = {{-27, -44}, {-1, -44}, {-1, -69}}, color = {255, 0, 255}));
  connect(calcul_ECS.P_abs_LR, calcul_phi_rejet_ECS.P_abs_LR) annotation(
    Line(points = {{194.9, -63.7}, {204.9, -63.7}, {204.9, -84}, {221, -84}}, color = {0, 0, 127}));
  connect(LR_ch.LR, calcul_chauf.LR) annotation(
    Line(points = {{65.32, -82.16}, {65.32, -84.5}, {117, -84.5}}, color = {0, 0, 127}));
  connect(calcul_chauf.P_compma_LR, calcul_phi_rejet_ch.P_compma_LR) annotation(
    Line(points = {{139, -82}, {144, -82}, {144, -112.2}, {160, -112.2}}, color = {0, 0, 127}));
  connect(limit_temp_refr.Qres_ch, LR_clim.Qrest_act) annotation(
    Line(points = {{-5.3, 19.38}, {47.7, 19.38}, {47.7, 14.38}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, LR_clim.I_ECS_seule) annotation(
    Line(points = {{46.7, -41}, {55.7, -41}, {55.7, 3}}, color = {255, 0, 255}));
  connect(LR_ch.P_fou_LR, calcul_chauf.P_fou_LR) annotation(
    Line(points = {{65.32, -86}, {90.32, -86}, {90.32, -90}, {117, -90}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, calcul_ECS.I_ECS_seule) annotation(
    Line(points = {{46.7, -41}, {183.7, -41}, {183.7, -50}}, color = {255, 0, 255}));
  connect(Pfou_pc_brut_ch_ECS.y, limit_temp_ch_ECS.Pfou_pc_brut) annotation(
    Line(points = {{-33.3, -65}, {-27.3, -65}, {-27.3, -72}, {-8.3, -72}}, color = {0, 0, 127}));
  connect(Pfou_pc_brut_ref.y, limit_temp_refr.Pfou_pc_brut) annotation(
    Line(points = {{-37, -21}, {-31.3, -21}, {-31.3, 10}, {-20.3, 10}}, color = {0, 0, 127}));
  connect(Q_req_ch, limit_temp_ch_ECS.Q_req_act) annotation(
    Line(points = {{-232, -130}, {-232, -96}, {-1, -96}, {-1, -85}}, color = {0, 0, 127}));
  connect(Q_req_ch, LR_ch.Q_req_act) annotation(
    Line(points = {{-232, -130}, {-232, -86}, {50, -86}}, color = {0, 0, 127}));
  connect(Q_req_fr, LR_clim.Q_req_act) annotation(
    Line(points = {{-230, 124}, {14, 124}, {14, 11}, {49, 11}}, color = {0, 0, 127}));
  connect(Q_req_fr, limit_temp_refr.Q_req_act) annotation(
    Line(points = {{-230, 124}, {-230, 68}, {-13, 68}, {-13, 25}}, color = {0, 0, 127}));
  connect(Q_req_ECS, calcul_ECS.Q_req_act) annotation(
    Line(points = {{-231, -9}, {160, -9}, {160, -68}, {174, -68}}, color = {0, 0, 127}));
  connect(Q_req_ECS, greaterThreshold.u) annotation(
    Line(points = {{-231, -9}, {12, -9}, {12, -41}, {31, -41}}, color = {0, 0, 127}));
  connect(calcul_clim.P_comp_LR, calcul_phi_rejet_clim.P_comp_LR) annotation(
    Line(points = {{137, 2}, {146, 2}, {146, 81}, {161, 81}}, color = {0, 0, 127}));
  connect(calcul_clim.P_compma_LR, calcul_phi_rejet_clim.P_compma_LR) annotation(
    Line(points = {{137, -2}, {146, -2}, {146, 76}, {161, 76}}, color = {0, 0, 127}));
  connect(remplissage_Pabs.Pabs, Pfou_pc_brut_ref.u2) annotation(
    Line(points = {{-97, -31.8}, {-65.5, -31.8}, {-65.5, -25}, {-53, -25}}, color = {0, 0, 127}));
  connect(remplissage_Pabs.Pabs, calcul_clim.P_abs_pc) annotation(
    Line(points = {{-97, -31.8}, {64, -31.8}, {64, -9.8}, {115, -9.8}}, color = {0, 0, 127}));
  connect(remplissage_Pabs.Pabs, calcul_ECS.P_abs_pc) annotation(
    Line(points = {{-97, -31.8}, {34.5, -31.8}, {34.5, -53.8}, {176, -53.8}}, color = {0, 0, 127}));
  connect(remplissage_Pabs.Pabs, calcul_chauf.P_abs_pc) annotation(
    Line(points = {{-97, -31.8}, {-14, -31.8}, {-14, -74}, {117, -74}}, color = {0, 0, 127}));
  connect(remplissage_Pabs.Pabs, Pfou_pc_brut_ch_ECS.u1) annotation(
    Line(points = {{-97, -31.8}, {-92.5, -31.8}, {-92.5, -59.8}, {-50, -59.8}}, color = {0, 0, 127}));
  connect(T_amont, limit_temp_refr.T_amont) annotation(
    Line(points = {{-165, 77}, {-46, 77}, {-46, 17}, {-21, 17}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_Pabs.Tamont) annotation(
    Line(points = {{-165, 77}, {-120, 77}, {-120, -35}}, color = {0, 0, 127}));
  connect(T_amont, limit_temp_ch_ECS.T_amont) annotation(
    Line(points = {{-165, 77}, {-124, 77}, {-124, -77}, {-9, -77}}, color = {0, 0, 127}));
  connect(calcul_chauf.P_fou_LR_Reel, calcul_phi_rejet_ch.P_fou_LR) annotation(
    Line(points = {{139, -90}, {143, -90}, {143, -116}, {159, -116}}, color = {0, 0, 127}));
  connect(calcul_clim.P_fou_LR_Reel, calcul_phi_rejet_clim.P_fou_LR) annotation(
    Line(points = {{137, 6}, {146, 6}, {146, 71}, {161, 71}}, color = {0, 0, 127}));
  connect(modeFonc_Qfou.y, Q_fou) annotation(
    Line(points = {{289, 76}, {297.5, 76}, {297.5, 74}, {306, 74}}, color = {0, 0, 127}));
  connect(modeFonc_Q_rest.y, Q_rest) annotation(
    Line(points = {{286.78, 12.18}, {285.28, 12.18}, {285.28, 10.18}, {303.78, 10.18}}, color = {0, 0, 127}));
  connect(modeFonc_eta_eff.y, eta_eff) annotation(
    Line(points = {{287, -48}, {324.28, -48}, {324.28, -39.82}, {361.78, -39.82}}, color = {0, 0, 127}));
  connect(modeFonc_Phi_rejet.y, phi_rejet) annotation(
    Line(points = {{286.78, -87.82}, {286.06, -87.82}, {286.06, -69.82}, {355.78, -69.82}}, color = {0, 0, 127}));
  connect(calcul_phi_rejet_ch.ph_rejet, modeFonc_Phi_rejet.Chauffage) annotation(
    Line(points = {{174.7, -111.28}, {250.7, -111.28}, {250.7, -82.28}, {273.7, -82.28}}, color = {0, 0, 127}));
  connect(calcul_phi_rejet_clim.ph_rejet, modeFonc_Phi_rejet.Climatisation) annotation(
    Line(points = {{175, 76}, {206, 76}, {206, -88}, {273, -88}}, color = {0, 0, 127}));
  connect(calcul_phi_rejet_ECS.ph_rejet, modeFonc_Phi_rejet.ECS) annotation(
    Line(points = {{237, -89}, {242.7, -89}, {242.7, -92.28}, {273.7, -92.28}}, color = {0, 0, 127}));
  connect(calcul_ECS.COP_LR, modeFonc_eta_eff.ECS) annotation(
    Line(points = {{194.9, -58.84}, {240.9, -58.84}, {240.9, -53}, {273, -53}}, color = {0, 0, 127}));
  connect(calcul_clim.COP_LR, modeFonc_eta_eff.Climatisation) annotation(
    Line(points = {{137, -10.2}, {203, -10.2}, {203, -48}, {273, -48}}, color = {0, 0, 127}));
  connect(calcul_chauf.COP_LR, modeFonc_eta_eff.Chauffage) annotation(
    Line(points = {{139, -74}, {203, -74}, {203, -57.8}, {239, -57.8}, {239, -43}, {273, -43}}, color = {0, 0, 127}));
  connect(LR_ch.Q_rest_act, modeFonc_Q_rest.Chauffage) annotation(
    Line(points = {{65.32, -89.96}, {203.32, -89.96}, {203.32, 17.04}, {272.32, 17.04}}, color = {0, 0, 127}));
  connect(calcul_ECS.Q_res_ECS, modeFonc_Q_rest.ECS) annotation(
    Line(points = {{194.9, -68.56}, {204.9, -68.56}, {204.9, 6.44}, {273.9, 6.44}}, color = {0, 0, 127}));
  connect(LR_clim.Q_rest_act, modeFonc_Q_rest.Climatisation) annotation(
    Line(points = {{63.32, 13.96}, {167.82, 13.96}, {167.82, 11.96}, {272.32, 11.96}}, color = {0, 0, 127}));
  connect(calcul_clim.P_fou_LR_Reel, modeFonc_Qfou.Climatisation) annotation(
    Line(points = {{137, 6}, {146, 6}, {146, 50}, {206, 50}, {206, 76}, {275, 76}}, color = {0, 0, 127}));
  connect(calcul_ECS.P_fou_LR, modeFonc_Qfou.ECS) annotation(
    Line(points = {{195, -54}, {206, -54}, {206, 71}, {275, 71}}, color = {0, 0, 127}));
  connect(calcul_chauf.P_fou_LR_Reel, modeFonc_Qfou.Chauffage) annotation(
    Line(points = {{139, -90}, {146, -90}, {146, -54}, {206, -54}, {206, 81}, {275, 81}}, color = {0, 0, 127}));
  connect(calcul_chauf.P_abs_LR, modeFonc_Qcons.Chauffage) annotation(
    Line(points = {{139, -77}, {203, -77}, {203, -2.2}, {272, -2.2}}, color = {0, 0, 127}));
  connect(calcul_ECS.P_abs_LR, modeFonc_Qcons.ECS) annotation(
    Line(points = {{194.9, -63.7}, {204.9, -63.7}, {204.9, -12.7}, {273.9, -12.7}}, color = {0, 0, 127}));
  connect(calcul_clim.P_abs_LR, modeFonc_Qcons.Climatisation) annotation(
    Line(points = {{137, -6.8}, {194.5, -6.8}, {194.5, -8.8}, {272, -8.8}}, color = {0, 0, 127}));
  connect(modeFonc_Qcons.y, Q_cons) annotation(
    Line(points = {{286.78, -7.82}, {286.28, -7.82}, {286.28, -8}, {304, -8}}, color = {0, 0, 127}));
  connect(Q_req_fr, modeFonc_Qfou.P_besoin_clim) annotation(
    Line(points = {{-230, 124}, {226, 124}, {226, 100}, {286, 100}, {286, 83}}, color = {0, 0, 127}));
  connect(Q_req_fr, modeFonc_Q_rest.P_besoin_clim) annotation(
    Line(points = {{-230, 124}, {226, 124}, {226, 64}, {284, 64}, {284, 19}}, color = {0, 0, 127}));
  connect(Q_req_fr, modeFonc_Qcons.P_besoin_clim) annotation(
    Line(points = {{-230, 124}, {226, 124}, {226, 40}, {284, 40}, {284, -1}}, color = {0, 0, 127}));
  connect(Q_req_fr, modeFonc_eta_eff.P_besoin_clim) annotation(
    Line(points = {{-230, 124}, {226, 124}, {226, 14}, {284, 14}, {284, -41}}, color = {0, 0, 127}));
  connect(Q_req_fr, modeFonc_Phi_rejet.P_besoin_clim) annotation(
    Line(points = {{-230, 124}, {226, 124}, {226, -14}, {284, -14}, {284, -81}}, color = {0, 0, 127}));
  connect(Q_req_ch, modeFonc_Phi_rejet.P_besoin_chauf) annotation(
    Line(points = {{-232, -130}, {280, -130}, {280, -96}}, color = {0, 0, 127}));
  connect(Q_req_ch, modeFonc_eta_eff.P_besoin_chauf) annotation(
    Line(points = {{-232, -130}, {280, -130}, {280, -55}}, color = {0, 0, 127}));
  connect(Q_req_ch, modeFonc_Qcons.P_besoin_chauf) annotation(
    Line(points = {{-232, -130}, {280, -130}, {280, -15}}, color = {0, 0, 127}));
  connect(Q_req_ch, modeFonc_Q_rest.P_besoin_chauf) annotation(
    Line(points = {{-232, -130}, {280, -130}, {280, 5}}, color = {0, 0, 127}));
  connect(Q_req_ch, modeFonc_Qfou.P_besoin_chauf) annotation(
    Line(points = {{-232, -130}, {282, -130}, {282, 69}}, color = {0, 0, 127}));
  connect(Q_req_ECS, modeFonc_Qfou.P_besoin_ECS) annotation(
    Line(points = {{-231, -9}, {36, -9}, {36, 92}, {278, 92}, {278, 84}}, color = {0, 0, 127}));
  connect(Q_req_ECS, modeFonc_Q_rest.P_besoin_ECS) annotation(
    Line(points = {{-231, -9}, {34, -9}, {34, 56}, {277, 56}, {277, 19}}, color = {0, 0, 127}));
  connect(Q_req_ECS, modeFonc_Qcons.P_besoin_ECS) annotation(
    Line(points = {{-231, -9}, {34, -9}, {34, 56}, {276, 56}, {276, 0}}, color = {0, 0, 127}));
  connect(Q_req_ECS, modeFonc_eta_eff.P_besoin_ECS) annotation(
    Line(points = {{-231, -9}, {34, -9}, {34, 56}, {277, 56}, {277, -41}}, color = {0, 0, 127}));
  connect(Q_req_ECS, modeFonc_Phi_rejet.P_besoin_ECS) annotation(
    Line(points = {{-231, -9}, {34, -9}, {34, 56}, {276, 56}, {276, -80}}, color = {0, 0, 127}));
  connect(Q_cons, integrat_Q_cons.u) annotation(
    Line(points = {{304, -8}, {323.5, -8}, {323.5, -16}, {343, -16}}, color = {0, 0, 127}));
  connect(integrat_Q_cons.y, Econso_PAC) annotation(
    Line(points = {{357, -16}, {462.3, -16}, {462.3, -36}, {596, -36}}, color = {0, 0, 127}));
  connect(Q_fou, integrate_Q_fou.u) annotation(
    Line(points = {{306, 74}, {334, 74}, {334, 80}, {344, 80}}, color = {0, 0, 127}));
  connect(Q_req_ECS, integrat_Q_req_ECS.u) annotation(
    Line(points = {{-231, -9}, {36, -9}, {36, 126}, {359, 126}}, color = {0, 0, 127}));
  connect(Q_req_ch, integrat_Q_req_ch.u) annotation(
    Line(points = {{-232, -130}, {297, -130}}, color = {0, 0, 127}));
  connect(Q_req_fr, integrat_Q_req_fr.u) annotation(
    Line(points = {{-230, 124}, {-230, 154}, {211, 154}}, color = {0, 0, 127}));
  connect(integrat_Q_req_fr.y, multiSum.u[1]) annotation(
    Line(points = {{225, 154}, {414, 154}, {414, 108}}, color = {0, 0, 127}));
  connect(integrat_Q_req_ECS.y, multiSum.u[2]) annotation(
    Line(points = {{373, 126}, {388, 126}, {388, 108}, {414, 108}}, color = {0, 0, 127}));
  connect(integrat_Q_req_ch.y, multiSum.u[3]) annotation(
    Line(points = {{311, -130}, {412, -130}, {412, 108}, {414, 108}}, color = {0, 0, 127}));
  connect(integrate_Q_fou.y, division.u1) annotation(
    Line(points = {{358, 80}, {448, 80}, {448, 97}}, color = {0, 0, 127}));
  connect(multiSum.y, division.u2) annotation(
    Line(points = {{427.02, 108}, {440.02, 108}, {440.02, 107}, {447.02, 107}}, color = {0, 0, 127}));
  connect(division.y, gain.u) annotation(
    Line(points = {{466, 102}, {486, 102}, {486, 161}, {501, 161}}, color = {0, 0, 127}));
  connect(gain.y, Taux_couverture) annotation(
    Line(points = {{512.5, 161}, {544.5, 161}, {544.5, 162}, {558, 162}}, color = {0, 0, 127}));
  connect(Q_rest, integrat_Q_rest.u) annotation(
    Line(points = {{304, 10}, {324, 10}, {324, 16}, {342, 16}}, color = {0, 0, 127}));
  connect(Q_req_fr, t_aval_MODE.Climatisation) annotation(
    Line(points = {{-230, 124}, {-202, 124}, {-202, -42}, {-178, -42}}, color = {0, 0, 127}));
  connect(Q_req_ECS, t_aval_MODE.ECS) annotation(
    Line(points = {{-231, -9}, {-187, -9}, {-187, -35}, {-179, -35}}, color = {0, 0, 127}));
  connect(Q_req_ch, t_aval_MODE.Chauffage) annotation(
    Line(points = {{-232, -130}, {-190, -130}, {-190, -50}, {-178, -50}}, color = {0, 0, 127}));
  connect(t_aval_MODE.y, remplissage_Pabs.Taval) annotation(
    Line(points = {{-154.7, -41.7}, {-139.7, -41.7}, {-139.7, -27.7}, {-120.7, -27.7}}, color = {0, 0, 127}));
  connect(t_aval_MODE.y, T_aval) annotation(
    Line(points = {{-154.7, -41.7}, {-150.7, -41.7}, {-150.7, -115.7}, {-128.7, -115.7}, {-128.7, -153.7}}, color = {0, 0, 127}));
  connect(t_aval_MODE.y, limit_temp_refr.T_aval) annotation(
    Line(points = {{-154.7, -41.7}, {-142.7, -41.7}, {-142.7, 24.3}, {-22.7, 24.3}}, color = {0, 0, 127}));
  connect(t_aval_MODE.y, limit_temp_ch_ECS.T_aval) annotation(
    Line(points = {{-154.7, -41.7}, {-150.7, -41.7}, {-150.7, -83.7}, {-10.7, -83.7}}, color = {0, 0, 127}));
  T_retour_froid = T_amont - 5;
  connect(t_aval_MODE.y, remplissage_COP.Taval) annotation(
    Line(points = {{-154.7, -41.7}, {-136.7, -41.7}, {-136.7, -59.7}, {-120.7, -59.7}}, color = {0, 0, 127}));
  connect(T_amont, remplissage_COP.Tamont) annotation(
    Line(points = {{-164, 78}, {-140, 78}, {-140, -67}, {-120, -67}}, color = {0, 0, 127}));
  connect(remplissage_COP.COP, Pfou_pc_brut_ch_ECS.u2) annotation(
    Line(points = {{-97, -63.8}, {-95, -63.8}, {-95, -69.8}, {-51, -69.8}}, color = {0, 0, 127}));
  connect(EconsoPAC_ECS.y, Econso_PAC_ECS) annotation(
    Line(points = {{468.6, -46}, {514.3, -46}, {514.3, -76}, {596, -76}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, switch1.u2) annotation(
    Line(points = {{46.7, -41}, {400.7, -41}, {400.7, -48}, {419.7, -48}}, color = {255, 0, 255}));
  connect(Q_cons, switch1.u1) annotation(
    Line(points = {{304, -8}, {406, -8}, {406, -41}, {419, -41}}, color = {0, 0, 127}));
  connect(switch1.y, EconsoPAC_ECS.u) annotation(
    Line(points = {{434.7, -47}, {454.7, -47}}, color = {0, 0, 127}));
  connect(constant1.y, switch1.u3) annotation(
    Line(points = {{373, -94}, {397, -94}, {397, -52}, {417, -52}}, color = {0, 0, 127}));
  connect(switch.y, EconsoPAC_ch.u) annotation(
    Line(points = {{470.7, -91}, {490.7, -91}}, color = {0, 0, 127}));
  connect(EconsoPAC_ch.y, Econso_PAC_ch) annotation(
    Line(points = {{504.6, -90}, {532.3, -90}, {532.3, -120}, {596, -120}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, not1.u) annotation(
    Line(points = {{46.7, -41}, {406.7, -41}, {406.7, -91}, {416.7, -91}}, color = {255, 0, 255}));
  connect(not1.y, switch.u2) annotation(
    Line(points = {{426.5, -91}, {454.5, -91}}, color = {255, 0, 255}));
  connect(Q_cons, switch.u1) annotation(
    Line(points = {{304, -8}, {446, -8}, {446, -86}, {454, -86}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{373, -94}, {407, -94}, {407, -96}, {453, -96}}, color = {0, 0, 127}));
  connect(switch2.y, Q_fou_ch.u) annotation(
    Line(points = {{408.7, 25}, {418.85, 25}, {418.85, 24}, {428, 24}}, color = {0, 0, 127}));
  connect(not2.y, switch2.u2) annotation(
    Line(points = {{358.5, 53}, {372.5, 53}, {372.5, 25}, {393, 25}}, color = {255, 0, 255}));
  connect(division1.y, SCOP_ch) annotation(
    Line(points = {{534.8, 22}, {565.8, 22}, {565.8, 24}, {587.8, 24}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, not2.u) annotation(
    Line(points = {{46, -40}, {332, -40}, {332, 54}, {348, 54}}, color = {255, 0, 255}));
  connect(Q_fou, switch2.u1) annotation(
    Line(points = {{306, 74}, {372, 74}, {372, 31}, {393, 31}}, color = {0, 0, 127}));
  connect(constant1.y, switch2.u3) annotation(
    Line(points = {{373, -94}, {378, -94}, {378, 19}, {393, 19}}, color = {0, 0, 127}));
  connect(Q_fou_ch.y, division1.u1) annotation(
    Line(points = {{446.8, 24}, {479.3, 24}, {479.3, 26}, {515.8, 26}}, color = {0, 0, 127}));
  connect(EconsoPAC_ch.y, division1.u2) annotation(
    Line(points = {{504, -90}, {506, -90}, {506, 17}, {516, 17}}, color = {0, 0, 127}));
  connect(integrat_Q_req_fr.y, Besoins_raf) annotation(
    Line(points = {{224, 154}, {250, 154}, {250, 206}}, color = {0, 0, 127}));
  connect(integrat_Q_req_ECS.y, Besoins_ECS) annotation(
    Line(points = {{372, 126}, {410, 126}, {410, 200}}, color = {0, 0, 127}));
  connect(integrat_Q_req_ch.y, Besoins_chauf) annotation(
    Line(points = {{310, -130}, {340, -130}, {340, 202}}, color = {0, 0, 127}));
  connect(division2.y, SCOP) annotation(
    Line(points = {{534.8, 66}, {565.8, 66}, {565.8, 68}, {587.8, 68}}, color = {0, 0, 127}));
  connect(integrat_Q_cons.y, division2.u2) annotation(
    Line(points = {{357, -16}, {492, -16}, {492, 62}, {516, 62}}, color = {0, 0, 127}));
  connect(integrate_Q_fou.y, division2.u1) annotation(
    Line(points = {{358, 80}, {456, 80}, {456, 70}, {516, 70}}, color = {0, 0, 127}));
 connect(T_amont, remplissage_EER.Taval) annotation(
    Line(points = {{-164, 78}, {-124, 78}, {-124, 8}, {-108, 8}}, color = {0, 0, 127}));
 connect(t_aval_MODE.y, remplissage_EER.Tamont) annotation(
    Line(points = {{-154, -42}, {-130, -42}, {-130, 1}, {-108, 1}}, color = {0, 0, 127}));
 connect(remplissage_EER.EER, Pfou_pc_brut_ref.u1) annotation(
    Line(points = {{-85, 4}, {-66, 4}, {-66, -17}, {-53, -17}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-180, 160}, {520, -120}})),
    Icon(graphics = {Rectangle(origin = {-3, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-129, -100}, {129, 100}}), Rectangle(origin = {-101, 3}, fillColor = {255, 2, 2}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Rectangle(origin = {100, 3}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Line(origin = {4.18599, 70.814}, points = {{-90.186, 3.18599}, {79.814, 3.18599}, {79.814, 3.18599}}), Ellipse(origin = {3, -51}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {-0.757248, -50.9645}, points = {{-15.2428, -1.03549}, {14.7572, -15.0355}, {14.7572, 14.9645}, {-15.2428, -1.03549}}), Line(origin = {53, -52}, points = {{-31, 0}, {31, 0}, {31, 0}}), Line(origin = {-51, -52}, points = {{35, 0}, {-35, 0}, {-35, 0}}), Polygon(origin = {-8, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{-12, 10}, {-12, -10}, {12, 0}, {12, 0}, {-12, 10}}), Polygon(origin = {15, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{11, 10}, {11, -10}, {-11, 0}, {11, 10}, {11, 10}})}),
    Documentation(info = "<html><head></head><body>Ce modèle de pompe à chaleur air/eau fonctionnant sur des nappes de COP est directement inspiré du modèle de la RE2020.<div><div><br><font size=\"4\"><b><u>Paramètres :</u></b></font></div><div><br></div><div>




<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:HyphenationZone>21</w:HyphenationZone>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>FR</w:LidThemeOther>
  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=\"Cambria Math\"/>
   <m:brkBin m:val=\"before\"/>
   <m:brkBinSub m:val=\"&#45;-\"/>
   <m:smallFrac m:val=\"off\"/>
   <m:dispDef/>
   <m:lMargin m:val=\"0\"/>
   <m:rMargin m:val=\"0\"/>
   <m:defJc m:val=\"centerGroup\"/>
   <m:wrapIndent m:val=\"1440\"/>
   <m:intLim m:val=\"subSup\"/>
   <m:naryLim m:val=\"undOvr\"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
  DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
  LatentStyleCount=\"376\">
  <w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 9\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"header\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footer\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of figures\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope return\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"line number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"page number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of authorities\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"macro\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"toa heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Closing\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Signature\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Message Header\"/>
  <w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Salutation\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Date\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Note Heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Block Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"FollowedHyperlink\"/>
  <w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
  <w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Document Map\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Plain Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"E-mail Signature\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Top of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Bottom of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal (Web)\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Acronym\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Cite\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Code\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Definition\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Keyboard\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Preformatted\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Sample\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Typewriter\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Variable\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Table\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation subject\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"No List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Contemporary\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Elegant\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Professional\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Balloon Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Theme\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
  <w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
   Name=\"List Paragraph\"/>
  <w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
   Name=\"Intense Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
   Name=\"Subtle Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
   Name=\"Intense Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
   Name=\"Subtle Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
   Name=\"Intense Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
  <w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hashtag\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Unresolved Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Link\"/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:\"Tableau Normal\";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:\"\";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:\"Calibri\",sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:\"Times New Roman\";
	mso-bidi-theme-font:minor-bidi;
	mso-font-kerning:1.0pt;
	mso-ligatures:standardcontextual;
	mso-fareast-language:EN-US;}
</style>
<![endif]-->



<!--StartFragment-->

<p class=\"MsoNormal\" style=\"margin-bottom:0cm;line-height:normal;tab-stops:45.8pt 91.6pt 137.4pt 183.2pt 229.0pt 274.8pt 320.6pt 366.4pt 412.2pt 458.0pt 503.8pt 549.6pt 595.4pt 641.2pt 687.0pt 732.8pt\"></p><ul><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Charger_fichier_nappe : Choisir le mode de renseingement des caractéristiques de la PAC,</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">chemin_fichier_COP : Renseigner le chemin du fichier txt de la nappe de COP,</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">chemin_fichier_Pabs :&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 12px;\">Renseigner le chemin du fichier txt de la nappe de Pabs</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">chemin_fichier_EER :&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 12px;\">Renseigner le chemin du fichier txt de la nappe de EER,</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">COP_pivot : Valeur par défaut du COP pour une température amont de 7°C et une température aval de 32.5°C.</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Pabs_pivot : Valeur par défaut du Pabs pour une puissance amont de 7°C et une température aval de 32.5°C.</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">&nbsp;</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Statut_valeurs_Cop :&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">1 :
Certifiées, 2: Justifiées, 3: Par défaut</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Statut_valeurs_Pabs : 1 : Certifiées, 2: Justifiées, 3: Par
défaut</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Statut_valeurs :</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">&nbsp;</span><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">1 :
Certifiées, 2: Justifiées, 3: Par défaut</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Inverter : true si PAC à
régulation de puissance / false si PAC Tout ou Rien</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">LR_contmin :Taux de charge
minimal si PAC inverter (0&lt;LR_contmin&lt;1)</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">T_aval_ECS : Température de
consigne départ ECS</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">T_aval_Chauffage : Température de consigne départ
chauffage</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">T_aval_Clim : &nbsp;Température de consigne départ climatisation</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Lim_Theta : Activation limites des températures de
fonctionnement amont et avale PAC</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">CCP_LRcontmin : Ratio du COP (ou EER)
au taux de charge LRcontmin sur le COP (ou EER) à pleine charge</span></li><li><span style=\"font-family: 'MS Shell Dlg 2', serif; font-size: 9pt;\">Taux : Ratio puissance auxiliaire à charge nulle sur la puissance absorbée à
plein charge au point pivot&nbsp;</span></li></ul><p></p>

<!--EndFragment--></div><div><br></div><div><b><u>Caractéristiques PAC :</u></b></div><div><b><u><br></u></b></div><div>Les caractérstiques de performance de la PAC sont à renseigner sours forme de nappe en format txt.</div><div><br></div><div><br></div><div>Exemple de fichier txt pour les nappes de COP.</div><div><pre style=\"font-size: 12px;\">#1
double COP(3,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0
<br></pre><pre style=\"font-size: 12px;\">Dans le cas de manque de données, il suffit de renseigner un COP pivot et Pabs pivot.</pre><pre style=\"font-size: 12px;\"><br></pre></div></div></body></html>"));
end PAC_inverter;
