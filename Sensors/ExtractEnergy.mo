within Modelitek.Sensors;

model ExtractEnergy
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium = Buildings.Media.Air "Moist air"), choice(redeclare package Medium = Buildings.Media.Water "Water"), choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Real flow_nominal(unit = "kg/s") = 1.0 "Nominal mass flow rate for safe operation";
  parameter Real Pmin(unit = "W") = 100.0 "Minimum requested power to enable circulation";
  // --- Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "Fluid outlet" annotation(
    Placement(transformation(extent = {{114, 48}, {86, 76}}), iconTransformation(origin = {-28, 0}, extent = {{114, -40}, {88, -14}})));
  // --- Inputs
  Modelica.Blocks.Interfaces.RealInput P_demand(unit = "W") "Requested load (W)" annotation(
    Placement(transformation(origin = {-164, -78}, extent = {{20, -20}, {-20, 20}}, rotation = -180), iconTransformation(origin = {-36, -20}, extent = {{30, -82}, {-10, -42}}, rotation = -180)));
  // --- Pump
  Buildings.Fluid.Movers.FlowControlled_m_flow pump(redeclare package Medium = Medium, m_flow_nominal = flow_nominal, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, addPowerToMedium = false, dp_nominal = 2000, nominalValuesDefineDefaultPressureCurve = true) "Pump forcing circulation" annotation(
    Placement(transformation(origin = {-10, 62}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  // --- Flow sensors
  Buildings.Fluid.Sensors.TemperatureTwoPort T1(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = flow_nominal) annotation(
    Placement(transformation(origin = {-61, 62}, extent = {{-11, -12}, {11, 12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T2(redeclare package Medium = Medium, T_start = 293.15, m_flow_nominal = flow_nominal) annotation(
    Placement(transformation(origin = {51, 62}, extent = {{-11, -12}, {11, 12}})));
  // --- Logic: minimum flow to allow load injection
  Modelica.Blocks.Sources.RealExpression minFlow(y = 0.05) "Minimum flow to allow load injection" annotation(
    Placement(transformation(origin = {-42, 202}, extent = {{12, -88}, {28, -70}})));
  Modelica.Blocks.Logical.GreaterEqual flowOK annotation(
    Placement(transformation(origin = {24, 54}, extent = {{-8, 60}, {8, 44}})));
  Modelica.Blocks.Logical.Switch safeSwitch annotation(
    Placement(transformation(origin = {-78, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression zeroPower(y = 0) annotation(
    Placement(transformation(origin = {-88, 20}, extent = {{54, -68}, {38, -50}})));
  // --- Logic: enable pump flow only if P_demand > Pmin
  Modelica.Blocks.Sources.RealExpression zeroFlow(y = 0) "Zero flow if demand is too low" annotation(
    Placement(transformation(origin = {6, -44}, extent = {{82, -40}, {62, -20}})));
  Modelica.Blocks.Logical.GreaterEqual demandOK annotation(
    Placement(transformation(origin = {78, -36}, extent = {{-58, -22}, {-42, -6}})));
  Modelica.Blocks.Logical.Switch pumpSwitch annotation(
    Placement(transformation(origin = {48, -24}, extent = {{-24, -16}, {-8, 0}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression pminParam(y = Pmin) "Threshold Pmin" annotation(
    Placement(transformation(origin = {66, 6}, extent = {{-82, -74}, {-62, -54}})));
  // --- Heat flow prescribed
  Modelica.Blocks.Logical.GreaterEqual seasoncheck annotation(
    Placement(transformation(origin = {-100, -23.5}, extent = {{-7, 52.5}, {7, 38.5}})));
  Modelica.Blocks.Math.Gain multiplier(k = +1) annotation(
    Placement(transformation(origin = {-68, 9}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Interfaces.RealInput seasonMode(unit = "W") "Seasonal mode selector: Heating=1, Cooling=2, Off=3" annotation(
    Placement(transformation(origin = {-182, 22}, extent = {{20, -20}, {-20, 20}}, rotation = -180), iconTransformation(origin = {-36, -116}, extent = {{30, -82}, {-10, -42}}, rotation = -180)));
  Modelica.Blocks.Logical.Switch ss annotation(
    Placement(transformation(origin = {-47, 21}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Sources.RealExpression seasonswitch(y = 0.5) "Threshold Pmin" annotation(
    Placement(transformation(origin = {-62, 102}, extent = {{-82, -74}, {-62, -54}})));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT(T = 273.15 + 30, nPorts = 1, p = 1200, redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-126, 83}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Math.Gain multiplier1(k = -1) annotation(
    Placement(transformation(origin = {-71, 37}, extent = {{-6, -6}, {6, 6}})));

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit = "W") "kg/s" annotation(
    Placement(transformation(origin = {-162, -119}, extent = {{20, -20}, {-20, 20}}, rotation = -180), iconTransformation(origin = {-36, -69}, extent = {{30, -82}, {-10, -42}}, rotation = -180)));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_block "Applied load depending on mode, demand and flow" annotation(
    Placement(transformation(origin = {-39, 50}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
// Pump circulation with controlled flow
  connect(T1.port_b, pump.port_a) annotation(
    Line(points = {{-50, 62}, {-18, 62}}, color = {0, 127, 255}));
  connect(pump.port_b, T2.port_a) annotation(
    Line(points = {{-2, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(T2.port_b, port_b);
// Flow check
  connect(pump.m_flow_actual, flowOK.u1) annotation(
    Line(points = {{-2, 58}, {14, 58}, {14, 106}}, color = {0, 0, 127}));
  connect(minFlow.y, flowOK.u2) annotation(
    Line(points = {{-13.2, 123}, {4.8, 123}, {4.8, 111}, {14.8, 111}}, color = {0, 0, 127}));
// Pump flow logic
  connect(P_demand, demandOK.u1) annotation(
    Line(points = {{-164, -78}, {-46, -78}, {-46, -50}, {18, -50}}, color = {0, 0, 127}));
  connect(pminParam.y, demandOK.u2) annotation(
    Line(points = {{5, -58}, {17, -58}, {17, -56}}, color = {0, 0, 127}));
  connect(demandOK.y, pumpSwitch.u2) annotation(
    Line(points = {{37, -50}, {56, -50}}, color = {255, 0, 255}));
  connect(zeroFlow.y, pumpSwitch.u3) annotation(
    Line(points = {{67, -74}, {61, -74}, {61, -50}}, color = {0, 0, 127}));
  connect(pumpSwitch.y, pump.m_flow_in) annotation(
    Line(points = {{56, -31}, {56, 34}, {-10, 34}, {-10, 52}}, color = {0, 0, 127}));
// Heat flow safety switch
  connect(P_demand, safeSwitch.u1) annotation(
    Line(points = {{-164, -78}, {-84, -78}, {-84, -30}}, color = {0, 0, 127}));
  connect(flowOK.y, safeSwitch.u2) annotation(
    Line(points = {{33, 106}, {36, 106}, {36, -30}, {-78, -30}}, color = {255, 0, 255}));
  connect(zeroPower.y, safeSwitch.u3) annotation(
    Line(points = {{-50.8, -39}, {-71.6, -39}, {-71.6, -30}}, color = {0, 0, 127}));
// Heat flow connection
  connect(Q_flow_block.port, pump.heatPort) annotation(
    Line(points = {{-39, 60}, {-39, 84}, {-10, 84}, {-10, 68}}, color = {191, 0, 0}));
  connect(T1.port_b, pump.port_a) annotation(
    Line(points = {{-50, 62}, {-18, 62}}, color = {0, 127, 255}));
  connect(pump.port_b, T2.port_a) annotation(
    Line(points = {{-2, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(T2.port_b, port_b) annotation(
    Line(points = {{62, 62}, {100, 62}}, color = {0, 127, 255}));
  connect(Q_flow_block.port, pump.heatPort) annotation(
    Line(points = {{-40, 50}, {-40, 84}, {-10, 84}, {-10, 68}}, color = {191, 0, 0}));
  connect(pminParam.y, demandOK.u2) annotation(
    Line(points = {{12, -18}, {24, -18}, {24, -16}}, color = {0, 0, 127}));
  connect(zeroPower.y, safeSwitch.u3) annotation(
    Line(points = {{-12, -20}, {-30, -20}, {-30, -12}}, color = {0, 0, 127}));
  connect(P_demand, demandOK.u1) annotation(
    Line(points = {{-112, -22}, {-46, -22}, {-46, -40}, {-40, -40}}, color = {0, 0, 127}));
  connect(demandOK.y, pumpSwitch.u2) annotation(
    Line(points = {{-22, -40}, {28, -40}, {28, 4}}, color = {255, 0, 255}));
  connect(pump.m_flow_actual, flowOK.u1) annotation(
    Line(points = {{-2, 58}, {4, 58}, {4, 80}, {12, 80}}, color = {0, 0, 127}));
  connect(minFlow.y, flowOK.u2) annotation(
    Line(points = {{-14, 104}, {4, 104}, {4, 92}, {14, 92}}, color = {0, 0, 127}));
  connect(flowOK.y, safeSwitch.u2) annotation(
    Line(points = {{32, 86}, {36, 86}, {36, -4}, {-38, -4}, {-38, 4}}, color = {255, 0, 255}));
  connect(zeroFlow.y, pumpSwitch.u3) annotation(
    Line(points = {{68, -52}, {62, -52}, {62, -28}}, color = {0, 0, 127}));
  connect(pumpSwitch.y, pump.m_flow_in) annotation(
    Line(points = {{56, -10}, {56, 34}, {-10, 34}, {-10, 52}}, color = {0, 0, 127}));
  connect(P_demand, safeSwitch.u1) annotation(
    Line(points = {{-134, -78}, {-46, -78}, {-46, 4}, {-44, 4}}, color = {0, 0, 127}));
  connect(seasonMode, seasoncheck.u1) annotation(
    Line(points = {{-182, 22}, {-108, 22}}, color = {0, 0, 127}));
  connect(seasonswitch.y, seasoncheck.u2) annotation(
    Line(points = {{-123, 38}, {-123, 28}, {-108, 28}}, color = {0, 0, 127}));
  connect(seasoncheck.y, ss.u2) annotation(
    Line(points = {{-92, 22}, {-79, 22}, {-79, 21}, {-57, 21}}, color = {255, 0, 255}));
  connect(multiplier.y, ss.u3) annotation(
    Line(points = {{-61.4, 9}, {-61.4, 14}, {-56.4, 14}}, color = {0, 0, 127}));
  connect(ss.y, Q_flow_block.Q_flow) annotation(
    Line(points = {{-38, 21}, {-38, 40}}, color = {0, 0, 127}));
  connect(safeSwitch.y, multiplier.u) annotation(
    Line(points = {{-78, -12}, {-78, 10}, {-76, 10}}, color = {0, 0, 127}));
  connect(boundary_pT.ports[1], T1.port_a) annotation(
    Line(points = {{-116, 84}, {-86, 84}, {-86, 62}, {-72, 62}}, color = {0, 127, 255}));
  connect(safeSwitch.y, multiplier1.u) annotation(
    Line(points = {{-78, -12}, {-78, 37}}, color = {0, 0, 127}));
  connect(multiplier1.y, ss.u1) annotation(
    Line(points = {{-64, 38}, {-62, 38}, {-62, 28}, {-56, 28}}, color = {0, 0, 127}));
  connect(Q_flow, pumpSwitch.u1) annotation(
    Line(points = {{-162, -118}, {50, -118}, {50, -50}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-140, 80}, {160, -120}}), graphics = {Rectangle(origin = {10, -2}, lineColor = {255, 255, 255}, fillColor = {238, 238, 238}, fillPattern = FillPattern.Solid, extent = {{-72, 78}, {76, -76}}), Rectangle(origin = {54, 0}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, extent = {{-92, -18}, {2, -36}}), Rectangle(origin = {8, 0}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, extent = {{-2, -18}, {64, -36}}), Rectangle(origin = {12, -17}, fillColor = {162, 29, 33}, fillPattern = FillPattern.Solid, extent = {{-10, 55}, {11, -59}}), Polygon(origin = {14, -76}, fillColor = {162, 29, 33}, fillPattern = FillPattern.Solid, points = {{-50, 100}, {-2, 154}, {48, 100}, {14, 100}, {-50, 100}}), Text(origin = {4, 202}, textColor = {0, 0, 255}, extent = {{-148, -326}, {152, -286}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, 140}, {120, -140}}), graphics = {Rectangle(origin = {5, 114}, extent = {{-57, 22}, {57, -22}}), Text(origin = {27, 126}, extent = {{-31, 6}, {31, 0}}, textString = "check flow > 0 before injecting power"), Rectangle(origin = {42, -54}, extent = {{64, -26}, {-64, 26}}), Text(origin = {84, -58}, extent = {{-20, 8}, {20, -8}}, textString = "start flow if power"), Rectangle(origin = {-112, 22}, extent = {{86, -30}, {-86, 30}}), Text(origin = {-168, 44}, extent = {{-26, 4}, {26, -4}}, textString = "positive or negative according to season")}),
    Documentation(info = "<html><head></head><body>
<h4>InjectEnergy</h4>
<p>This model extracts energy into a fluid stream according to an external power request <code>P_demand</code>.</p>
<ul>
<li><b>SeasonMode input</b>: controls operation mode:
  <ul>
    <li><b>Heating</b> (1): the requested power is extracted as heat gain.</li>
    <li><b>Cooling</b> (0): the requested power is&nbsp;extracted&nbsp;as cooling.</li>
    <li><b>MidSeason</b>&nbsp;(0.5): same than heating.</li>
  </ul></li>
<li><b>Pmin logic</b>: if the requested power <code>P_demand</code> is below <code>Pmin</code>, the pump enforces zero flow. Otherwise, the pump enforces a constant flow <code>Q_flow</code>.</li>
<li><b>Flow safety</b>: if the actual mass flow rate is below the threshold <code>minFlow</code>, the requested load is not applied to avoid numerical issues.</li>
</ul>
<p>Parameters:</p>
<ul>
  <li><code>flow_nominal</code>: nominal flow rate of the pump [kg/s]</li>
  <li><code>Pmin</code>: minimum requested power to activate the pump [W]</li>
  <li><code>Q_flow</code>: fixed flow rate enforced when demand is above threshold [kg/s]</li>
</ul><div><br></div>
</body></html>"));
end ExtractEnergy;
