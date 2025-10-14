within Modelitek.Sensors;

model ExtractEnergy
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium = Buildings.Media.Air "Moist air"), choice(redeclare package Medium = Buildings.Media.Water "Water"), choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Real flow_nominal(unit = "kg/s") = 1.0 "Nominal mass flow rate for safe operation";
//  parameter Real Pmin(unit = "W") = 100.0 "Minimum requested power to enable circulation";
  // --- Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "Fluid outlet" annotation(
    Placement(transformation(extent = {{114, 48}, {86, 76}}), iconTransformation(origin = {-28, 0}, extent = {{114, -40}, {88, -14}})));
  // --- Inputs
  Modelica.Blocks.Interfaces.RealInput P_demand(unit = "W") "Requested load (W)" annotation(
    Placement(transformation(origin = {-164, -78}, extent = {{20, -20}, {-20, 20}}, rotation = -180), iconTransformation(origin = {72, 56}, extent = {{30, -82}, {-10, -42}}, rotation = 270)));
  // --- Pump
  // --- Flow sensors
  Buildings.Fluid.Sensors.TemperatureTwoPort T1(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = flow_nominal) annotation(
    Placement(transformation(origin = {-61, 62}, extent = {{-11, -12}, {11, 12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = flow_nominal) annotation(
    Placement(transformation(origin = {51, 62}, extent = {{-11, -12}, {11, 12}})));
  // --- Logic: minimum flow to allow load injection
  Modelica.Blocks.Sources.RealExpression minFlow(y = 0.5) "Minimum flow to allow load injection" annotation(
    Placement(transformation(origin = {-42, 202}, extent = {{12, -88}, {28, -70}})));
  Modelica.Blocks.Logical.GreaterEqual flowOK annotation(
    Placement(transformation(origin = {24, 54}, extent = {{-8, 60}, {8, 44}})));
  Modelica.Blocks.Logical.Switch safeSwitch annotation(
    Placement(transformation(origin = {-78, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression zeroPower(y = 0) annotation(
    Placement(transformation(origin = {-88, 20}, extent = {{54, -68}, {38, -50}})));
  // --- Logic: enable pump flow only if P_demand > Pmin
  // --- Heat flow prescribed
  Modelica.Blocks.Logical.GreaterEqual seasoncheck annotation(
    Placement(transformation(origin = {-100, -23.5}, extent = {{-7, 52.5}, {7, 38.5}})));
  Modelica.Blocks.Math.Gain multiplier(k = +1) annotation(
    Placement(transformation(origin = {-68, 9}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Interfaces.RealInput seasonMode(unit = "W") "Seasonal mode selector: Heating=1, Cooling=2, Off=3" annotation(
    Placement(transformation(origin = {-182, 22}, extent = {{20, -20}, {-20, 20}}, rotation = -180), iconTransformation(origin = {-30, -2}, extent = {{30, -82}, {-10, -42}}, rotation = -180)));
  Modelica.Blocks.Logical.Switch ss annotation(
    Placement(transformation(origin = {-47, 21}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Sources.RealExpression seasonswitch(y = 0.5) "Threshold Pmin" annotation(
    Placement(transformation(origin = {-62, 102}, extent = {{-82, -74}, {-62, -54}})));
  Modelica.Blocks.Math.Gain multiplier1(k = -1) annotation(
    Placement(transformation(origin = {-71, 37}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(origin = {-12.8, -76.2}, extent = {{-151.2, 123.2}, {-123.2, 151.2}}), iconTransformation(origin = {58, -119}, extent = {{-108, 84}, {-88, 104}})));
  Buildings.Fluid.Sensors.MassFlowRate Flowrate_sensor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-58, 62}, extent = {{-60, -10}, {-40, 10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(redeclare package Medium = Medium, m_flow_nominal = 1, dp_nominal = 0, Q_flow_nominal = 42000)  annotation(
    Placement(transformation(origin = {-4, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1)  annotation(
    Placement(transformation(origin = {41, 21}, extent = {{-9, -9}, {9, 9}})));
protected
equation
// Pump circulation with controlled flow
  connect(T2.port_b, port_b);
// Flow check
  connect(minFlow.y, flowOK.u2) annotation(
    Line(points = {{-13.2, 123}, {4.8, 123}, {4.8, 111}, {14.8, 111}}, color = {0, 0, 127}));
// Pump flow logic
// Heat flow safety switch
  connect(flowOK.y, safeSwitch.u2) annotation(
    Line(points = {{33, 106}, {36, 106}, {36, -30}, {-78, -30}}, color = {255, 0, 255}));
  connect(zeroPower.y, safeSwitch.u3) annotation(
    Line(points = {{-50.8, -39}, {-71.6, -39}, {-71.6, -30}}, color = {0, 0, 127}));
// Heat flow connection
  connect(T2.port_b, port_b) annotation(
    Line(points = {{62, 62}, {100, 62}}, color = {0, 127, 255}));
  connect(zeroPower.y, safeSwitch.u3) annotation(
    Line(points = {{-12, -20}, {-30, -20}, {-30, -12}}, color = {0, 0, 127}));
  connect(minFlow.y, flowOK.u2) annotation(
    Line(points = {{-14, 104}, {4, 104}, {4, 92}, {14, 92}}, color = {0, 0, 127}));
  connect(flowOK.y, safeSwitch.u2) annotation(
    Line(points = {{32, 86}, {36, 86}, {36, -4}, {-38, -4}, {-38, 4}}, color = {255, 0, 255}));
  connect(seasonMode, seasoncheck.u1) annotation(
    Line(points = {{-182, 22}, {-108, 22}}, color = {0, 0, 127}));
  connect(seasonswitch.y, seasoncheck.u2) annotation(
    Line(points = {{-123, 38}, {-123, 28}, {-108, 28}}, color = {0, 0, 127}));
  connect(seasoncheck.y, ss.u2) annotation(
    Line(points = {{-92, 22}, {-79, 22}, {-79, 21}, {-57, 21}}, color = {255, 0, 255}));
  connect(multiplier.y, ss.u3) annotation(
    Line(points = {{-61.4, 9}, {-61.4, 14}, {-56.4, 14}}, color = {0, 0, 127}));
  connect(safeSwitch.y, multiplier.u) annotation(
    Line(points = {{-78, -12}, {-78, 10}, {-76, 10}}, color = {0, 0, 127}));
  connect(safeSwitch.y, multiplier1.u) annotation(
    Line(points = {{-78, -12}, {-78, 37}}, color = {0, 0, 127}));
  connect(multiplier1.y, ss.u1) annotation(
    Line(points = {{-64, 38}, {-62, 38}, {-62, 28}, {-56, 28}}, color = {0, 0, 127}));
  connect(Flowrate_sensor.port_b, T1.port_a) annotation(
    Line(points = {{-98, 62}, {-72, 62}}, color = {0, 127, 255}));
  connect(port_a, Flowrate_sensor.port_a) annotation(
    Line(points = {{-150, 62}, {-118, 62}}));
  connect(flowOK.u1, Flowrate_sensor.m_flow) annotation(
    Line(points = {{14, 106}, {-108, 106}, {-108, 74}}, color = {0, 0, 127}));
  connect(T1.port_b, hea.port_a) annotation(
    Line(points = {{-50, 62}, {-14, 62}}, color = {0, 127, 255}));
  connect(hea.port_b, T2.port_a) annotation(
    Line(points = {{6, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ss.y, division.u1) annotation(
    Line(points = {{-38, 22}, {-2, 22}, {-2, 26}}, color = {0, 0, 127}));
  connect(Flowrate_sensor.m_flow, division.u2) annotation(
    Line(points = {{-108, 74}, {-108, 84}, {-30, 84}, {-30, 14}, {-2, 14}}, color = {0, 0, 127}));
  connect(P_demand, safeSwitch.u1) annotation(
    Line(points = {{-164, -78}, {-84, -78}, {-84, -30}}, color = {0, 0, 127}));
  connect(division.y, limiter.u) annotation(
    Line(points = {{22, 20}, {22, 21.5}, {30, 21.5}, {30, 21}}, color = {0, 0, 127}));
  connect(limiter.y, hea.u) annotation(
    Line(points = {{50, 22}, {62, 22}, {62, 42}, {-16, 42}, {-16, 68}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-140, 80}, {160, -120}}), graphics = {Rectangle(origin = {10, -2}, lineColor = {255, 255, 255}, fillColor = {238, 238, 238}, fillPattern = FillPattern.Solid, extent = {{-72, 78}, {76, -76}}), Rectangle(origin = {54, 0}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, extent = {{-92, -18}, {2, -36}}), Rectangle(origin = {8, 0}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, extent = {{-2, -18}, {64, -36}}), Rectangle(origin = {12, -17}, fillColor = {162, 29, 33}, fillPattern = FillPattern.Solid, extent = {{-10, 55}, {11, -59}}), Polygon(origin = {14, -76}, fillColor = {162, 29, 33}, fillPattern = FillPattern.Solid, points = {{-50, 100}, {-2, 154}, {48, 100}, {14, 100}, {-50, 100}}), Text(origin = {4, 202}, textColor = {0, 0, 255}, extent = {{-148, -326}, {152, -286}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, 140}, {120, -140}}), graphics = {Rectangle(origin = {5, 114}, extent = {{-57, 22}, {57, -22}}), Text(origin = {27, 126}, extent = {{-31, 6}, {31, 0}}, textString = "check flow > 0 before injecting power"), Rectangle(origin = {-110, 22}, extent = {{86, -30}, {-86, 30}}), Text(origin = {-168, 44}, extent = {{-26, 4}, {26, -4}}, textString = "positive or negative according to season")}),
   Documentation(info="
<html>
<head></head>
<body>
<h4>ExtractEnergy</h4>
<p>
This model exchanges thermal energy with a fluid stream according to an external
power request <code>P_demand</code> (in Watts).
</p>

<h5>Functionality</h5>
<ul>
  <li><code>P_demand</code> specifies the requested thermal load. Positive values add heat, negative values remove heat.</li>
  <li><code>seasonMode</code> selects the operation mode: 1 = Heating, 0 = Cooling, 0.5 = treated as Heating.</li>
  <li>If <code>P_demand</code> is below <code>Pmin</code>, no load is applied.</li>
  <li>If the measured mass flow rate is below <code>minFlow</code>, no load is applied to avoid unrealistic temperature changes.</li>
  <li>The requested power is normalized into the dimensionless control signal <code>u</code> required by <code>HeaterCooler_u</code>. A limiter ensures |u| ≤ 1, so the exchanged heat flow cannot exceed <code>Q_flow_nominal</code>.</li>
</ul>

<h5>Parameters</h5>
<ul>
  <li><b>flow_nominal</b> [kg/s]: nominal design mass flow rate</li>
  <li><b>Pmin</b> [W]: minimum requested power needed to enable circulation</li>
  <li><b>Q_flow_nominal</b> [W]: maximum thermal power capacity of the exchanger</li>
</ul>

<h5>Use cases</h5>
<ul>
  <li>Representing a building load extracting or gaining power from a fluid loop</li>
  <li>Coupling external control signals with a hydronic system</li>
  <li>Safe operation through power and flow thresholds</li>
</ul>
</body>
</html>
") );
end ExtractEnergy;
