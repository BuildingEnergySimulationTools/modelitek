within Modelitek.Hvac.HeatPumps;

model HPmatrix

  import Modelitek.Hvac.HeatPumps.HPData;
  import SI = Modelica.Units.SI;
  
  parameter HPData.AirWater_inf100kW cfg;
   
  Real COP_pc(unit="1") "Full Load Coefficient of performance";
  SI.Power P_abs_pc "Absorbed electric power at full load. Compressor + Auxiliary";
  SI.Power P_comp_pc "Compressor absorbed electric power at full load";
  SI.Power P_fou_pc "Heating or cooling power at full load";
  Real LR(min=0, max=1) "Ratio of full load power";
  SI.Power P_aux "Auxiliary electric power";
  
  Real COP_lr(unit="1") "Coefficient Of Perfomance at current load";
  SI.Power P_abs_lr "Absorbed electric power at current load. Compressor + Auxiliary";
  SI.Power P_comp_lr "Compressor absorbed electric power at current load.";
  
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
  Modelica.Blocks.Tables.CombiTable2Ds EER_combi(table = EER_M) annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable2Ds Pabs_eer_combi(table = Pabs_eer_M) annotation(
    Placement(transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Interfaces.RealInput t_aval(unit="C") annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-160, 82}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput t_amont(unit="C") annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-160, 36}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput P_fou(unit="W") annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Q_req(unit="W") annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-162, -74}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput Heating annotation(
    Placement(transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-162, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput COP(unit="1") annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {150, 60}, extent = {{-10, -10}, {10, 10}})));
equation

  // From here everything is COP and P_abs. Not EER which is the same thing
  if noEvent(Heating) then
    COP_pc   = COP_combi.y;
    P_abs_pc = Pabs_cop_combi.y;
  else
    COP_pc   = EER_combi.y;
    P_abs_pc = Pabs_eer_combi.y;
  end if;

        
  P_fou_pc = COP_pc * P_abs_pc;  
  P_fou = min(P_fou_pc, Q_req);
  
  // Load ratio with protection against 0 division
  LR = if P_fou_pc > Modelica.Constants.eps then
        P_fou / P_fou_pc
       else
        0;
        
          
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
  
annotation(
    Icon(graphics = {Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-140, -100}, {140, 100}}), Rectangle(origin = {-101, 3}, fillColor = {255, 2, 2}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Rectangle(origin = {100, 3}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-15, 85}, {15, -85}}), Line(origin = {4.50808, 70.814}, points = {{-90.186, 3.18599}, {79.814, 3.18599}, {79.814, 3.18599}}), Ellipse(origin = {3, -51}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}), Line(origin = {53, -52}, points = {{-31, 0}, {31, 0}, {31, 0}}), Line(origin = {-51, -52}, points = {{35, 0}, {-35, 0}, {-35, 0}}), Polygon(origin = {-8, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{-12, 10}, {-12, -10}, {12, 0}, {12, 0}, {-12, 10}}), Polygon(origin = {15, 74}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{11, 10}, {11, -10}, {-11, 0}, {11, 10}, {11, 10}})}, coordinateSystem(extent = {{-140, 100}, {140, -100}})));
end HPmatrix;
