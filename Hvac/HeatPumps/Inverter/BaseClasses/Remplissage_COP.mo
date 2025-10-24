within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;




model Remplissage_COP


  parameter Integer Statut_valeurs_Cop = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  parameter Boolean Charger_fichier_nappe = true;
  parameter String chemin_fichier ="";
  parameter Real COP_pivot = 2.81;
  protected
  parameter Real Cnnav_COP_42_32 = 0.8;
  parameter Real Cnnav_COP_51_42 = 0.8;
  parameter Real Cnnav_COP_23_32 = 1.1;
  parameter Real Cnnav_COP_60_51 = 0.8;
  parameter Real Cnnam_COP_n7_7 = 0.5;
  parameter Real Cnnam_COP_2_7 = 0.8;
  parameter Real Cnnam_COP_20_7 = 1.25;
  parameter Real Cnnam_COP_n15_n7 = 0.8;
  parameter Real COP_util_11 = 0;
  parameter Real COP_11 = 0;
  parameter Real COP_util_12 = -12.5;
  parameter Real COP_util_13 = -7;
  parameter Real COP_util_14 = 2;
  parameter Real COP_util_15 = 7;
  parameter Real COP_util_16 = 20;
  parameter Real COP_util_21 = 23.5;
  parameter Real COP_util_31 = 32.5;
  parameter Real COP_util_41 = 42.5;
  parameter Real COP_util_51 = 51;
  parameter Real COP_util_61 = 60;
  public
  
  parameter Real COP_util_35 = COP_pivot;
  parameter Real COP_util_25 = COP_pivot * Cnnav_COP_23_32;
  parameter Real COP_util_45 = COP_pivot * Cnnav_COP_42_32;
  parameter Real COP_util_55 = COP_util_45 * Cnnav_COP_51_42;
  parameter Real COP_util_65 = COP_util_55 * Cnnav_COP_60_51;
  
  parameter Real COP_util_23 = COP_util_25 * Cnnam_COP_n7_7;
  parameter Real COP_util_33 = COP_util_35 * Cnnam_COP_n7_7;
  parameter Real COP_util_43 = COP_util_45 * Cnnam_COP_n7_7;
  parameter Real COP_util_53 = COP_util_55 * Cnnam_COP_n7_7;
  parameter Real COP_util_63 = COP_util_65 * Cnnam_COP_n7_7;
  
  parameter Real COP_util_24 = COP_util_25 * Cnnam_COP_2_7;
  parameter Real COP_util_34 = COP_util_35 * Cnnam_COP_2_7;
  parameter Real COP_util_44 = COP_util_45 * Cnnam_COP_2_7;
  parameter Real COP_util_54 = COP_util_55 * Cnnam_COP_2_7;
  parameter Real COP_util_64 = COP_util_65 * Cnnam_COP_2_7;
  
  parameter Real COP_util_26 = COP_util_25 * Cnnam_COP_20_7;
  parameter Real COP_util_36 = COP_util_35 * Cnnam_COP_20_7;
  parameter Real COP_util_46 = COP_util_45 * Cnnam_COP_20_7;
  parameter Real COP_util_56 = COP_util_55 * Cnnam_COP_20_7;
  parameter Real COP_util_66 = COP_util_65 * Cnnam_COP_20_7;
  
  parameter Real COP_util_22 = COP_util_23 * Cnnam_COP_n15_n7;
  parameter Real COP_util_32 = COP_util_33 * Cnnam_COP_n15_n7;
  parameter Real COP_util_42 = COP_util_43 * Cnnam_COP_n15_n7;
  parameter Real COP_util_52 = COP_util_53 * Cnnam_COP_n15_n7;
  parameter Real COP_util_62 = COP_util_63 * Cnnam_COP_n15_n7;
  
  Modelica.Blocks.Tables.CombiTable2Ds combiTable2D(fileName = chemin_fichier, table = [COP_util_11,COP_util_12, COP_util_13, COP_util_14, COP_util_15, COP_util_16; COP_util_21, COP_util_22, COP_util_23, COP_util_24, COP_util_25, COP_util_26; COP_util_31, COP_util_32, COP_util_33, COP_util_34, COP_util_35, COP_util_36; COP_util_41, COP_util_42, COP_util_43, COP_util_44, COP_util_45, COP_util_46; COP_util_51, COP_util_52, COP_util_53, COP_util_54, COP_util_55, COP_util_56; COP_util_61, COP_util_62, COP_util_63, COP_util_64, COP_util_65, COP_util_66], tableName = "table1", tableOnFile = Charger_fichier_nappe) annotation(
    Placement(visible = true, transformation(origin = {-14, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //parameter Real[6,6] Table=
  // [COP_11, COP_util_12, COP_util_13, COP_util_14, COP_util_15, COP_util_16 ;COP_util_22, COP_util_21,COP_util_23,COP_util_24,COP_util_25,COP_util_26;  COP_util_31, COP_util_32, COP_util_33, COP_util_34, COP_util_35; COP_util_36; COP_util_41, COP_util_42, COP_util_43, COP_util_44, COP_util_45, COP_util_46 ; COP_util_51, COP_util_52, COP_util_53; COP_util_54, COP_util_55, COP_util_56; COP_util_61, COP_util_62; COP_util_63, COP_util_64, COP_util_65, COP_util_66] ;
  Modelica.Blocks.Interfaces.RealInput Taval annotation(
    Placement(visible = true, transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Tamont annotation(
    Placement(visible = true, transformation(origin = {-120, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP annotation(
    Placement(visible = true, transformation(origin = {108, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

if Statut_valeurs_Cop == 1 then
 COP = combiTable2D.y;
elseif Statut_valeurs_Cop == 2 then 
 COP = 0.9 * combiTable2D.y;
else COP = 0.8 * combiTable2D.y;
end if;




  connect(Taval, combiTable2D.u1) annotation(
    Line(points = {{-120, 46}, {-76, 46}, {-76, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(Tamont, combiTable2D.u2) annotation(
    Line(points = {{-120, -14}, {-78, -14}, {-78, 4}, {-26, 4}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {0, 2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 36}, {100, -36}})}),
  Documentation(info = "<html><head></head><body>Ce modèle permet de calculer le COP de la PAC en prenant comme entrées les températures amont et aval de la pompe à chaleur.<div><br></div><div><u><font size=\"4\"><b>Paramètres :</b></font></u></div><div><ul><li><b>Charger_fichier_nappe</b>&nbsp;: un paramètre boolean qui prend true quand on souahite fournir un fichier txt pour la nappe de COP et qui prend false quand on n'a pas acces aux information relatives à la pompe à chaleur.</li><li><b>Chemin</b>&nbsp;<b>fichier</b>&nbsp;: lien URL vers le fichier txt qu'on souhaite renseigner.</li><li><b>Pabs_pivot :&nbsp;</b>valeur du COP à renseigner pour une température amont à -1.5 °C et une température aval de 32.5 °C.</li></ul></div></body></html>"));
end Remplissage_COP;
