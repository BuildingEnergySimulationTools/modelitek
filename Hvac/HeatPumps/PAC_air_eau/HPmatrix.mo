within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model HPmatrix
  parameter Real COP_pivot = 2.81;
  parameter Real Pabs_pivot = 1000;
  parameter Real userData_cop[5,5] = zeros(5,5);
  parameter Real userData_pabs[5,5] = zeros(5,5);
  parameter Real Taux = 0.02;
  parameter Real Dfou0 = 12;
  parameter Real LRcontmin = 0.4; //Taux minimal de charge en fonctionnement continu. (= 1 si machine tout ou rien)
  parameter Real CcpLRcontmin = 1.; //Coefficient de correction de la performance pour un taux de charge égal à LRcontmin

  parameter Real Deq = 0.5;
  parameter Real Cnnav_cop[4] = {0.8, 0.8, 1.1, 0.8};
  parameter Real Cnnam_cop[4] = {0.5, 0.8, 1.25, 0.8};
  parameter Real Cnnav_pabs[4] = {0.9, 0.915, 1.09, 0.91};
  parameter Real Cnnam_pabs[4] = {0.86, 0.95, 1.13, 0.92};
  parameter Real t_amont_rec[5] = {-15., -7., 2., 7., 20.};
  parameter Real t_aval_rec[5] = {23.5, 32.5, 42.5, 51., 60.};
  
  Real P_fou_pc;
  Real LR;
  Real P_comp_pc;
  Real P_aux;
  Real P_comp_lr;
  Real P_abs_lr;
  Real COP_lr;
  Real CCP_lr_contmin_net;
  
  parameter Real COP_M[6,6] = 
      compute55EffMatrix(Pivot=COP_pivot, Temp_aval=t_aval_rec,Temp_amont=t_amont_rec, Cnnav=Cnnav_cop, Cnnam=Cnnam_cop, userData=userData_cop);
      
  parameter Real Pabs_M[6,6] = 
      compute55EffMatrix(Pivot=Pabs_pivot, Temp_aval=t_aval_rec,Temp_amont=t_amont_rec, Cnnav=Cnnav_pabs, Cnnam=Cnnam_pabs, userData=userData_pabs);

  Modelica.Blocks.Tables.CombiTable2Ds COP_combi(table=COP_M) annotation(
    Placement(transformation(origin = {0, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable2Ds Pabs_combi(table=Pabs_M) annotation(
    Placement(transformation(origin = {0, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput t_aval annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-106, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput t_amont annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput P_fou annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Q_req annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-106, -66}, extent = {{-20, -20}, {20, 20}})));
equation
  P_fou_pc = COP_combi.y * Pabs_combi.y;
  P_fou = min(P_fou_pc, Q_req);
  
  LR = P_fou / P_fou_pc;
  
  P_aux = Pabs_combi.y * Taux;
  P_comp_pc = Pabs_combi.y - P_aux;


  CCP_lr_contmin_net =
      LRcontmin * P_comp_pc * CcpLRcontmin /
      (LRcontmin*Pabs_combi.y - CcpLRcontmin*P_aux);


  (P_comp_lr, P_abs_lr, COP_lr) = computePartLoad(
      LR            = LR,
      LRcontmin     = LRcontmin,
      COP_pc           = COP_combi.y,
      P_fou         = P_fou,
      P_fou_pc      = P_fou_pc,
      P_abs_pc      = Pabs_combi.y,
      P_comp_pc     = P_comp_pc,
      P_aux         = P_aux,
      CcpLRcontmin  = CcpLRcontmin,
      Deq           = Deq,
      Dfou0         = Dfou0
  );

  
  connect(t_aval, COP_combi.u1) annotation(
    Line(points = {{-120, -40}, {-64, -40}, {-64, 50}, {-12, 50}}, color = {0, 0, 127}));
  connect(t_aval, Pabs_combi.u1) annotation(
    Line(points = {{-120, -40}, {-64, -40}, {-64, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(t_amont, COP_combi.u2) annotation(
    Line(points = {{-120, 60}, {-78, 60}, {-78, 38}, {-12, 38}}, color = {0, 0, 127}));
  connect(t_amont, Pabs_combi.u2) annotation(
    Line(points = {{-120, 60}, {-78, 60}, {-78, -12}, {-12, -12}}, color = {0, 0, 127}));
end HPmatrix;
