within Modelitek.Hvac.HeatPumps.PAC_air_eau;
model Limit_temp_refr
  parameter Real Theta_min_av = 5;
  // Température minimale aval
  parameter Real Theta_max_am = 40;
  // Température maximale amont
  //Activation de la limite sur les températures amont et/ou avale ("=false" non active, "=true" active)
  Modelica.Blocks.Interfaces.RealInput T_amont annotation(
    Placement(visible = true, transformation(origin = {-133, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {-52, 1}, extent = {{-8, -9}, {8, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_aval annotation(
    Placement(visible = true, transformation(origin = {-133, 7}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, -86}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {-52, 67}, extent = {{-8, -9}, {8, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Qres_ch annotation(
    Placement(visible = true, transformation(origin = {287, 71}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Pfou_pc_0(k = 0) annotation(
    Placement(visible = true, transformation(origin = {48, 166}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {74, -8}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {173, -3}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Theta_max_am_output(k = Theta_max_am) annotation(
    Placement(visible = true, transformation(origin = {-124, 52}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {146, 44}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {127, 145}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {8, 36}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {46, 82}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {152, 108}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {225, 71}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pfou_pc_brut annotation(
    Placement(visible = true, transformation(origin = {-133, 137}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-120, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Pfou_pc annotation(
    Placement(visible = true, transformation(origin = {309, 147}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {110, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Theta_min_av_output(k = Theta_min_av) annotation(
    Placement(visible = true, transformation(origin = {-103, -15}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput Lim_Theta annotation(
    Placement(visible = true, transformation(origin = {-66, 120}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-5, 113}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Q_req_act annotation(
    Placement(visible = true, transformation(origin = {85, 103}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {2, -114}, extent = {{-14, -14}, {14, 14}}, rotation = 90)));
equation
  connect(add.y, max.u1) annotation(
    Line(points = {{146, 37}, {146, 2}, {164, 2}}, color = {0, 0, 127}));
  connect(Pfou_pc_brut, switch1.u3) annotation(
    Line(points = {{-132, 138}, {-7, 138}, {-7, 140}, {118, 140}}, color = {0, 0, 127}));
  connect(or1.y, and1.u2) annotation(
    Line(points = {{14, 36}, {32, 36}, {32, 77}, {39, 77}}, color = {255, 0, 255}));
  connect(constant1.y, max.u2) annotation(
    Line(points = {{80, -8}, {144, -8}, {144, -7}, {165, -7}}, color = {0, 0, 127}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{53, 82}, {82, 82}, {82, 71}, {217, 71}}, color = {255, 0, 255}));
  connect(max.y, switch.u3) annotation(
    Line(points = {{181, -3}, {204, -3}, {204, 65}, {217, 65}}, color = {0, 0, 127}));
  connect(switch.y, Qres_ch) annotation(
    Line(points = {{233, 71}, {287, 71}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{134, 146}, {152, 146}, {152, 116}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{152, 102}, {150, 102}, {150, 52}}, color = {0, 0, 127}));
  connect(Pfou_pc_0.y, switch1.u1) annotation(
    Line(points = {{54, 166}, {106, 166}, {106, 150}, {118, 150}}, color = {0, 0, 127}));
  connect(Theta_min_av_output.y, lessEqual.u2) annotation(
    Line(points = {{-93, -15}, {-87.1, -15}, {-87.1, -7}, {-61.1, -7}}, color = {0, 0, 127}));
  connect(Theta_max_am_output.y, greaterEqual.u2) annotation(
    Line(points = {{-115.2, 52}, {-87.2, 52}, {-87.2, 60}, {-61.2, 60}}, color = {0, 0, 127}));
  connect(T_amont, greaterEqual.u1) annotation(
    Line(points = {{-132, 82}, {-88, 82}, {-88, 68}, {-62, 68}}, color = {0, 0, 127}));
  connect(greaterEqual.y, or1.u1) annotation(
    Line(points = {{-44, 68}, {-12, 68}, {-12, 36}, {0, 36}}, color = {255, 0, 255}));
  connect(T_aval, lessEqual.u1) annotation(
    Line(points = {{-132, 8}, {-88, 8}, {-88, 2}, {-62, 2}}, color = {0, 0, 127}));
  connect(lessEqual.y, or1.u2) annotation(
    Line(points = {{-44, 2}, {-12, 2}, {-12, 32}, {0, 32}}, color = {255, 0, 255}));
  connect(Lim_Theta, switch1.u2) annotation(
    Line(points = {{-66, 120}, {72, 120}, {72, 146}, {118, 146}}, color = {255, 0, 255}));
  connect(Lim_Theta, and1.u1) annotation(
    Line(points = {{-66, 120}, {20, 120}, {20, 82}, {38, 82}}, color = {255, 0, 255}));
  connect(switch1.y, Pfou_pc) annotation(
    Line(points = {{134, 146}, {218, 146}, {218, 148}, {310, 148}}, color = {0, 0, 127}));
  connect(Q_req_act, add.u2) annotation(
    Line(points = {{86, 104}, {134, 104}, {134, 78}, {142, 78}, {142, 52}}, color = {0, 0, 127}));
  connect(Q_req_act, switch.u1) annotation(
    Line(points = {{86, 104}, {134, 104}, {134, 76}, {216, 76}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 180}, {300, -60}})),
    Icon(graphics = {Rectangle(fillColor = {0, 251, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end Limit_temp_refr;
