within Modelitek.Hvac.HeatPumps;

model CascadeHP
  
  import Modelitek.Hvac.HeatPumps.HPData;
  
  parameter Integer n_hp = 1 "Nombre de pompes à chaleur en cascade";
  parameter HPData.AirWater_inf100kW cfg "Configuration des PAC";
  
  // Création d'un tableau de n_hp pompes à chaleur
  HPmatrix HP[n_hp](each cfg=cfg);
  
  // Interfaces externes
  Modelica.Blocks.Interfaces.RealInput Q_req annotation(
    Placement(transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-112, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_amont annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-120, 22}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_aval annotation(
    Placement(transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-108, -42}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput heating annotation(
    Placement(transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-114, -22}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput P_fou annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), 
    iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}})));
  
  // Variables internes
  Real Q_remaining[n_hp] "Demande énergétique restante pour chaque PAC";
  Real COP_cascade "Cop général de la cascade";
  Real P_abs_total "Pabs total";
  
equation
  
  // Distribution en cascade de la demande énergétique
  for i in 1:n_hp loop
    
    // Connexion des entrées communes à toutes les PAC
    connect(T_amont, HP[i].t_amont);
    connect(T_aval, HP[i].t_aval);
    connect(heating, HP[i].Heating);
    
    // Calcul de la demande restante pour chaque PAC
    if i == 1 then
      Q_remaining[i] = Q_req;
    else
      Q_remaining[i] = max(0, Q_remaining[i-1] - HP[i-1].P_fou);
    end if;
    
    // Attribution de la demande à chaque PAC
    HP[i].Q_req = Q_remaining[i];
    
  end for;
  
  // Calcul de la puissance fournie totale
  P_fou = sum(HP[i].P_fou for i in 1:n_hp);
  
  // Calcul de la puissance absorbée totale
  P_abs_total = sum(HP[i].P_abs_lr for i in 1:n_hp);
  
  // Calcul du COP moyen pondéré
  if P_abs_total > 0 then
    COP_cascade = P_fou / P_abs_total;
  else
    COP_cascade = 0;
  end if;
  
end CascadeHP;
