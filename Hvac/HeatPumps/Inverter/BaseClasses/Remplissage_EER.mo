within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;




model Remplissage_EER


  parameter Integer Statut_valeurs_EER = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  parameter Boolean Charger_fichier_nappe = true;
  parameter String chemin_fichier ="";
  parameter Real EER_pivot = 2.81;
  parameter Real EER_util_35 = EER_pivot;       ///
  parameter Real EER_util_25 = EER_util_36 * Cnnav_EER_4__9_5;       //
  parameter Real EER_util_45 = EER_util_34 * Cnnav_EER_15__9_5;       ///
  parameter Real EER_util_55 = EER_util_34 * Cnnav_EER_20_5__9_5;
  ///
  parameter Real EER_util_65 = EER_util_35 * Cnnav_EER_26__9_5;  
///
  parameter Real EER_util_22 = EER_util_25 * Cnnam_EER_2_5__32_5;
  ///
  parameter Real EER_util_23 = EER_util_25 * Cnnam_EER_12_5__32_5;       ///
  parameter Real EER_util_24 = EER_util_25 * Cnnam_EER_22_5__32_5;
  ///
  parameter Real EER_util_26 = EER_util_25 * Cnnam_EER_42_5__32_5;  
///
  parameter Real EER_util_32 = EER_util_35 * Cnnam_EER_2_5__32_5;
  ///
  parameter Real EER_util_33 = EER_util_35 * Cnnam_EER_12_5__32_5;       ///
  parameter Real EER_util_34 = EER_util_35 * Cnnam_EER_22_5__32_5;
  ///
  parameter Real EER_util_36 = EER_util_35 * Cnnam_EER_42_5__32_5;  
///
  parameter Real EER_util_42 = EER_util_45 * Cnnam_EER_2_5__32_5;
  ///
  parameter Real EER_util_43 = EER_util_45 * Cnnam_EER_12_5__32_5;       ///
  parameter Real EER_util_44 = EER_util_45 * Cnnam_EER_22_5__32_5;
  ///
  parameter Real EER_util_46 = EER_util_45 * Cnnam_EER_42_5__32_5;  
///
  parameter Real EER_util_52 = EER_util_55 * Cnnam_EER_2_5__32_5;
  ///
  parameter Real EER_util_53 = EER_util_55 * Cnnam_EER_12_5__32_5;       ///
  parameter Real EER_util_54 = EER_util_55 * Cnnam_EER_22_5__32_5;
  ///
  parameter Real EER_util_56 = EER_util_55 * Cnnam_EER_42_5__32_5;  
///
  parameter Real EER_util_62 = EER_util_65 * Cnnam_EER_2_5__32_5;
  ///
  parameter Real EER_util_63 = EER_util_65 * Cnnam_EER_12_5__32_5;       ///
  parameter Real EER_util_64 = EER_util_65 * Cnnam_EER_22_5__32_5;
  ///
  parameter Real EER_util_66 = EER_util_65 * Cnnam_EER_42_5__32_5;

///
  Modelica.Blocks.Tables.CombiTable2Ds combiTable2D(fileName = chemin_fichier,table = [EER_11, EER_util_12, EER_util_13, EER_util_14, EER_util_15, EER_util_16; EER_util_21, EER_util_22, EER_util_23, EER_util_24, EER_util_25, EER_util_26; EER_util_31, EER_util_32, EER_util_33, EER_util_34, EER_util_35, EER_util_36; EER_util_41, EER_util_42, EER_util_43, EER_util_44, EER_util_45, EER_util_46; EER_util_51, EER_util_52, EER_util_53, EER_util_54, EER_util_55, EER_util_56; EER_util_61, EER_util_62, EER_util_63, EER_util_64, EER_util_65, EER_util_66], tableName = "table1", tableOnFile = Charger_fichier_nappe) annotation(
    Placement(visible = true, transformation(origin = {-16, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //parameter Real[6,6] Table=
  // [EER_11, EER_util_12, EER_util_13, EER_util_14, EER_util_15, EER_util_16 ;EER_util_22, EER_util_21,EER_util_23,EER_util_24,EER_util_25,EER_util_26;  EER_util_31, EER_util_32, EER_util_33, EER_util_34, EER_util_35; EER_util_36; EER_util_41, EER_util_42, EER_util_43, EER_util_44, EER_util_45, EER_util_46 ; EER_util_51, EER_util_52, EER_util_53; EER_util_54, EER_util_55, EER_util_56; EER_util_61, EER_util_62; EER_util_63, EER_util_64, EER_util_65, EER_util_66] ;
  Modelica.Blocks.Interfaces.RealInput Taval annotation(
    Placement(visible = true, transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Tamont annotation(
    Placement(visible = true, transformation(origin = {-120, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EER annotation(
    Placement(visible = true, transformation(origin = {108, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  protected
  parameter Real Cnnav_EER_20_5__9_5 = 1.15;
  parameter Real Cnnav_EER_15__9_5 = 1.075;
  parameter Real Cnnav_EER_26__9_5 = 1.225;
  parameter Real Cnnav_EER_4__9_5 = 0.9;
  parameter Real Cnnam_EER_22_5__32_5 = 1.2;
  parameter Real Cnnam_EER_12_5__32_5 = 1.4;
  parameter Real Cnnam_EER_2_5__32_5 = 1.6;
  parameter Real Cnnam_EER_42_5__32_5 = 0.8;
  parameter Real EER_util_11 = 0;
  parameter Real EER_11 = 0;
  parameter Real EER_util_12 = 2.5;
  parameter Real EER_util_13 = 12.5;
  parameter Real EER_util_14 = 22.5;
  parameter Real EER_util_15 = 32.5;
  parameter Real EER_util_16 = 42.5;
  parameter Real EER_util_21 = 4;
  parameter Real EER_util_31 = 9.5;
  parameter Real EER_util_41 = 15;
  parameter Real EER_util_51 = 20.5;
  parameter Real EER_util_61 = 26;
equation

if Statut_valeurs_EER == 1 then
 EER = combiTable2D.y;
elseif Statut_valeurs_EER == 2 then 
 EER = 0.9 * combiTable2D.y;
else EER = 0.8 * combiTable2D.y;
end if;
  connect(Taval, combiTable2D.u1) annotation(
    Line(points = {{-120, 46}, {-76, 46}, {-76, 16}, {-28, 16}}, color = {0, 0, 127}));
  connect(Tamont, combiTable2D.u2) annotation(
    Line(points = {{-120, -14}, {-78, -14}, {-78, 4}, {-28, 4}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {0, 2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 36}, {100, -36}})}),
  Documentation(info = "<html><head></head><body>Ce modèle permet de calculer le EER de la PAC en prenant comme entrées les températures amont et aval de la pompe à chaleur.<div><br></div><div><u><font size=\"4\"><b>Paramètres :</b></font></u></div><div><ul><li><b>Charger_fichier_nappe</b>&nbsp;: un paramètre boolean qui prend true quand on souahite fournir un fichier txt pour la nappe de EER et qui prend false quand on n'a pas acces aux information relatives à la pompe à chaleur.</li><li><b>Chemin</b>&nbsp;<b>fichier</b>&nbsp;: lien URL vers le fichier txt qu'on souhaite renseigner.</li><li><b>Pabs_pivot :&nbsp;</b>valeur du EER à renseigner pour une température amont à -1.5 °C et une température aval de 32.5 °C.</li></ul></div><div><u><font size=\"4\"><b><br></b></font></u></div></body></html>"));
end Remplissage_EER;
