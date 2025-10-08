within Modelitek.Hvac.HeatPumps;

model HeatPump_COPs_Pa_Pc
  replaceable package Medium_source = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium_source = Buildings.Media.Air "Moist air"), choice(redeclare package Medium_source = Buildings.Media.Water "Water"), choice(redeclare package Medium_source = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.37) "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium_load = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium_load = Buildings.Media.Air "Moist air"), choice(redeclare package Medium_load = Buildings.Media.Water "Water"), choice(redeclare package Medium_load = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.37) "Propylene glycol water, 40% mass fraction")));
  //  replaceable package Medium_source =
  //  Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=
  //        220.0, X_a=0.40)"Medium in the component";
  //  replaceable package Medium_load =
  //    Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=
  //          220.0, X_a=0.40) ;
  parameter Real flow_rate_source = 1.115 "Heat pump source side mass flow rate [kg/s]";
  parameter Real flow_rate_load = 1.115 "Heat pump load side mass flow rate [kg/s]";
  Modelica.Fluid.Interfaces.FluidPort_b port_b_loa(redeclare final package Medium = Medium_load) "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation(
    Placement(visible = true, transformation(origin = {126, 181}, extent = {{12, -11}, {-12, 11}}, rotation = 0), iconTransformation(extent = {{146, -82}, {120, -56}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_loa(redeclare final package Medium = Medium_load) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(visible = true, transformation(extent = {{-170, 170}, {-146, 194}}, rotation = 0), iconTransformation(extent = {{-142, -80}, {-116, -54}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput COP(final unit = "1") "Coefficient of performance, assuming useful heat is at load side (at Medium 1)" annotation(
    Placement(visible = true, transformation(extent = {{226, -30}, {246, -10}}, rotation = 0), iconTransformation(extent = {{90, -34}, {110, -14}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_source(redeclare final package Medium = Medium_source) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(visible = true, transformation(origin = {135, -141}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(extent = {{122, 138}, {148, 164}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_source(redeclare final package Medium = Medium_source) "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(origin = {-195, -141}, extent = {{11, -11}, {-11, 11}}), iconTransformation(extent = {{-120, 138}, {-146, 164}})));
  parameter Real Pc_table[:, :] = [0, 23.5, 32.5, 42.5, 51, 60; -5, 29000, 27800, 26600, 26000, 25000; -1.5, 34200, 33200, 31600, 30200, 28800; 5, 39100, 37400, 35400, 33800, 32200; 10, 44400, 42600, 40400, 38800, 36600; 15, 50200, 47800, 45200, 43000, 41200; 20, 55160, 52780, 49640, 47140, 44820; 50, 55160, 52780, 49640, 47140, 44820] "Delivered heat power winter [W]";
  parameter Real Pc_summer_table[:, :] = [0, 7, 12, 17, 22, 27; -5, 26000, 25000, 24000, 23000, 22000; 0, 31000, 30000, 28500, 27000, 25500; 5, 36000, 34500, 33000, 31500, 30000; 10, 41000, 39500, 37500, 35500, 33500; 15, 46000, 44500, 42000, 39500, 37000; 20, 51000, 49500, 46500, 43500, 40500] "Delivered heat power summer [W]";
  parameter Real Pa_table[:, :] = [0, 23.5, 32.5, 42.5, 51, 60; -5, 9700, 9500, 9400, 9300, 9200; -1.5, 11100, 10900, 10600, 10300, 10000; 5, 12700, 12400, 12000, 11600, 11300; 10, 14400, 14000, 13600, 13100, 12600; 15, 16200, 15700, 15200, 14600, 14000; 20, 17900, 17400, 16800, 16100, 15400] "Absorbed power winter [W]";
  parameter Real Pa_summer_table[:, :] = [0, 7, 12, 17, 22, 27; -5, 8700, 8500, 8300, 8100, 7900; 0, 10100, 9800, 9500, 9200, 8900; 5, 11500, 11100, 10700, 10300, 9900; 10, 13000, 12500, 12000, 11500, 11000; 15, 14500, 13900, 13300, 12700, 12100; 20, 16000, 15400, 14700, 14000, 13300] "Absorbed power summer [W]";
  parameter Real COP_table[:, :] = [0, 23.5, 32.5, 42.5, 51, 60; -5, 2.99, 2.92, 2.83, 2.77, 2.72; -1.5, 3.08, 3.04, 2.98, 2.93, 2.88; 5, 3.08, 3.02, 2.95, 2.91, 2.85; 10, 3.08, 3.04, 2.97, 2.91, 2.86; 15, 3.10, 3.05, 2.98, 2.94, 2.88; 20, 3.08, 3.03, 2.95, 2.91, 2.85] "COP winter [-]";
  parameter Real COP_summer_table[:, :] = [0, 7, 12, 17, 22, 27; -5, 2.99, 2.95, 2.89, 2.84, 2.78; 0, 3.07, 3.02, 2.97, 2.92, 2.87; 5, 3.09, 3.04, 2.98, 2.92, 2.87; 10, 3.11, 3.06, 3.00, 2.95, 2.89; 15, 3.13, 3.08, 3.01, 2.96, 2.90; 20, 3.14, 3.09, 3.02, 2.96, 2.91] "COP summer [-]";
  Modelica.Blocks.Tables.CombiTable2Ds P_chauffage(table = Pc_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, 59}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2Ds P_abs(table = Pa_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2Ds nappe_COP(table = COP_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, -13}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2Ds P_chauffage_summer(table = Pc_summer_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, 39}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2Ds P_abs_summer(table = Pa_summer_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, 7}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2Ds nappe_COP_summer(table = COP_summer_table, tableOnFile = false) annotation(
    Placement(visible = true, transformation(origin = {-73, -27}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pompe_aval(redeclare package Medium = Medium_load, m_flow_nominal = 1, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, addPowerToMedium = false, dp_nominal = 2000, nominalValuesDefineDefaultPressureCurve = true) "Pump forcing circulation through the system" annotation(
    Placement(visible = true, transformation(origin = {-61, 181}, extent = {{11, 11}, {-11, -11}}, rotation = 180)));
  Modelica.Blocks.Logical.GreaterEqual Debit_true annotation(
    Placement(visible = true, transformation(extent = {{18, 222}, {34, 240}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = D_load.y - 0.005) annotation(
    Placement(visible = true, transformation(origin = {-33, 224}, extent = {{-17, -8}, {17, 8}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pompe_amont1(redeclare package Medium = Medium_source, m_flow_nominal = 1, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, addPowerToMedium = false, dp_nominal = 2000, nominalValuesDefineDefaultPressureCurve = true) "Pump forcing circulation through the system" annotation(
    Placement(visible = true, transformation(origin = {-84, -141}, extent = {{-12, -11}, {12, 11}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput P_elec_cumul(final unit = "kWh") "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{226, 30}, {246, 50}}, rotation = 0), iconTransformation(extent = {{90, 74}, {110, 94}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-102, 228}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(extent = {{-132, -170}, {-116, -186}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput y annotation(
    Placement(visible = true, transformation(extent = {{-236, -70}, {-202, -36}}, rotation = 0), iconTransformation(extent = {{-156, -8}, {-122, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{-152, 204}, {-130, 226}}, rotation = 0)));
  Modelica.Blocks.Math.Add HEAT_P_amont(k2 = -1) annotation(
    Placement(visible = true, transformation(extent = {{-2, 22}, {18, 42}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator2(k = 1/3.6e6) annotation(
    Placement(visible = true, transformation(extent = {{194, 32}, {208, 46}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(extent = {{2, -120}, {-12, -106}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch5 annotation(
    Placement(visible = true, transformation(extent = {{156, 22}, {172, 38}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_elec(final unit = "W") "Compressor power " annotation(
    Placement(visible = true, transformation(extent = {{226, 2}, {246, 22}}, rotation = 0), iconTransformation(extent = {{90, 100}, {110, 120}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort capteur_loa(redeclare package Medium = Medium_load, T_start = 293.15, m_flow_nominal = 1) annotation(
    Placement(visible = true, transformation(origin = {-115, 182}, extent = {{-11, -12}, {11, 12}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort capteur_source(redeclare package Medium = Medium_source, T_start = 293.15, m_flow_nominal = 1) annotation(
    Placement(visible = true, transformation(origin = {88, -141}, extent = {{10, -11}, {-10, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput period annotation(
    Placement(visible = true, transformation(origin = {-218, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-140, 92}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0.5) annotation(
    Placement(visible = true, transformation(extent = {{-188, 18}, {-166, 40}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-138, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch6 annotation(
    Placement(visible = true, transformation(origin = {91, -83}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch Pth annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch Pel annotation(
    Placement(visible = true, transformation(origin = {-50, 14}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch8 annotation(
    Placement(visible = true, transformation(origin = {-52, -20}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1/3.6e6) annotation(
    Placement(visible = true, transformation(extent = {{192, 88}, {206, 102}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_th_cumul(unit = "kWh") annotation(
    Placement(visible = true, transformation(extent = {{224, 86}, {244, 106}}, rotation = 0), iconTransformation(extent = {{90, 32}, {110, 52}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(extent = {{154, 76}, {170, 92}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort capteur_out_aval(redeclare package Medium = Medium_load, T_start = 293.15, m_flow_nominal = 1) annotation(
    Placement(visible = true, transformation(origin = {87, 181}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-17, 151}, extent = {{7, 7}, {-7, -7}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {62, 130}, extent = {{4, 4}, {-4, -4}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -1) annotation(
    Placement(visible = true, transformation(origin = {64, 104}, extent = {{4, 4}, {-4, -4}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput demande annotation(
    Placement(visible = true, transformation(origin = {-218, 96}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-142, 194}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch9 annotation(
    Placement(visible = true, transformation(extent = {{46, 110}, {32, 124}}, rotation = 0)));
  Modelica.Blocks.Logical.Less ECS annotation(
    Placement(visible = true, transformation(origin = {-136, 96}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_th(unit = "W") annotation(
    Placement(visible = true, transformation(extent = {{224, 62}, {244, 82}}, rotation = 0), iconTransformation(extent = {{90, 2}, {110, 22}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort capteur_out_amont(redeclare package Medium = Medium_source, T_start = 293.15, m_flow_nominal = 1) annotation(
    Placement(visible = true, transformation(origin = {-148, -139}, extent = {{10, -11}, {-10, 11}}, rotation = 0)));
  Modelica.Blocks.Math.Add COOL_P_amont2 annotation(
    Placement(visible = true, transformation(extent = {{-2, -14}, {18, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Or winter_or_ecs annotation(
    Placement(visible = true, transformation(origin = {46, -82}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {47, 31}, extent = {{-7, 7}, {7, -7}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{-176, -180}, {-154, -158}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression5(y = 0) annotation(
    Placement(visible = true, transformation(origin = {29, -123}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression6(y = 0.5) annotation(
    Placement(visible = true, transformation(extent = {{-190, 72}, {-168, 94}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression7(y = 0) annotation(
    Placement(visible = true, transformation(origin = {21, 169}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression8(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{110, 8}, {132, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression9(y = 0) annotation(
    Placement(visible = true, transformation(extent = {{108, 60}, {130, 82}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch7 annotation(
    Placement(visible = true, transformation(origin = {9, 135}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-104, 32}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLoa "Prescribed load side heat flow rate" annotation(
    Placement(visible = true, transformation(extent = {{-33, 142}, {-53, 162}}, rotation = 0)));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloSou "Prescribed source side heat flow rate" annotation(
    Placement(visible = true, transformation(origin = {-76, -113}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_in_source(final y = capteur_source.T - 273.15) "Required heat flow rate to meet set point" annotation(
    Placement(visible = true, transformation(origin = {-122, 62}, extent = {{-16, -10}, {16, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression T_in_loa(final y = capteur_loa.T - 273.15) "Required heat flow rate to meet set point" annotation(
    Placement(visible = true, transformation(origin = {-117, -41}, extent = {{-17, -9}, {17, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression D_source(y = flow_rate_source) "Required heat flow rate to meet set point" annotation(
    Placement(visible = true, transformation(origin = {-167, -188}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression D_load(y = flow_rate_load) "Required heat flow rate to meet set point" annotation(
    Placement(visible = true, transformation(origin = {-164, 234}, extent = {{-24, -10}, {24, 10}}, rotation = 0)));
equation
  connect(preHeaFloLoa.port, pompe_aval.heatPort) annotation(
    Line(points = {{-53, 152}, {-61, 152}, {-61, 174}}, color = {191, 0, 0}));
  connect(preHeaFloSou.port, pompe_amont1.heatPort) annotation(
    Line(points = {{-87, -113}, {-84, -113}, {-84, -134}}, color = {191, 0, 0}));
  connect(realExpression4.y, Debit_true.u2) annotation(
    Line(points = {{-14.3, 224}, {15.7, 224}}, color = {0, 0, 127}));
  connect(switch2.u2, y) annotation(
    Line(points = {{-112, 228}, {-186, 228}, {-186, -53}, {-219, -53}}, color = {255, 0, 255}));
  connect(switch3.u2, y) annotation(
    Line(points = {{-134, -178}, {-185.6, -178}, {-185.6, -53}, {-219, -53}}, color = {255, 0, 255}));
  connect(D_load.y, switch2.u1) annotation(
    Line(points = {{-137.6, 234}, {-111.6, 234}}, color = {0, 0, 127}));
  connect(D_source.y, switch3.u1) annotation(
    Line(points = {{-146.1, -188}, {-133.15, -188}, {-133.15, -184}, {-134.2, -184}}, color = {0, 0, 127}));
  connect(capteur_loa.port_b, pompe_aval.port_a) annotation(
    Line(points = {{-104, 182}, {-88, 182}, {-88, 181}, {-72, 181}}, color = {0, 127, 255}));
  connect(port_a_loa, capteur_loa.port_a) annotation(
    Line(points = {{-158, 182}, {-126, 182}}));
  connect(capteur_source.port_a, port_a_source) annotation(
    Line(points = {{98, -141}, {135, -141}}, color = {0, 127, 255}));
  connect(capteur_source.port_b, pompe_amont1.port_a) annotation(
    Line(points = {{78, -141}, {-72, -141}}, color = {0, 127, 255}));
  connect(period, less1.u1) annotation(
    Line(points = {{-218, 42}, {-145, 42}}, color = {0, 0, 127}));
  connect(realExpression.y, less1.u2) annotation(
    Line(points = {{-165, 29}, {-154.9, 29}, {-154.9, 36}, {-145.9, 36}}, color = {0, 0, 127}));
  connect(nappe_COP.y, switch8.u1) annotation(
    Line(points = {{-67.5, -13}, {-63.5, -13}, {-63.5, -17}, {-57, -17}}, color = {0, 0, 127}));
  connect(nappe_COP_summer.y, switch8.u3) annotation(
    Line(points = {{-67.5, -27}, {-63.5, -27}, {-63.5, -23}, {-57, -23}}, color = {0, 0, 127}));
  connect(P_abs.y, Pel.u1) annotation(
    Line(points = {{-67.5, 21}, {-64, 21}, {-64, 17}, {-55, 17}}, color = {0, 0, 127}));
  connect(P_abs_summer.y, Pel.u3) annotation(
    Line(points = {{-67.5, 7}, {-64, 7}, {-64, 11}, {-55, 11}}, color = {0, 0, 127}));
  connect(P_chauffage_summer.y, Pth.u3) annotation(
    Line(points = {{-67.5, 39}, {-63.5, 39}, {-63.5, 47}, {-55, 47}}, color = {0, 0, 127}));
  connect(P_chauffage.y, Pth.u1) annotation(
    Line(points = {{-67.5, 59}, {-61.25, 59}, {-61.25, 53}, {-55, 53}}, color = {0, 0, 127}));
  connect(T_in_source.y, P_chauffage.u1) annotation(
    Line(points = {{-104, 62}, {-79, 62}}, color = {0, 0, 127}));
  connect(T_in_source.y, P_chauffage_summer.u1) annotation(
    Line(points = {{-104, 62}, {-94, 62}, {-94, 42}, {-78, 42}}, color = {0, 0, 127}));
  connect(T_in_source.y, P_abs.u1) annotation(
    Line(points = {{-104, 62}, {-94, 62}, {-94, 24}, {-78, 24}}, color = {0, 0, 127}));
  connect(T_in_source.y, P_abs_summer.u1) annotation(
    Line(points = {{-104, 62}, {-94, 62}, {-94, 10}, {-78, 10}}, color = {0, 0, 127}));
  connect(T_in_loa.y, P_chauffage.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, 56}, {-79, 56}}, color = {0, 0, 127}));
  connect(T_in_loa.y, P_chauffage_summer.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, 36}, {-78, 36}}, color = {0, 0, 127}));
  connect(T_in_loa.y, P_abs.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, 18}, {-78, 18}}, color = {0, 0, 127}));
  connect(T_in_loa.y, nappe_COP.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, -16}, {-78, -16}}, color = {0, 0, 127}));
  connect(T_in_loa.y, nappe_COP_summer.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, -30}, {-78, -30}}, color = {0, 0, 127}));
  connect(T_in_source.y, nappe_COP.u1) annotation(
    Line(points = {{-104, 62}, {-94, 62}, {-94, -10}, {-78, -10}}, color = {0, 0, 127}));
  connect(T_in_source.y, nappe_COP_summer.u1) annotation(
    Line(points = {{-104, 62}, {-94, 62}, {-94, -24}, {-78, -24}}, color = {0, 0, 127}));
  connect(T_in_loa.y, P_abs_summer.u2) annotation(
    Line(points = {{-98, -41}, {-88, -41}, {-88, 4}, {-78, 4}}, color = {0, 0, 127}));
  connect(pompe_aval.port_b, capteur_out_aval.port_a) annotation(
    Line(points = {{-50, 181}, {76, 181}}, color = {0, 127, 255}));
  connect(capteur_out_aval.port_b, port_b_loa) annotation(
    Line(points = {{98, 181}, {126, 181}}, color = {0, 127, 255}));
  connect(demande, ECS.u1) annotation(
    Line(points = {{-218, 96}, {-143, 96}}, color = {0, 0, 127}));
  connect(pompe_amont1.port_b, capteur_out_amont.port_a) annotation(
    Line(points = {{-96, -140}, {-138, -140}, {-138, -138}}, color = {0, 127, 255}));
  connect(capteur_out_amont.port_b, port_b_source) annotation(
    Line(points = {{-158, -138}, {-194, -139}, {-195, -141}}, color = {0, 127, 255}));
  connect(switch4.y, preHeaFloSou.Q_flow) annotation(
    Line(points = {{-13, -113}, {-65, -113}}, color = {0, 0, 127}));
  connect(less1.y, winter_or_ecs.u2) annotation(
    Line(points = {{-132, 42}, {-118, 42}, {-118, -28}, {-100, -28}, {-100, -62}, {-78, -62}, {-78, -88}, {36, -88}}, color = {255, 0, 255}));
  connect(realExpression3.y, switch3.u3) annotation(
    Line(points = {{-152.9, -169}, {-134.9, -169}, {-134.9, -173}}, color = {0, 0, 127}));
  connect(switch3.y, pompe_amont1.m_flow_in) annotation(
    Line(points = {{-116, -178}, {-84, -178}, {-84, -154}}, color = {0, 0, 127}));
  connect(realExpression5.y, switch4.u3) annotation(
    Line(points = {{16, -122}, {8, -122}, {8, -118}, {4, -118}}, color = {0, 0, 127}));
  connect(realExpression6.y, ECS.u2) annotation(
    Line(points = {{-167, 83}, {-150, 83}, {-150, 91}, {-143, 91}}, color = {0, 0, 127}));
  connect(realExpression2.y, switch2.u3) annotation(
    Line(points = {{-128.9, 215}, {-112.9, 215}, {-112.9, 221}}, color = {0, 0, 127}));
  connect(switch2.y, pompe_aval.m_flow_in) annotation(
    Line(points = {{-93, 228}, {-61, 228}, {-61, 194}}, color = {0, 0, 127}));
  connect(gain1.y, switch9.u1) annotation(
    Line(points = {{58, 130}, {53.6, 130}, {53.6, 122}, {47.6, 122}}, color = {0, 0, 127}));
  connect(gain2.y, switch9.u3) annotation(
    Line(points = {{60, 104}, {53.6, 104}, {53.6, 112}, {47.6, 112}}, color = {0, 0, 127}));
  connect(Pth.y, HEAT_P_amont.u1) annotation(
    Line(points = {{-46, 50}, {-20, 50}, {-20, 38}, {-4, 38}}, color = {0, 0, 127}));
  connect(Pel.y, HEAT_P_amont.u2) annotation(
    Line(points = {{-46, 14}, {-14, 14}, {-14, 26}, {-4, 26}}, color = {0, 0, 127}));
  connect(Pel.y, COOL_P_amont2.u2) annotation(
    Line(points = {{-46, 14}, {-14, 14}, {-14, -10}, {-4, -10}}, color = {0, 0, 127}));
  connect(Pth.y, COOL_P_amont2.u1) annotation(
    Line(points = {{-46, 50}, {-20, 50}, {-20, 2}, {-4, 2}}, color = {0, 0, 127}));
  connect(HEAT_P_amont.y, gain.u) annotation(
    Line(points = {{20, 32}, {38, 32}}, color = {0, 0, 127}));
  connect(ECS.y, winter_or_ecs.u1) annotation(
    Line(points = {{-130, 96}, {28, 96}, {28, -82}, {36, -82}}, color = {255, 0, 255}));
  connect(winter_or_ecs.y, switch6.u2) annotation(
    Line(points = {{55, -82}, {82, -82}}, color = {255, 0, 255}));
  connect(switch6.y, switch4.u1) annotation(
    Line(points = {{98, -82}, {106, -82}, {106, -108}, {4, -108}}, color = {0, 0, 127}));
  connect(less1.y, switch9.u2) annotation(
    Line(points = {{-132, 42}, {-118, 42}, {-118, 104}, {66, 104}, {66, 117}, {47, 117}}, color = {255, 0, 255}));
  connect(Pth.y, gain1.u) annotation(
    Line(points = {{-46, 50}, {72, 50}, {72, 130}, {67, 130}}, color = {0, 0, 127}));
  connect(Pth.y, gain2.u) annotation(
    Line(points = {{-46, 50}, {72, 50}, {72, 104}, {69, 104}}, color = {0, 0, 127}));
  connect(switch.y, integrator.u) annotation(
    Line(points = {{170.8, 84}, {180.8, 84}, {180.8, 96}, {190.8, 96}}, color = {0, 0, 127}));
  connect(integrator.y, P_th_cumul) annotation(
    Line(points = {{206.7, 95}, {234.7, 95}}, color = {0, 0, 127}));
  connect(switch.y, P_th) annotation(
    Line(points = {{170.8, 84}, {180.8, 84}, {180.8, 72}, {234.8, 72}}, color = {0, 0, 127}));
  connect(switch8.y, COP) annotation(
    Line(points = {{-48, -20}, {236, -20}}, color = {0, 0, 127}));
  connect(switch5.y, integrator2.u) annotation(
    Line(points = {{172.8, 30}, {182.8, 30}, {182.8, 40}, {192.8, 40}}, color = {0, 0, 127}));
  connect(integrator2.y, P_elec_cumul) annotation(
    Line(points = {{208.7, 39}, {236.7, 39}}, color = {0, 0, 127}));
  connect(switch5.y, P_elec) annotation(
    Line(points = {{172.8, 30}, {182.8, 30}, {182.8, 12}, {236.8, 12}}, color = {0, 0, 127}));
  connect(Debit_true.y, switch.u2) annotation(
    Line(points = {{34, 232}, {116, 232}, {116, 84}, {152, 84}}, color = {255, 0, 255}));
  connect(Pth.y, switch.u1) annotation(
    Line(points = {{-46, 50}, {72, 50}, {72, 90}, {152, 90}}, color = {0, 0, 127}));
  connect(Pel.y, switch5.u1) annotation(
    Line(points = {{-46, 14}, {86, 14}, {86, 36}, {154, 36}}, color = {0, 0, 127}));
  connect(realExpression8.y, switch5.u3) annotation(
    Line(points = {{133.1, 19}, {147.1, 19}, {147.1, 23}, {153.1, 23}}, color = {0, 0, 127}));
  connect(realExpression9.y, switch.u3) annotation(
    Line(points = {{131.1, 71}, {145.1, 71}, {145.1, 77}, {151.1, 77}}, color = {0, 0, 127}));
  connect(ECS.y, switch7.u2) annotation(
    Line(points = {{-130, 96}, {28, 96}, {28, 135}, {17, 135}}, color = {255, 0, 255}));
  connect(gain1.y, switch7.u1) annotation(
    Line(points = {{58, 130}, {54, 130}, {54, 140}, {18, 140}}, color = {0, 0, 127}));
  connect(switch9.y, switch7.u3) annotation(
    Line(points = {{32, 118}, {22, 118}, {22, 130}, {18, 130}}, color = {0, 0, 127}));
  connect(pompe_aval.m_flow_actual, Debit_true.u1) annotation(
    Line(points = {{-48, 186}, {-4, 186}, {-4, 232}, {16, 232}}, color = {0, 0, 127}));
  connect(switch7.y, switch1.u1) annotation(
    Line(points = {{2, 136}, {-2, 136}, {-2, 146}, {-8, 146}}, color = {0, 0, 127}));
  connect(realExpression7.y, switch1.u3) annotation(
    Line(points = {{8, 170}, {-2, 170}, {-2, 156}, {-8, 156}}, color = {0, 0, 127}));
  connect(Debit_true.y, switch1.u2) annotation(
    Line(points = {{34, 232}, {56, 232}, {56, 151}, {-9, 151}}, color = {255, 0, 255}));
  connect(preHeaFloLoa.Q_flow, switch1.y) annotation(
    Line(points = {{-33, 152}, {-24, 152}, {-24, 151}, {-25, 151}}, color = {0, 0, 127}));
  connect(Debit_true.y, switch5.u2) annotation(
    Line(points = {{34, 232}, {116, 232}, {116, 30}, {154, 30}}, color = {255, 0, 255}));
  connect(Debit_true.y, switch4.u2) annotation(
    Line(points = {{34, 232}, {56, 232}, {56, -112}, {4, -112}}, color = {255, 0, 255}));
  connect(less1.y, or1.u2) annotation(
    Line(points = {{-132, 42}, {-118, 42}, {-118, 28}, {-112, 28}}, color = {255, 0, 255}));
  connect(ECS.y, or1.u1) annotation(
    Line(points = {{-130, 96}, {-116, 96}, {-116, 32}, {-112, 32}}, color = {255, 0, 255}));
  connect(or1.y, Pth.u2) annotation(
    Line(points = {{-98, 32}, {-84, 32}, {-84, 50}, {-54, 50}}, color = {255, 0, 255}));
  connect(or1.y, Pel.u2) annotation(
    Line(points = {{-98, 32}, {-84, 32}, {-84, 14}, {-54, 14}}, color = {255, 0, 255}));
  connect(or1.y, switch8.u2) annotation(
    Line(points = {{-98, 32}, {-84, 32}, {-84, -20}, {-56, -20}}, color = {255, 0, 255}));
  connect(gain.y, switch6.u1) annotation(
    Line(points = {{54, 32}, {72, 32}, {72, -78}, {82, -78}}, color = {0, 0, 127}));
  connect(COOL_P_amont2.y, switch6.u3) annotation(
    Line(points = {{20, -4}, {66, -4}, {66, -88}, {82, -88}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-160, 220}, {160, -140}}), graphics = {Rectangle(lineColor = {244, 125, 35}, fillColor = {238, 238, 238}, fillPattern = FillPattern.Solid, extent = {{-132, 210}, {136, -132}}), Rectangle(fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, extent = {{26, -60}, {124, -76}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, extent = {{-132, -60}, {34, -76}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, extent = {{-28, 160}, {138, 144}}), Rectangle(fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-126, 160}, {-28, 144}}), Text(origin = {423, 51}, rotation = -90, textColor = {0, 0, 255}, extent = {{-127, -201}, {127, -274}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-240, 260}, {260, -200}}), graphics = {Rectangle(origin = {-65, 35}, fillColor = {238, 238, 238}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-131, 31}, {35, -87}}), Rectangle(origin = {-17, -161}, fillColor = {238, 238, 238}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-171, 13}, {45, -37}}), Rectangle(origin = {-11, 236}, fillColor = {238, 238, 238}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-177, 14}, {47, -38}}), Rectangle(origin = {232, 78}, fillColor = {238, 238, 238}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-130, 40}, {34, -110}})}),
    Documentation(info = "
<html>
<head></head>
<body>
<h4>Overview</h4>
<p>
The <code>HeatPump_COPs</code> model represents a reversible heat pump with separate source and load fluid circuits.
The model computes heating/cooling power, electrical consumption, and coefficient of performance (COP) using performance maps
defined as embedded 2D tables. It includes pumps, flow control, and basic supervisory logic to ensure safe operation.
</p>

<h4>Inputs</h4>
<ul>
<li><b>y (Boolean):</b> On/off signal for the heat pump.</li>
<li><b>demande (Real):</b> Demand signal for DHW or heating. Values &gt;0 indicate DHW mode, values &lt;=0 indicate heating mode.</li>
<li><b>period (Real):</b> Seasonal flag: 0 = winter, 1 = summer. This selects the correct performance map.</li>
</ul>

<h4>Fluid Ports</h4>
<ul>
<li><b>port_a_source, port_b_source:</b> Source side fluid ports (e.g. borehole or ambient loop).</li>
<li><b>port_a_loa, port_b_loa:</b> Load side fluid ports (e.g. buffer tank or distribution loop).</li>
</ul>

<h4>Parameters</h4>
<ul>
<li><b>Medium_source:</b> Working fluid in the source side (default: propylene glycol water 40%).</li>
<li><b>Medium_load:</b> Working fluid in the load side (default: water).</li>
<li><b>Debit_PAC_amont [kg/s]:</b> Nominal flow rate on load side.</li>
<li><b>Debit_PAC_aval [kg/s]:</b> Nominal flow rate on source side.</li>
<li><b>P*_table:</b> Embedded 2D lookup tables containing performance data for heating and cooling capacity, absorbed power, and COP,
for both winter and summer operation.</li>
</ul>

<h4>Outputs</h4>
<ul>
<li><b>COP [-]:</b> Instantaneous coefficient of performance.</li>
<li><b>P_th [W]:</b> Thermal power delivered to the load side.</li>
<li><b>P_th_cumul [Wh]:</b> Cumulative delivered thermal energy (integrated over time).</li>
<li><b>P_elec [W]:</b> Electrical power absorbed by the compressor.</li>
<li><b>P_elec_cumul [Wh]:</b> Cumulative electrical consumption (integrated over time).</li>
</ul>

<h4>Internal logic</h4>
<ul>
<li>Performance maps are interpolated from two inputs: source inlet temperature and load inlet temperature.</li>
<li>Switching logic selects the correct set of maps depending on <code>period</code> (winter vs summer).</li>
<li>The pumps maintain constant design flow rates. Heat transfer is imposed through <code>PrescribedHeatFlow</code> elements.</li>
<li>Flow monitoring ensures that the heat pump only injects power if actual mass flow is above a small threshold, to avoid solver divergence.</li>
<li>Outputs are conditioned by the demand and on/off input signals.</li>
</ul>

<h4>Notes</h4>
<ul>
<li>The cumulative outputs (<code>P_th_cumul</code>, <code>P_elec_cumul</code>) are expressed in Wh (watt-hours), not watts.</li>
<li>The tables are embedded in the code, removing dependency on external files. They can be adapted to other heat pumps by replacing the data.</li>
<li>The model is designed for supervisory control simulations, not detailed thermodynamic cycle representation.</li>
</ul>

</body>
</html>
"));
end HeatPump_COPs_Pa_Pc;
