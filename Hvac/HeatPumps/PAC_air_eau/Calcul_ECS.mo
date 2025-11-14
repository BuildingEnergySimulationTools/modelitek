within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Calcul_ECS
  parameter Real Taux;
  //ratio puissance auxiliaire à charge nulle sur la puissance absorbée à plein charge au point pivot
  Real Waux_0;
  //Puissance des auxiliaires à charge nulle
  Real P_abs_LR_1;
  Modelica.Blocks.Math.Min P_fou_LR_1 annotation(
    Placement(visible = true, transformation(origin = {-53, -15}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_fou_PC annotation(
    Placement(visible = true, transformation(origin = {-128, 14}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, -2}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch LR annotation(
    Placement(visible = true, transformation(origin = {45, -5}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-2, 30}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {1, -23}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_req_act annotation(
    Placement(visible = true, transformation(origin = {-130, -36}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, -82}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {-1, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_abs_pc annotation(
    Placement(visible = true, transformation(origin = {-127, 57}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput I_ECS_seule annotation(
    Placement(visible = true, transformation(origin = {-5, 113}, extent = {{-13, -13}, {13, 13}}, rotation = -90), iconTransformation(origin = {-4, 112}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput P_abs_LR annotation(
    Placement(visible = true, transformation(origin = {116, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_fou_LR annotation(
    Placement(visible = true, transformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-108, 32}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-81, 1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {0, -64}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {32, -82}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-38, -106}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {61, -111}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_res_ECS annotation(
    Placement(visible = true, transformation(origin = {109, -87}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch P_abs_pc_0 annotation(
    Placement(visible = true, transformation(origin = {25, 67}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP_LR annotation(
    Placement(visible = true, transformation(origin = {118, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, 14}, {120, 34}}, rotation = 0)));
equation
  Waux_0 = Taux * P_abs_pc;
  P_abs_LR_1 = P_abs_pc_0.y + (1 - LR.y) * Waux_0;

  if I_ECS_seule == false then
    COP_LR = 0;
    else
    COP_LR = P_fou_LR / P_abs_pc_0.y;
  end if;
    
  if I_ECS_seule == true and P_abs_LR_1>P_fou_LR then
    P_abs_LR = P_fou_LR; 
    elseif I_ECS_seule == true and P_abs_LR<P_fou_LR then
    P_abs_LR = P_abs_LR_1;
    else 
    P_abs_LR = 0;
  end if;
  
  connect(lessEqualThreshold.y, LR.u2) annotation(
    Line(points = {{4.5, 3}, {18, 3}, {18, -5}, {37, -5}}, color = {255, 0, 255}));
  connect(P_fou_LR_1.y, division.u1) annotation(
    Line(points = {{-40.9, -15}, {-28.9, -15}, {-28.9, -19}, {-7, -19}}, color = {0, 0, 127}));
  connect(division.y, LR.u3) annotation(
    Line(points = {{9, -23}, {18.7, -23}, {18.7, -12}, {37.7, -12}}, color = {0, 0, 127}));
  connect(const.y, LR.u1) annotation(
    Line(points = {{4.6, 30}, {21.6, 30}, {21.6, 1}, {36.6, 1}}, color = {0, 0, 127}));
  connect(P_fou_PC, lessEqualThreshold.u) annotation(
    Line(points = {{-128, 14}, {-12, 14}, {-12, 3}, {-7, 3}}, color = {0, 0, 127}));
  connect(P_fou_LR_1.y, P_fou_LR) annotation(
    Line(points = {{-40, -14}, {-30, -14}, {-30, -48}, {110, -48}}, color = {0, 0, 127}));
  connect(P_fou_PC, division.u2) annotation(
    Line(points = {{-128, 14}, {-22, 14}, {-22, -27}, {-7, -27}}, color = {0, 0, 127}));
  connect(Q_req_act, P_fou_LR_1.u2) annotation(
    Line(points = {{-130, -36}, {-82, -36}, {-82, -22}, {-66, -22}}, color = {0, 0, 127}));
  connect(lessEqualThreshold.y, switch.u2) annotation(
    Line(points = {{4, 4}, {-62, 4}, {-62, 10}, {-112, 10}, {-112, 1}, {-87, 1}}, color = {255, 0, 255}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{-102, 32}, {-100, 32}, {-100, 6}, {-86, 6}}, color = {0, 0, 127}));
  connect(P_fou_PC, switch.u3) annotation(
    Line(points = {{-128, 14}, {-100, 14}, {-100, -2}, {-86, -2}}, color = {0, 0, 127}));
  connect(switch.y, P_fou_LR_1.u1) annotation(
    Line(points = {{-76, 2}, {-72, 2}, {-72, -8}, {-66, -8}}, color = {0, 0, 127}));
  connect(add.y, max.u1) annotation(
    Line(points = {{39, -82}, {39, -101.5}, {53, -101.5}, {53, -107}}, color = {0, 0, 127}));
  connect(constant2.y, max.u2) annotation(
    Line(points = {{-31, -106}, {-22.4, -106}, {-22.4, -115}, {53, -115}}, color = {0, 0, 127}));
  connect(P_fou_PC, gain.u) annotation(
    Line(points = {{-128, 14}, {-22, 14}, {-22, -64}, {-8, -64}}, color = {0, 0, 127}));
  connect(max.y, Q_res_ECS) annotation(
    Line(points = {{68, -110}, {80, -110}, {80, -86}, {110, -86}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{6, -64}, {14, -64}, {14, -78}, {24, -78}}, color = {0, 0, 127}));
  connect(Q_req_act, add.u2) annotation(
    Line(points = {{-130, -36}, {-82, -36}, {-82, -86}, {24, -86}}, color = {0, 0, 127}));
  connect(I_ECS_seule, P_abs_pc_0.u2) annotation(
    Line(points = {{-4, 114}, {-6, 114}, {-6, 67}, {14, 67}}, color = {255, 0, 255}));
  connect(P_abs_pc, P_abs_pc_0.u1) annotation(
    Line(points = {{-126, 58}, {-74, 58}, {-74, 74}, {14, 74}}, color = {0, 0, 127}));
  connect(const.y, P_abs_pc_0.u3) annotation(
    Line(points = {{4, 30}, {6, 30}, {6, 60}, {14, 60}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-140, 100}, {120, -120}})));
end Calcul_ECS;
