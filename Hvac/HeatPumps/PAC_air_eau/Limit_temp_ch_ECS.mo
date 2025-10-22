within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Limit_temp_ch_ECS
  parameter Real Theta_max_av(unit = "degC") = 65;
  //Température max départ avale
  parameter Real Theta_min_am(unit = "degC") = -10;
  //Température min amont
  Modelica.Blocks.Interfaces.RealOutput Pfou_pc annotation(
    Placement(visible = true, transformation(origin = {285, 147}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pfou_pc_brut annotation(
    Placement(visible = true, transformation(origin = {-133, 137}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Qres_ch annotation(
    Placement(visible = true, transformation(origin = {287, 71}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Theta_max_av_output(k = Theta_max_av) annotation(
    Placement(visible = true, transformation(origin = {-104, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Theta_min_am_output(k = Theta_min_am) annotation(
    Placement(visible = true, transformation(origin = {-107, 43}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {-36, 63}, extent = {{-8, -9}, {8, 9}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {-32, -19}, extent = {{-8, -9}, {8, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_amont annotation(
    Placement(visible = true, transformation(origin = {-133, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_aval annotation(
    Placement(visible = true, transformation(origin = {-133, 7}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, -86}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {225, 71}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {46, 82}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {8, 36}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {127, 145}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Pfou_pc_0(k = 0) annotation(
    Placement(visible = true, transformation(origin = {44, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {134, -6}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {173, -3}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {146, 44}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput Lim_Theta annotation(
    Placement(visible = true, transformation(origin = {-66, 120}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-5, 113}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Q_req_act annotation(
    Placement(visible = true, transformation(origin = {85, 103}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-1, -113}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
equation
  connect(Pfou_pc_brut, switch1.u3) annotation(
    Line(points = {{-132, 138}, {-7, 138}, {-7, 140}, {118, 140}}, color = {0, 0, 127}));
  connect(Pfou_pc_0.y, switch1.u1) annotation(
    Line(points = {{55, 162}, {106, 162}, {106, 150}, {118, 150}}, color = {0, 0, 127}));
  connect(switch1.y, Pfou_pc) annotation(
    Line(points = {{134, 146}, {188, 146}, {188, 147}, {285, 147}}, color = {0, 0, 127}));
  connect(T_amont, lessEqual.u1) annotation(
    Line(points = {{-132, 82}, {-74, 82}, {-74, 64}, {-46, 64}}, color = {0, 0, 127}));
  connect(Theta_min_am_output.y, lessEqual.u2) annotation(
    Line(points = {{-98, 44}, {-72, 44}, {-72, 56}, {-46, 56}}, color = {0, 0, 127}));
  connect(T_aval, greaterEqual.u1) annotation(
    Line(points = {{-132, 8}, {-68, 8}, {-68, -18}, {-42, -18}}, color = {0, 0, 127}));
  connect(Theta_max_av_output.y, greaterEqual.u2) annotation(
    Line(points = {{-96, -34}, {-68, -34}, {-68, -26}, {-42, -26}}, color = {0, 0, 127}));
  connect(lessEqual.y, or1.u1) annotation(
    Line(points = {{-28, 64}, {-12, 64}, {-12, 36}, {0, 36}}, color = {255, 0, 255}));
  connect(greaterEqual.y, or1.u2) annotation(
    Line(points = {{-24, -18}, {-12, -18}, {-12, 32}, {0, 32}}, color = {255, 0, 255}));
  connect(switch.y, Qres_ch) annotation(
    Line(points = {{233, 71}, {287, 71}}, color = {0, 0, 127}));
  connect(constant1.y, max.u2) annotation(
    Line(points = {{141, -6}, {144, -6}, {144, -7}, {165, -7}}, color = {0, 0, 127}));
  connect(or1.y, and1.u2) annotation(
    Line(points = {{14, 36}, {32, 36}, {32, 77}, {39, 77}}, color = {255, 0, 255}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{53, 82}, {82, 82}, {82, 71}, {217, 71}}, color = {255, 0, 255}));
  connect(max.y, switch.u3) annotation(
    Line(points = {{181, -3}, {204, -3}, {204, 65}, {217, 65}}, color = {0, 0, 127}));
  connect(add.y, max.u1) annotation(
    Line(points = {{146, 37}, {146, 2}, {164, 2}}, color = {0, 0, 127}));
  connect(Lim_Theta, and1.u1) annotation(
    Line(points = {{-66, 120}, {32, 120}, {32, 82}, {38, 82}}, color = {255, 0, 255}));
  connect(Q_req_act, add.u2) annotation(
    Line(points = {{86, 104}, {142, 104}, {142, 52}}, color = {0, 0, 127}));
  connect(Q_req_act, switch.u1) annotation(
    Line(points = {{86, 104}, {142, 104}, {142, 76}, {216, 76}}, color = {0, 0, 127}));
  connect(and1.y, switch1.u2) annotation(
    Line(points = {{52, 82}, {64, 82}, {64, 146}, {118, 146}}, color = {255, 0, 255}));
  connect(switch1.y, add.u1) annotation(
    Line(points = {{134, 146}, {148, 146}, {148, 52}, {150, 52}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 180}, {300, -60}})),
    Icon(graphics = {Rectangle(fillColor = {255, 149, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end Limit_temp_ch_ECS;
