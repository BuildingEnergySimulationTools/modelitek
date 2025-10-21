within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model LR
  Modelica.Blocks.Math.Min P_fou_LR_1 annotation(
    Placement(visible = true, transformation(origin = {-35, 11}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput LR annotation(
    Placement(visible = true, transformation(origin = {118, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {122, 64}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_fou_PC annotation(
    Placement(visible = true, transformation(origin = {-226, 50}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-125, 57}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {14, 70}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_req_act annotation(
    Placement(visible = true, transformation(origin = {-130, -14}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-124, -12}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {61, 35}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {15, 15}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_fou_LR annotation(
    Placement(visible = true, transformation(origin = {122, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {122, 0}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {-128, 98}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-69, 43}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold = 1) annotation(
    Placement(visible = true, transformation(origin = {31, -17}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {81, -15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.00001) annotation(
    Placement(visible = true, transformation(origin = {-105, 63}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput I_ECS_seule annotation(
    Placement(visible = true, transformation(origin = {-192, 102}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-4, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-141, 51}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qrest_act annotation(
    Placement(visible = true, transformation(origin = {-130, -58}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-124, -80}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_rest_act annotation(
    Placement(visible = true, transformation(origin = {122, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {122, -66}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {87, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  connect(switch1.y, LR) annotation(
    Line(points = {{68, 36}, {118, 36}}, color = {0, 0, 127}));
  connect(P_fou_LR_1.y, division.u1) annotation(
    Line(points = {{-23, 11}, {-9, 11}, {-9, 19}, {7, 19}}, color = {0, 0, 127}));
  connect(Q_req_act, P_fou_LR_1.u2) annotation(
    Line(points = {{-130, -14}, {-68, -14}, {-68, 4}, {-48, 4}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-63.5, 43}, {-4, 43}, {-4, 10}, {6, 10}}, color = {0, 0, 127}));
  connect(switch.y, P_fou_LR_1.u1) annotation(
    Line(points = {{-63.5, 43}, {-62, 43}, {-62, 18}, {-48, 18}}, color = {0, 0, 127}));
  connect(P_fou_LR_1.y, lessThreshold1.u) annotation(
    Line(points = {{-22, 12}, {-10, 12}, {-10, -16}, {26, -16}}, color = {0, 0, 127}));
  connect(lessThreshold1.y, switch2.u2) annotation(
    Line(points = {{36, -16}, {75, -16}, {75, -15}}, color = {255, 0, 255}));
  connect(P_fou_LR_1.y, switch2.u3) annotation(
    Line(points = {{-22, 12}, {-10, 12}, {-10, -30}, {75, -30}, {75, -19}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{21, 70}, {38, 70}, {38, 41}, {53, 41}}, color = {0, 0, 127}));
  connect(division.y, switch1.u3) annotation(
    Line(points = {{22, 16}, {34, 16}, {34, 29}, {53, 29}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{-128, 89}, {-84.4, 89}, {-84.4, 47}, {-75, 47}}, color = {0, 0, 127}));
  connect(lessThreshold.y, switch1.u2) annotation(
    Line(points = {{-99.5, 63}, {-12, 63}, {-12, 52}, {16, 52}, {16, 36}, {52, 36}}, color = {255, 0, 255}));
  connect(lessThreshold.y, switch.u2) annotation(
    Line(points = {{-99.5, 63}, {-94, 63}, {-94, 43}, {-75, 43}}, color = {255, 0, 255}));
  connect(const.y, switch2.u1) annotation(
    Line(points = {{20, 70}, {38, 70}, {38, -10}, {76, -10}}, color = {0, 0, 127}));
  connect(switch2.y, P_fou_LR) annotation(
    Line(points = {{86, -14}, {122, -14}}, color = {0, 0, 127}));
  connect(I_ECS_seule, switch3.u2) annotation(
    Line(points = {{-192, 102}, {-192, 52}, {-150, 52}}, color = {255, 0, 255}));
  connect(P_fou_PC, switch3.u3) annotation(
    Line(points = {{-226, 50}, {-168, 50}, {-168, 46}, {-150, 46}}, color = {0, 0, 127}));
  connect(constant1.y, switch3.u1) annotation(
    Line(points = {{-128, 89}, {-168, 89}, {-168, 56}, {-150, 56}}, color = {0, 0, 127}));
  connect(switch3.y, lessThreshold.u) annotation(
    Line(points = {{-134, 52}, {-122, 52}, {-122, 63}, {-111, 63}}, color = {0, 0, 127}));
  connect(switch3.y, switch.u3) annotation(
    Line(points = {{-134, 52}, {-122, 52}, {-122, 40}, {-74, 40}}, color = {0, 0, 127}));
  connect(lessThreshold1.y, switch4.u2) annotation(
    Line(points = {{36, -16}, {50, -16}, {50, -55}, {81, -55}}, color = {255, 0, 255}));
  connect(const.y, switch4.u1) annotation(
    Line(points = {{20, 70}, {40, 70}, {40, -51}, {81, -51}}, color = {0, 0, 127}));
  connect(Qrest_act, switch4.u3) annotation(
    Line(points = {{-130, -58}, {81, -58}, {81, -59}}, color = {0, 0, 127}));
  connect(switch4.y, Q_rest_act) annotation(
    Line(points = {{92, -54}, {122, -54}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {225, 225, 225}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-240, 120}, {140, -80}})));
end LR;
