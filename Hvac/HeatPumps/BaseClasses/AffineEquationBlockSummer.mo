within Modelitek.Hvac.HeatPumps.BaseClasses;

model AffineEquationBlockSummer
  Modelica.Blocks.Interfaces.RealInput T_amont(final unit = "K", displayUnit = "degC") "Set point for leaving fluid temperature at port b1" annotation(
    Placement(visible = true, transformation(extent = {{-124, -14}, {-84, 26}}, rotation = 0), iconTransformation(extent = {{-102, -78}, {-74, -50}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_aval(final unit = "K", displayUnit = "degC") "Set point for leaving fluid temperature at port b1" annotation(
    Placement(transformation(extent = {{-120, -86}, {-80, -46}}), iconTransformation(extent = {{-104, 40}, {-76, 68}})));
  Modelica.Blocks.Interfaces.RealOutput P_elec(final unit = "W") "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{252, -82}, {272, -62}}, rotation = 0), iconTransformation(extent = {{88, 14}, {108, 34}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_amont(final unit = "W") "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{252, -24}, {272, -4}}, rotation = 0), iconTransformation(extent = {{88, -46}, {108, -26}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{-18, -102}, {2, -82}}, rotation = 0), iconTransformation(extent = {{90, 80}, {110, 100}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput D_amont "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{252, 164}, {272, 184}}, rotation = 0), iconTransformation(extent = {{94, -104}, {114, -84}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(extent = {{110, -80}, {126, -64}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(transformation(extent = {{54, -36}, {74, -16}})));
  Hvac.HeatPumps.BaseClasses.AffineEquationFlow data_pac(xA = -10 + 273.15, yA = 2.5, xB = 12 + 273.15, yB = 5.5, D = 1.6, time_data = 3600) annotation(
    Placement(transformation(extent = {{-68, -18}, {-34, 16}})));
  Modelica.Blocks.Math.Gain Puissance_aval2(k = -1) annotation(
    Placement(visible = true, transformation(origin = {113, -27}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0.1) annotation(
    Placement(visible = true, transformation(extent = {{-70, 136}, {-50, 156}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(transformation(extent = {{-36, 144}, {-16, 164}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(extent = {{64, 164}, {84, 184}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{12, 132}, {32, 152}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(transformation(extent = {{158, -24}, {178, -4}})));
  Modelica.Blocks.Math.Gain time_info(k = 1/(data_pac.time_data - 60)*data_pac.time_data) annotation(
    Placement(visible = true, transformation(origin = {218, 24}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_amont_soustract(final unit = "W") "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{252, 14}, {272, 34}}, rotation = 0), iconTransformation(origin = {2, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.MathBoolean.And Activation(nu = 2) annotation(
    Placement(transformation(extent = {{102, 18}, {122, 38}})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual1 annotation(
    Placement(visible = true, transformation(extent = {{76, 82}, {96, 102}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression functioning_time(y = 60) annotation(
    Placement(visible = true, transformation(origin = {45, 69}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Buildings.Controls.Continuous.OffTimer offTim annotation(
    Placement(visible = true, transformation(origin = {44, 92}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(transformation(extent = {{14, 86}, {26, 98}})));
equation
  connect(division.y, P_elec) annotation(
    Line(points = {{127, -72}, {262, -72}}, color = {0, 0, 127}, smooth = Smooth.Bezier));
  connect(P_aval, division.u1) annotation(
    Line(points = {{-100, -66}, {104, -66}, {104, -67}, {108, -67}}, color = {0, 0, 127}));
  connect(T_amont, data_pac.T) annotation(
    Line(points = {{-104, 6}, {-74, 6}, {-74, 6.99}, {-66.13, 6.99}}, color = {0, 0, 127}));
  connect(P_aval, add.u1) annotation(
    Line(points = {{-100, -66}, {-22, -66}, {-22, -20}, {52, -20}}, color = {0, 0, 127}));
  connect(add.y, Puissance_aval2.u) annotation(
    Line(points = {{75, -26}, {114, -26}, {114, -27}, {105, -27}}, color = {0, 0, 127}));
  connect(realExpression.y, greaterEqual.u2) annotation(
    Line(points = {{-49, 146}, {-38, 146}}, color = {0, 0, 127}));
  connect(P_aval, greaterEqual.u1) annotation(
    Line(points = {{-100, -66}, {-70, -66}, {-70, 154}, {-38, 154}}, color = {0, 0, 127}));
  connect(switch1.y, D_amont) annotation(
    Line(points = {{85, 174}, {262, 174}}, color = {0, 0, 127}));
  connect(data_pac.Debit, switch1.u1) annotation(
    Line(points = {{-37.74, 12.26}, {-2, 12.26}, {-2, 182}, {62, 182}}, color = {0, 0, 127}));
  connect(greaterEqual.y, switch1.u2) annotation(
    Line(points = {{-15, 154}, {2, 154}, {2, 174}, {62, 174}}, color = {255, 0, 255}));
  connect(realExpression1.y, switch3.u3) annotation(
    Line(points = {{33, 142}, {146, 142}, {146, -22}, {156, -22}}, color = {0, 0, 127}));
  connect(Puissance_aval2.y, switch3.u1) annotation(
    Line(points = {{121, -27}, {140, -27}, {140, -6}, {156, -6}}, color = {0, 0, 127}));
  connect(switch3.y, Q_amont) annotation(
    Line(points = {{179, -14}, {262, -14}}, color = {0, 0, 127}));
  connect(switch3.y, time_info.u) annotation(
    Line(points = {{179, -14}, {178, -14}, {178, 24}, {208, 24}}, color = {0, 0, 127}, smooth = Smooth.Bezier));
  connect(time_info.y, Q_amont_soustract) annotation(
    Line(points = {{227, 24}, {262, 24}}, color = {0, 0, 127}, smooth = Smooth.Bezier));
  connect(Activation.y, switch3.u2) annotation(
    Line(points = {{123.5, 28}, {150, 28}, {150, -14}, {156, -14}}, color = {255, 0, 255}, smooth = Smooth.Bezier));
  connect(greaterEqual.y, Activation.u[1]) annotation(
    Line(points = {{-15, 154}, {110, 154}, {110, 104}, {110, 26}, {110, 26.25}, {102, 26.25}}, color = {255, 0, 255}, smooth = Smooth.Bezier));
  connect(offTim.y, greaterEqual1.u1) annotation(
    Line(points = {{55, 92}, {74, 92}}, color = {0, 0, 127}, smooth = Smooth.Bezier));
  connect(functioning_time.y, greaterEqual1.u2) annotation(
    Line(points = {{54.9, 69}, {54.9, 68}, {68, 68}, {68, 84}, {74, 84}}, color = {0, 0, 127}, smooth = Smooth.Bezier));
  connect(greaterEqual1.y, Activation.u[2]) annotation(
    Line(points = {{97, 92}, {106, 92}, {106, 29.75}, {102, 29.75}}, color = {255, 0, 255}, smooth = Smooth.Bezier));
  connect(greaterEqual.y, not1.u) annotation(
    Line(points = {{-15, 154}, {2, 154}, {2, 92}, {12.8, 92}}, color = {255, 0, 255}));
  connect(not1.y, offTim.u) annotation(
    Line(points = {{26.6, 92}, {32, 92}}, color = {255, 0, 255}));
  connect(division.y, add.u2) annotation(
    Line(points = {{127, -72}, {142, -72}, {142, -48}, {44, -48}, {44, -32}, {52, -32}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch1.u3) annotation(
    Line(points = {{34, 142}, {42, 142}, {42, 166}, {62, 166}}, color = {0, 0, 127}));
  connect(data_pac.COP, division.u2) annotation(
    Line(points = {{-38, -12}, {18, -12}, {18, -76}, {108, -76}}, color = {0, 0, 127}));
  connect(data_pac.COP, COP) annotation(
    Line(points = {{-38, -12}, {-26, -12}, {-26, -92}, {-8, -92}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, -100}, {260, 220}})),
    experiment(StopTime = 14259600, __Dymola_Algorithm = "Dassl"));
end AffineEquationBlockSummer;
