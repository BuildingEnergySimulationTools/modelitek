within Modelitek.Hvac.HeatPumps.PAC_air_eau;




model Remplissage_Pabs_froid


  parameter Integer Statut_valeurs_P_abs = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
   parameter Boolean Charger_fichier_nappe = true;
  parameter String chemin_fichier ="S:\04_AFFAIRES\A_MARCHE\220036A22 ThermiUp_B2B_01\Lot_03_Modelisation_Tests\04_Taches\Modelisation\Besoins chauffage_ECS_batiment\Pabs.txt";
  parameter Real P_abs_pivot = 4000;
  protected
  parameter Real Cnnav_P_abs_20_5__9_5 = 1.11;
  parameter Real Cnnav_P_abs_15__9_5 = 1.055;
  parameter Real Cnnav_P_abs_26__9_5 = 1.165;
  parameter Real Cnnav_P_abs_4__9_5 = 0.945;
  parameter Real Cnnam_P_abs_22_5__32_5 = 1.1;
  parameter Real Cnnam_P_abs_12_5__32_5 = 1.2;
  parameter Real Cnnam_P_abs_2_5__32_5 = 1.2;
  parameter Real Cnnam_P_abs_42_5__32_5 = 0.9;
  parameter Real P_abs_util_11 = 0;
  parameter Real P_abs_11 = 0;
  parameter Real P_abs_util_12 = 2.5;
  parameter Real P_abs_util_13 = 12.5;
  parameter Real P_abs_util_14 = 22.5;
  parameter Real P_abs_util_15 = 32.5;
  parameter Real P_abs_util_16 = 42.5;
  parameter Real P_abs_util_21 = 4;
  parameter Real P_abs_util_31 = 9.5;
  parameter Real P_abs_util_41 = 15;
  parameter Real P_abs_util_51 = 20.5;
  parameter Real P_abs_util_61 = 26;
  public
  parameter Real P_abs_util_35 = P_abs_pivot;     ///
  parameter Real P_abs_util_25 = P_abs_util_36 * Cnnav_P_abs_4__9_5;     //
  parameter Real P_abs_util_45 = P_abs_util_34 * Cnnav_P_abs_15__9_5;     ///
  parameter Real P_abs_util_55 = P_abs_util_34 * Cnnav_P_abs_20_5__9_5;
  ///
  parameter Real P_abs_util_65 = P_abs_util_35 * Cnnav_P_abs_26__9_5;  
///
  parameter Real P_abs_util_22 = P_abs_util_25 * Cnnam_P_abs_2_5__32_5;
  ///
  parameter Real P_abs_util_23 = P_abs_util_25 * Cnnam_P_abs_12_5__32_5;     ///
  parameter Real P_abs_util_24 = P_abs_util_25 * Cnnam_P_abs_22_5__32_5;
  ///
  parameter Real P_abs_util_26 = P_abs_util_25 * Cnnam_P_abs_42_5__32_5;  
///
  parameter Real P_abs_util_32 = P_abs_util_35 * Cnnam_P_abs_2_5__32_5;
  ///
  parameter Real P_abs_util_33 = P_abs_util_35 * Cnnam_P_abs_12_5__32_5;     ///
  parameter Real P_abs_util_34 = P_abs_util_35 * Cnnam_P_abs_22_5__32_5;
  ///
  parameter Real P_abs_util_36 = P_abs_util_35 * Cnnam_P_abs_42_5__32_5;  
///
  parameter Real P_abs_util_42 = P_abs_util_45 * Cnnam_P_abs_2_5__32_5;
  ///
  parameter Real P_abs_util_43 = P_abs_util_45 * Cnnam_P_abs_12_5__32_5;     ///
  parameter Real P_abs_util_44 = P_abs_util_45 * Cnnam_P_abs_22_5__32_5;
  ///
  parameter Real P_abs_util_46 = P_abs_util_45 * Cnnam_P_abs_42_5__32_5;  
///
  parameter Real P_abs_util_52 = P_abs_util_55 * Cnnam_P_abs_2_5__32_5;
  ///
  parameter Real P_abs_util_53 = P_abs_util_55 * Cnnam_P_abs_12_5__32_5;     ///
  parameter Real P_abs_util_54 = P_abs_util_55 * Cnnam_P_abs_22_5__32_5;
  ///
  parameter Real P_abs_util_56 = P_abs_util_55 * Cnnam_P_abs_42_5__32_5;  
///
  parameter Real P_abs_util_62 = P_abs_util_65 * Cnnam_P_abs_2_5__32_5;
  ///
  parameter Real P_abs_util_63 = P_abs_util_65 * Cnnam_P_abs_12_5__32_5;     ///
  parameter Real P_abs_util_64 = P_abs_util_65 * Cnnam_P_abs_22_5__32_5;
  ///
  parameter Real P_abs_util_66 = P_abs_util_65 * Cnnam_P_abs_42_5__32_5;

///
  Modelica.Blocks.Tables.CombiTable2Ds combiTable2D(fileName = chemin_fichier,table = [P_abs_11, P_abs_util_12, P_abs_util_13, P_abs_util_14, P_abs_util_15, P_abs_util_16; P_abs_util_21, P_abs_util_22, P_abs_util_23, P_abs_util_24, P_abs_util_25, P_abs_util_26; P_abs_util_31, P_abs_util_32, P_abs_util_33, P_abs_util_34, P_abs_util_35, P_abs_util_36; P_abs_util_41, P_abs_util_42, P_abs_util_43, P_abs_util_44, P_abs_util_45, P_abs_util_46; P_abs_util_51, P_abs_util_52, P_abs_util_53, P_abs_util_54, P_abs_util_55, P_abs_util_56; P_abs_util_61, P_abs_util_62, P_abs_util_63, P_abs_util_64, P_abs_util_65, P_abs_util_66], tableName = "table1", tableOnFile = Charger_fichier_nappe) annotation(
    Placement(visible = true, transformation(origin = {-14, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //parameter Real[6,6] Table=
  // [P_abs_11, P_abs_util_12, P_abs_util_13, P_abs_util_14, P_abs_util_15, P_abs_util_16 ;P_abs_util_22, P_abs_util_21,P_abs_util_23,P_abs_util_24,P_abs_util_25,P_abs_util_26;  P_abs_util_31, P_abs_util_32, P_abs_util_33, P_abs_util_34, P_abs_util_35; P_abs_util_36; P_abs_util_41, P_abs_util_42, P_abs_util_43, P_abs_util_44, P_abs_util_45, P_abs_util_46 ; P_abs_util_51, P_abs_util_52, P_abs_util_53; P_abs_util_54, P_abs_util_55, P_abs_util_56; P_abs_util_61, P_abs_util_62; P_abs_util_63, P_abs_util_64, P_abs_util_65, P_abs_util_66] ;
  Modelica.Blocks.Interfaces.RealInput Taval annotation(
    Placement(visible = true, transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Tamont annotation(
    Placement(visible = true, transformation(origin = {-120, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_abs annotation(
    Placement(visible = true, transformation(origin = {108, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

if Statut_valeurs_P_abs == 1 then
 P_abs = combiTable2D.y;
elseif Statut_valeurs_P_abs == 2 then 
 P_abs = 0.9 * combiTable2D.y;
else P_abs = 0.8 * combiTable2D.y;
end if;




  connect(Taval, combiTable2D.u1) annotation(
    Line(points = {{-120, 46}, {-76, 46}, {-76, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(Tamont, combiTable2D.u2) annotation(
    Line(points = {{-120, -14}, {-78, -14}, {-78, 4}, {-26, 4}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {0, 2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 36}, {100, -36}})}),
  Documentation(info = "<html><head></head><body>Ce modèle permet de calculer la puissance absorbée par l'évaporateur de la PAC en mode chaud en prenant comme entrées les températures amont et aval de la pompe à chaleur.<div><br></div><div><u><font size=\"4\"><b>Paramètres :</b></font></u></div><div><ul><li><b>Charger_fichier_nappe</b>&nbsp;: un paramètre boolean qui prend true quand on souahite fournir un fichier txt pour la nappe de Pabs et qui prend false quand on n'a pas acces aux information relatives à la pompe à chaleur.</li><li><b>Chemin</b>&nbsp;<b>fichier</b>&nbsp;: lien URL vers le fichier txt qu'on souhaite renseigner.</li><li><b>COP_pivot :&nbsp;</b>valeur du Pabs à renseigner pour une température amont à -1.5 °C et une température aval de 32.5 °C.</li></ul></div></body></html>"));
end Remplissage_Pabs_froid;
