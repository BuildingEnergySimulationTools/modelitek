within Modelitek.Hvac.HeatPumps.Inverter.BaseClasses;

model Remplissage_Pabs

  parameter Integer Statut_valeurs_Pabs = 3 "1 : Certifiées, 2: Justifiées, 3: Par défaut";
  parameter Boolean Charger_fichier_nappe = true;
  parameter String chemin_fichier ="";
  
  parameter Real  Pabs_pivot = 3830 ;
   protected
  parameter Real Cnnav_Pabs_42_32 = 0.9;
  parameter Real Cnnav_Pabs_51_42 = 0.915;
  parameter Real Cnnav_Pabs_23_32 = 1.09;
  parameter Real Cnnav_Pabs_60_51 = 0.91;
  parameter Real Cnnam_Pabs_n7_7 = 0.86;
  parameter Real Cnnam_Pabs_2_7 = 0.95;
  parameter Real Cnnam_Pabs_20_7 = 1.13;
  parameter Real Cnnam_Pabs_n15_n7 = 0.92;
  
  parameter Real Pabs_util_11 = 0;
  parameter Real Pabs_11 = 0;
  parameter Real Pabs_util_12 = -12.5;
  parameter Real Pabs_util_13 = -7;
  parameter Real Pabs_util_14 = 2;
  parameter Real Pabs_util_15 = 7;
  parameter Real Pabs_util_16 = 20;
  parameter Real Pabs_util_21 = 23.5;
  parameter Real Pabs_util_31 = 32.5;
  parameter Real Pabs_util_41 = 42.5;
  parameter Real Pabs_util_51 = 51;
  parameter Real Pabs_util_61 = 60;
  public
  
  parameter Real Pabs_util_35 = Pabs_pivot;
  parameter Real Pabs_util_25 = Pabs_pivot * Cnnav_Pabs_23_32;
  parameter Real Pabs_util_45 = Pabs_pivot * Cnnav_Pabs_42_32;
  parameter Real Pabs_util_55 = Pabs_util_45 * Cnnav_Pabs_51_42;
  parameter Real Pabs_util_65 = Pabs_util_55 * Cnnav_Pabs_60_51;
  
  parameter Real Pabs_util_23 = Pabs_util_25 * Cnnam_Pabs_n7_7;
  parameter Real Pabs_util_33 = Pabs_util_35 * Cnnam_Pabs_n7_7;
  parameter Real Pabs_util_43 = Pabs_util_45 * Cnnam_Pabs_n7_7;
  parameter Real Pabs_util_53 = Pabs_util_55 * Cnnam_Pabs_n7_7;
  parameter Real Pabs_util_63 = Pabs_util_65 * Cnnam_Pabs_n7_7;
  
  parameter Real Pabs_util_24 = Pabs_util_25 * Cnnam_Pabs_2_7;
  parameter Real Pabs_util_34 = Pabs_util_35 * Cnnam_Pabs_2_7;
  parameter Real Pabs_util_44 = Pabs_util_45 * Cnnam_Pabs_2_7;
  parameter Real Pabs_util_54 = Pabs_util_55 * Cnnam_Pabs_2_7;
  parameter Real Pabs_util_64 = Pabs_util_65 * Cnnam_Pabs_2_7;
  
  parameter Real Pabs_util_26 = Pabs_util_25 * Cnnam_Pabs_20_7;
  parameter Real Pabs_util_36 = Pabs_util_35 * Cnnam_Pabs_20_7;
  parameter Real Pabs_util_46 = Pabs_util_45 * Cnnam_Pabs_20_7;
  parameter Real Pabs_util_56 = Pabs_util_55 * Cnnam_Pabs_20_7;
  parameter Real Pabs_util_66 = Pabs_util_65 * Cnnam_Pabs_20_7;
  
  parameter Real Pabs_util_22 = Pabs_util_23 * Cnnam_Pabs_n15_n7;
  parameter Real Pabs_util_32 = Pabs_util_33 * Cnnam_Pabs_n15_n7;
  parameter Real Pabs_util_42 = Pabs_util_43 * Cnnam_Pabs_n15_n7;
  parameter Real Pabs_util_52 = Pabs_util_53 * Cnnam_Pabs_n15_n7;
  parameter Real Pabs_util_62 = Pabs_util_63 * Cnnam_Pabs_n15_n7;
  
  Modelica.Blocks.Tables.CombiTable2Ds combiTable2D(fileName = chemin_fichier,table = [Pabs_util_11, Pabs_util_12, Pabs_util_13, Pabs_util_14, Pabs_util_15, Pabs_util_16; Pabs_util_21, Pabs_util_22, Pabs_util_23, Pabs_util_24, Pabs_util_25, Pabs_util_26; Pabs_util_31, Pabs_util_32, Pabs_util_33, Pabs_util_34, Pabs_util_35, Pabs_util_36; Pabs_util_41, Pabs_util_42, Pabs_util_43, Pabs_util_44, Pabs_util_45, Pabs_util_46; Pabs_util_51, Pabs_util_52, Pabs_util_53, Pabs_util_54, Pabs_util_55, Pabs_util_56; Pabs_util_61, Pabs_util_62, Pabs_util_63, Pabs_util_64, Pabs_util_65, Pabs_util_66], tableName = "table1", tableOnFile = Charger_fichier_nappe) annotation(
    Placement(visible = true, transformation(origin = {-14, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //parameter Real[6,6] Table=
  // [Pabs_11, Pabs_util_12, Pabs_util_13, Pabs_util_14, Pabs_util_15, Pabs_util_16 ;Pabs_util_22, Pabs_util_21,Pabs_util_23,Pabs_util_24,Pabs_util_25,Pabs_util_26;  Pabs_util_31, Pabs_util_32, Pabs_util_33, Pabs_util_34, Pabs_util_35; Pabs_util_36; Pabs_util_41, Pabs_util_42, Pabs_util_43, Pabs_util_44, Pabs_util_45, Pabs_util_46 ; Pabs_util_51, Pabs_util_52, Pabs_util_53; Pabs_util_54, Pabs_util_55, Pabs_util_56; Pabs_util_61, Pabs_util_62; Pabs_util_63, Pabs_util_64, Pabs_util_65, Pabs_util_66] ;
  Modelica.Blocks.Interfaces.RealInput Taval annotation(
    Placement(visible = true, transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Tamont annotation(
    Placement(visible = true, transformation(origin = {-120, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Pabs annotation(
    Placement(visible = true, transformation(origin = {110, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

if Statut_valeurs_Pabs == 1 then
 Pabs = combiTable2D.y;
elseif Statut_valeurs_Pabs == 2 then 
 Pabs = 0.9 * combiTable2D.y;
else Pabs = 0.8 * combiTable2D.y;
end if;




  connect(Taval, combiTable2D.u1) annotation(
    Line(points = {{-120, 46}, {-76, 46}, {-76, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(Tamont, combiTable2D.u2) annotation(
    Line(points = {{-120, -14}, {-78, -14}, {-78, 4}, {-26, 4}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, 2}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 36}, {100, -36}})}),
    Documentation(info = "<html><head></head><body>Ce modèle permet de calculer la puissance absorbée par l'évaporateur de la PAC en mode chaud en prenant comme entrées les températures amont et aval de la pompe à chaleur.<div><br></div><div><u><font size=\"4\"><b>Paramètres :</b></font></u></div><div><ul><li><b>Charger_fichier_nappe</b>&nbsp;: un paramètre boolean qui prend true quand on souahite fournir un fichier txt pour la nappe de Pabs et qui prend false quand on n'a pas acces aux information relatives à la pompe à chaleur.</li><li><b>Chemin</b>&nbsp;<b>fichier</b>&nbsp;: lien URL vers le fichier txt qu'on souhaite renseigner.</li><li><b>Pabs_pivot :&nbsp;</b>valeur du Pabs à renseigner pour une température amont à -1.5 °C et une température aval de 32.5 °C.</li></ul></div><div><u><font size=\"4\"><b><br></b></font></u></div></body></html>"));
end Remplissage_Pabs;
