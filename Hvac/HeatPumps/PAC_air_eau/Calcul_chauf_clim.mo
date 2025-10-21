within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Calcul_chauf_clim
  
  parameter Real LR_contmin(unit = "%") = 0.2;
  //taux de charge minimal que peut maintenir le générateur thermodynamique pour le mode considéré (0-1)
  parameter Real CCP_LRcontmin(unit = "%") = 1;
  //ratio du COP (ou EER) au taux de charge LRcontmin sur le COP (ou EER) à pleine charge
  parameter Real Taux(unit = "%") = 0.02;
  //ratio puissance auxiliaire à charge nulle sur la puissance absorbée à plein charge au point pivot
  parameter Real Deq(unit = "minutes") = 0.5;
  //la durée de fonctionnement à charge tendant vers 0
  Modelica.Blocks.Interfaces.RealInput P_abs_pc annotation(
    Placement(visible = true, transformation(origin = {-133, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Real Waux_0;
  //Puissance des auxiliaires à charge nulle
  Real P_comp_pc;
  //Puissance absorbée par le compresseur à pleine charge
  Real COP_pc_net;
  //COP calculé sur la base de la consommation hors auxiliaires à charge nulle
  Real CCP_LRcontmin_net;
  //La plage de fonctionnement continu est comprise entre un taux de charge égale à LRcontmin et la pleine charge (taux de charge de 100%). Au taux de charge LRcontmin, la majoration du COP par rapport au COP à pleine charge est égale à CCP_LRcontmin. le CCP_LRcontmin_net est la conversion du CCP_LRcontmin.
  Real COP_LR_net;
  //COP à charge partielle
  Real COP_LRcontmin_net;
  //COP à charge minimale du fonctionnement continu
  Real P_fou_LRcontmin, P_comp_LRcontmin;
  Real LR_cycle, LR_contmin_;
  Modelica.Blocks.Interfaces.RealInput P_fou_pc_brut annotation(
    Placement(visible = true, transformation(origin = {-135, 19}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 31}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_fou_LR annotation(
    Placement(visible = true, transformation(origin = {-135, -25}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-113, -79}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_abs_LR annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, 38}, {120, 58}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput LR annotation(
    Placement(visible = true, transformation(origin = {-135, -65}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -25}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP_LR annotation(
    Placement(visible = true, transformation(origin = {110, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, 72}, {120, 92}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Dfou0 annotation(
    Placement(visible = true, transformation(origin = {61, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput P_compma_LR annotation(
    Placement(visible = true, transformation(origin = {110, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, -12}, {120, 8}}, rotation = 0)));
  //Puissance absorbée par le compresseur à charge partielle
  Modelica.Blocks.Interfaces.RealOutput P_comp_LR annotation(
    Placement(visible = true, transformation(origin = {110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, -52}, {120, -32}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_fou_LR_Reel annotation(
    Placement(visible = true, transformation(origin = {110, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, -90}, {120, -70}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput Inverter annotation(
    Placement(visible = true, transformation(origin = {-70, 112}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-73, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
equation
 
  LR_contmin_ = LR_contmin;
  Waux_0 = Taux * P_abs_pc;
  P_comp_pc = P_abs_pc - Waux_0;
  COP_pc_net = P_fou_pc_brut / P_comp_pc;
  CCP_LRcontmin_net = LR_contmin_ * P_comp_pc * CCP_LRcontmin / (LR_contmin_ * P_abs_pc - CCP_LRcontmin * Waux_0);
  if LR <= 1 and LR >= LR_contmin_ then
    COP_LR_net = COP_pc_net * (1 + (CCP_LRcontmin_net - 1) * (1 - LR) / (1 - LR_contmin_));
    P_comp_LR = P_fou_LR / COP_LR_net;
    P_abs_LR = P_comp_LR + Waux_0;
    COP_LRcontmin_net = COP_LR_net;
    P_fou_LRcontmin = P_fou_LR;
    P_comp_LRcontmin = P_comp_LR;
    LR_cycle = LR;
    P_compma_LR = 0;
  else
    COP_LR_net = 0;
    P_fou_LRcontmin = P_fou_pc_brut * LR_contmin_;
    COP_LRcontmin_net = COP_pc_net * (1 + (CCP_LRcontmin_net - 1) * (1 - LR) / (1 - LR_contmin_));
// n'existe pas dans la doc technique : à vérifier
    P_comp_LRcontmin = P_fou_LRcontmin / COP_LRcontmin_net;
    P_comp_LR = P_comp_LRcontmin * (1 - (LR_contmin_ - LR) / LR_contmin_);
    LR_cycle = LR / LR_contmin_;
    P_compma_LR = P_comp_LRcontmin * (Deq * (LR_cycle * (1 - LR_cycle)) / Dfou0);
    P_abs_LR = P_comp_LR + P_compma_LR + Waux_0;
  end if;
  COP_LR = P_fou_LR / P_abs_LR;
  P_fou_LR_Reel = P_fou_LRcontmin;
  annotation(
    Icon(graphics = {Rectangle(fillColor = {229, 80, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end Calcul_chauf_clim;
