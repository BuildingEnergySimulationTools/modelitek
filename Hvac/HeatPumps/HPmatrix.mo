within Modelitek.Hvac.HeatPumps;

model HPmatrix

  import Modelitek.Hvac.HeatPumps.HPData;
  
  parameter HPData.AirWater_inf100kW cfg;
    
  Real P_fou_pc;
  Real LR;
  Real P_comp_pc;
  Real P_aux;
  
  Real P_comp_lr;
  Real P_abs_lr;
  Real COP_lr;
  
  parameter Real COP_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55EffMatrix(
      Pivot=cfg.COP_pivot, 
      Temp_aval=cfg.t_aval_rec,
      Temp_amont=cfg.t_amont_rec,
      Cnnav=cfg.Cnnav_cop,
      Cnnam=cfg.Cnnam_cop, 
      userData=cfg.userData_cop);
      
  parameter Real Pabs_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55EffMatrix(
      Pivot=cfg.Pabs_pivot, 
      Temp_aval=cfg.t_aval_rec,
      Temp_amont=cfg.t_amont_rec, 
      Cnnav=cfg.Cnnav_pabs,
      Cnnam=cfg.Cnnam_pabs,
      userData=cfg.userData_pabs);

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
  
  P_aux = Pabs_combi.y * cfg.Taux;
  P_comp_pc = Pabs_combi.y - P_aux;

  (P_comp_lr, P_abs_lr, COP_lr) = Modelitek.Hvac.HeatPumps.BaseFunctions.computePartLoad(
      LR            = LR,
      LRcontmin     = cfg.LRcontmin,
      COP_pc        = COP_combi.y,
      P_fou         = P_fou,
      P_fou_pc      = P_fou_pc,
      P_abs_pc      = Pabs_combi.y,
      P_comp_pc     = P_comp_pc,
      P_aux         = P_aux,
      CcpLRcontmin  = cfg.CcpLRcontmin,
      Deq           = cfg.Deq,
      Dfou0         = cfg.Dfou0
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
