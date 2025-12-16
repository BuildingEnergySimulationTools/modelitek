within Modelitek.Hvac.HeatPumps;

model HPmatrix

  import Modelitek.Hvac.HeatPumps.HPData;
  
  parameter HPData.AirWater_inf100kW cfg;
   
  Real COP_pc;
  Real P_abs_pc;
  Real P_comp_pc;
  Real P_fou_pc;
  Real LR;
  Real P_aux;
  
  Real COP_lr;
  Real P_abs_lr;
  Real P_comp_lr;
  
  parameter Real COP_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55COPMatrix(
      Pivot=cfg.COP_pivot, 
      Temp_aval=cfg.t_aval_rec_cop,
      Temp_amont=cfg.t_amont_rec_cop,
      Cnnav=cfg.Cnnav_cop,
      Cnnam=cfg.Cnnam_cop, 
      userData=cfg.userData_cop);
      
  parameter Real Pabs_cop_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55COPMatrix(
      Pivot=cfg.Pabs_pivot_cop, 
      Temp_aval=cfg.t_aval_rec_cop,
      Temp_amont=cfg.t_amont_rec_cop, 
      Cnnav=cfg.Cnnav_pabs_cop,
      Cnnam=cfg.Cnnam_pabs_cop,
      userData=cfg.userData_pabs_cop);
      
   parameter Real EER_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55EERMatrix(
      Pivot=cfg.eer_pivot, 
      Temp_aval=cfg.t_aval_rec_eer,
      Temp_amont=cfg.t_amont_rec_eer,
      Cnnav=cfg.Cnnav_eer,
      Cnnam=cfg.Cnnam_eer, 
      userData=cfg.userData_eer);
      
  parameter Real Pabs_eer_M[6,6] = 
      Modelitek.Hvac.HeatPumps.BaseFunctions.compute55EERMatrix(
      Pivot=cfg.Pabs_pivot_eer,
      Temp_aval=cfg.t_aval_rec_eer,
      Temp_amont=cfg.t_amont_rec_eer, 
      Cnnav=cfg.Cnnav_pabs_eer,
      Cnnam=cfg.Cnnam_pabs_eer,
      userData=cfg.userData_pabs_eer);

  Modelica.Blocks.Tables.CombiTable2Ds COP_combi(table=COP_M) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable2Ds Pabs_cop_combi(table=Pabs_cop_M) annotation(
    Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput t_aval annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput t_amont annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-108, 34}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput P_fou annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Q_req annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -76}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Tables.CombiTable2Ds EER_combi(table = EER_M) annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable2Ds Pabs_eer_combi(table = Pabs_eer_M) annotation(
    Placement(transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanInput Heating annotation(
    Placement(transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -22}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput COP annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
equation

  if Heating == true
  // From here everything is COP and P_abs. Not EER which is the same thing
  then
    COP_pc = COP_combi.y;
    P_abs_pc = Pabs_cop_combi.y;
  else
    COP_pc = EER_combi.y;
    P_abs_pc = Pabs_eer_combi.y;
  end if;
        
  P_fou_pc = COP_pc * P_abs_pc;  
  P_fou = min(P_fou_pc, Q_req);
  
  LR = P_fou / P_fou_pc;
  
  P_aux = P_abs_pc * cfg.Taux;
  P_comp_pc = P_abs_pc - P_aux;

  (P_comp_lr, P_abs_lr, COP_lr) = Modelitek.Hvac.HeatPumps.BaseFunctions.computePartLoad(
      LR            = LR,
      LRcontmin     = cfg.LRcontmin,
      COP_pc        = COP_pc,
      P_fou         = P_fou,
      P_fou_pc      = P_fou_pc,
      P_abs_pc      = P_abs_pc,
      P_comp_pc     = P_comp_pc,
      P_aux         = P_aux,
      CcpLRcontmin  = cfg.CcpLRcontmin,
      Deq           = cfg.Deq,
      Dfou0         = cfg.Dfou0
  );
  
  COP = COP_lr;
  
  connect(t_aval, COP_combi.u1);
  connect(t_aval, Pabs_cop_combi.u1);
  connect(t_aval, EER_combi.u1);
  connect(t_aval, Pabs_eer_combi.u1);
  connect(t_amont, COP_combi.u2);
  connect(t_amont, Pabs_cop_combi.u2);
  connect(t_amont, EER_combi.u2);
  connect(t_amont, Pabs_eer_combi.u2);
  
end HPmatrix;
