within Modelitek.Sensors;

model WaterHeater
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.2;
  parameter Modelica.Units.SI.Volume V = 0.01;
  parameter Real efficiency = 1;

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts = 2,
    redeclare package Medium = Medium,
    V = V,
    m_flow_nominal = m_flow_nominal) annotation(
      Placement(transformation(origin = {0, -24}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(transformation(origin = {-26, -66}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-84, -14}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-84, -10}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {66, -14}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {84, -6}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput P_demand(unit="W") "Requested load (W)" annotation(
    Placement(transformation(origin = {-83, -208}, extent = {{20, -20}, {-20, 20}}, rotation = -180),
    iconTransformation(origin = {43, -54}, extent = {{30, -82}, {-10, -42}}, rotation = 270)));

  Modelica.Blocks.Logical.Switch safeSwitch annotation(
    Placement(transformation(origin = {5, -182}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));

  Modelica.Blocks.Sources.RealExpression zeroPower(y=0) annotation(
    Placement(transformation(origin = {-9, -146}, extent = {{54, -68}, {38, -50}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-48, -14}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));

  Modelica.Blocks.Logical.GreaterEqual seasoncheck annotation(
    Placement(transformation(origin = {6, -90.5}, extent = {{-7, -52.5}, {7, -38.5}}, rotation = -0)));

  Modelica.Blocks.Math.Gain multiplier(k = -1) annotation(
    Placement(transformation(origin = {34, -148}, extent = {{-6, -6}, {6, 6}})));

  Modelica.Blocks.Interfaces.RealInput seasonMode(unit = "W") "Seasonal mode selector: Heating=1, Cooling=2, Off=3" annotation(
    Placement(transformation(origin = {-80, -137}, extent = {{20, -20}, {-20, 20}}, rotation = -180),
    iconTransformation(origin = {96, -53}, extent = {{30, -82}, {-10, -42}}, rotation = 270)));

  Modelica.Blocks.Logical.Switch ss annotation(
    Placement(transformation(origin = {54, -137}, extent = {{-7, -7}, {7, 7}})));

  Modelica.Blocks.Sources.RealExpression seasonswitch(y=0.5) "Threshold Pmin" annotation(
    Placement(transformation(origin = {38, -85}, extent = {{-82, -74}, {-62, -54}})));

  Modelica.Blocks.Math.Gain multiplier1(k=+1) annotation(
    Placement(transformation(origin = {31, -120}, extent = {{-6, -6}, {6, 6}})));

  Modelica.Blocks.Sources.RealExpression minFlow(y=0.05) "Minimum flow to allow load injection" annotation(
    Placement(transformation(origin = {-58, -165}, extent = {{12, -88}, {28, -70}})));

  Modelica.Blocks.Logical.GreaterEqual flowOK annotation(
    Placement(transformation(origin = {6, -313}, extent = {{-8, 60}, {8, 44}})));

  Modelica.Blocks.Math.Gain gain(k = efficiency) annotation(
    Placement(transformation(origin = {-60, -74}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(port_a, senMasFlo.port_a) annotation(
    Line(points = {{-84, -14}, {-58, -14}}));
  connect(senMasFlo.port_b, vol.ports[1]) annotation(
    Line(points = {{-38, -14}, {0, -14}}, color = {0, 127, 255}));
  connect(port_b, vol.ports[2]) annotation(
    Line(points = {{66, -14}, {0, -14}}));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation(
    Line(points = {{-16, -66}, {-10, -66}, {-10, -24}}, color = {191, 0, 0}));
  connect(gain.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-48, -74}, {-36, -74}, {-36, -66}}, color = {0, 0, 127}));
  connect(seasonMode, seasoncheck.u1) annotation(
    Line(points = {{-80, -136}, {-2, -136}}, color = {0, 0, 127}));
  connect(seasoncheck.y, ss.u2) annotation(
    Line(points = {{14, -136}, {46, -136}}, color = {255, 0, 255}));
  connect(multiplier1.y, ss.u1) annotation(
    Line(points = {{38, -120}, {46, -120}, {46, -132}}, color = {0, 0, 127}));
  connect(multiplier.y, ss.u3) annotation(
    Line(points = {{40, -148}, {46, -148}, {46, -142}}, color = {0, 0, 127}));
  connect(safeSwitch.y, multiplier1.u) annotation(
    Line(points = {{6, -174}, {6, -120}, {24, -120}}, color = {0, 0, 127}));
  connect(safeSwitch.y, multiplier.u) annotation(
    Line(points = {{6, -174}, {6, -148}, {26, -148}}, color = {0, 0, 127}));
  connect(zeroPower.y, safeSwitch.u3) annotation(
    Line(points = {{28, -204}, {12, -204}, {12, -192}}, color = {0, 0, 127}));
  connect(P_demand, safeSwitch.u1) annotation(
    Line(points = {{-82, -208}, {-2, -208}, {-2, -192}}, color = {0, 0, 127}));
  connect(minFlow.y, flowOK.u2) annotation(
    Line(points = {{-30, -244}, {-18, -244}, {-18, -254}, {-4, -254}}, color = {0, 0, 127}));
  connect(flowOK.y, safeSwitch.u2) annotation(
    Line(points = {{14, -260}, {22, -260}, {22, -218}, {6, -218}, {6, -192}}, color = {255, 0, 255}));
  connect(senMasFlo.m_flow, flowOK.u1) annotation(
    Line(points = {{-48, -24}, {-50, -24}, {-50, -48}, {-110, -48}, {-110, -260}, {-4, -260}}, color = {0, 0, 127}));
  connect(ss.y, gain.u) annotation(
    Line(points = {{62, -136}, {66, -136}, {66, -98}, {-82, -98}, {-82, -74}, {-72, -74}}, color = {0, 0, 127}));
  connect(seasonswitch.y, seasoncheck.u2) annotation(
    Line(points = {{-22, -148}, {-12, -148}, {-12, -142}, {-2, -142}}, color = {0, 0, 127}));
  annotation(
    uses(Buildings(version = "12.1.0"), Modelica(version = "4.0.0")),
    Diagram(graphics = {
      Rectangle(origin = {-8, -137}, extent = {{86, -30}, {-86, 30}}),
      Text(origin = {-66, -115}, extent = {{-26, 4}, {26, -4}}, textString = "positive or negative according to season"),
      Rectangle(origin = {-11, -253}, extent = {{-57, 22}, {57, -22}}),
      Text(origin = {24, -241}, extent = {{-44, 6}, {44, 0}}, textString = "check flow > 0 before injecting power")}
    , coordinateSystem(extent = {{-120, 0}, {80, -280}})),
    Icon(graphics = {
      Rectangle(origin = {0, -29}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-86, 47}, {86, -47}}),
      Text(origin = {-4, 351}, textColor = {0, 0, 255}, extent = {{-134, -334}, {138, -293}}, textString = "%name")}
    , coordinateSystem(extent = {{-100, 20}, {100, -80}})));
end WaterHeater;
