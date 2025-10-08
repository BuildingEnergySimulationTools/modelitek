within Modelitek.Sensors;

model PumpConsumption
  replaceable package Medium = 
    Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium 
    "Fluid medium (default = water, replaceable by glycol, air, etc.)";

  // Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) 
    "Fluid connector a (design flow: a → b)" 
    annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(origin = {-124, -4}, extent = {{-110, -10}, {-90, 10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) 
    "Fluid connector b (design flow: a → b)" 
    annotation(Placement(transformation(extent = {{110, -10}, {90, 10}}), iconTransformation(origin = {-124, -4}, extent = {{110, -10}, {90, 10}})));

  // Mass flow measurement
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  // Conversion to m³/h
  Sensors.Conversions.Conversion_kgs_to_m3h X(density = density)
    annotation (Placement(transformation(origin = {-24, 14}, extent = {{-20, 20}, {0, 40}})));

  // Pump power law: P = a * exp(b * Q)
  Modelica.Blocks.Sources.RealExpression calcul_puissance(
    y = a * exp(b * X.D_out))
    annotation (Placement(transformation(origin = {-198, 46}, extent = {{114, 18}, {228, 36}})));

  // Parameters
  parameter Real a = 1 "Pump power curve coefficient (W)";
  parameter Real b = 0.1 "Pump power curve exponent (1/(m³/h))";
  parameter Real density = 1.0 "Fluid density [kg/L]";

  // Threshold and switch
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0.1)
    annotation (Placement(transformation(origin = {-18, 54}, extent = {{-20, -40}, {0, -20}})));

  Modelica.Blocks.Logical.GreaterEqual greaterEqual
    annotation (Placement(transformation(origin = {-22, 74}, extent = {{20, -40}, {40, -20}})));

  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(origin = {10, 54}, extent = {{60, -20}, {80, 0}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0)
    annotation (Placement(transformation(origin = {10, 76}, extent = {{20, -60}, {40, -40}})));

  // Cumulative consumption integrator
  Modelica.Blocks.Continuous.Integrator integrator3(k = 1/3.6e6)
    annotation (Placement(transformation(origin = {112, 118}, extent = {{-100, -20}, {-120, 0}}, rotation = -0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput P_elec_cumul 
    "Cumulative electrical consumption [kWh]" 
    annotation(Placement(transformation(origin = {98, -16}, extent = {{140, 0}, {160, 20}}, rotation = 90), iconTransformation(origin = {-54, -144}, extent = {{196, 0}, {224, 28}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput P_elec 
    "Instantaneous electrical power [W]" 
    annotation(Placement(transformation(origin = {-88, -16}, extent = {{140, -40}, {160, -20}}, rotation = 90), iconTransformation(origin = {-220, -144}, extent = {{196, -56}, {224, -28}}, rotation = 90)));

equation
  connect(port_a, senMasFlo2.port_a);
  connect(senMasFlo2.port_b, port_b);
  connect(senMasFlo2.m_flow, X.D_in) annotation(
    Line(points = {{-50, 12}, {-50, 44}, {-42, 44}}, color = {0, 0, 127}));
  connect(X.D_out, greaterEqual.u1);
  connect(realExpression.y, greaterEqual.u2);
  connect(greaterEqual.y, switch1.u2) annotation(
    Line(points = {{20, 44}, {68, 44}}, color = {255, 0, 255}));
  connect(calcul_puissance.y, switch1.u1);
  connect(realExpression1.y, switch1.u3);
  connect(switch1.y, integrator3.u);
  connect(switch1.y, P_elec);
  connect(port_a, senMasFlo2.port_a) annotation(
    Line(points = {{-100, 0}, {-60, 0}}));
  connect(senMasFlo2.m_flow, X.D_in) annotation(
    Line(points = {{-50, 12}, {-50, 32}, {-40, 32}}, color = {0, 0, 127}));
  connect(X.D_out, greaterEqual.u1) annotation(
    Line(points = {{-26, 44}, {-4, 44}}, color = {0, 0, 127}));
  connect(realExpression.y, greaterEqual.u2) annotation(
    Line(points = {{-16, 24}, {-16, 36}, {-4, 36}}, color = {0, 0, 127}));
  connect(greaterEqual.y, switch1.u2) annotation(
    Line(points = {{20, 44}, {43, 44}, {43, 42}, {66, 42}}, color = {255, 0, 255}));
  connect(calcul_puissance.y, switch1.u1) annotation(
    Line(points = {{36, 74}, {54, 74}, {54, 52}, {68, 52}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch1.u3) annotation(
    Line(points = {{52, 26}, {56, 26}, {56, 36}, {68, 36}}, color = {0, 0, 127}));
  connect(senMasFlo2.port_b, port_b) annotation(
    Line(points = {{-40, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(switch1.y, integrator3.u) annotation(
    Line(points = {{92, 44}, {114, 44}, {114, 108}, {14, 108}}, color = {0, 0, 127}));
  connect(integrator3.y, P_elec) annotation(
    Line(points = {{-8, 108}, {-58, 108}, {-58, 134}}, color = {0, 0, 127}));
  connect(switch1.y, P_elec_cumul) annotation(
    Line(points = {{92, 44}, {114, 44}, {114, 108}, {88, 108}, {88, 134}}, color = {0, 0, 127}));

annotation(
  Diagram(coordinateSystem(extent = {{-120, 140}, {120, -20}}), graphics),
  Icon(graphics = {
    Rectangle(origin = {-124, -4}, fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 14}, {100, -18}}),
    Ellipse(origin = {-124, -4}, fillColor = {199, 177, 51}, fillPattern = FillPattern.Solid, extent = {{-58, 54}, {58, -62}}),
    Text(origin = {-124, -4}, extent = {{-40, 40}, {32, -50}}, textString = "C"), Text(origin = {-132, 212}, textColor = {0, 0, 255}, extent = {{-148, -326}, {152, -286}}, textString = "%name")}, 
    coordinateSystem(extent = {{-280, 80}, {20, -120}})),
  Documentation(info="<html>
    <h4>Pump consumption model</h4>
    <p>This block computes the electrical consumption of a pump based on the measured
    mass flow rate and an exponential performance curve.</p>
    <h5>Inputs/Outputs</h5>
    <ul>
      <li><b>port_a, port_b</b>: fluid connectors</li>
      <li><b>P_elec</b>: instantaneous pump electrical power [W]</li>
      <li><b>P_elec_cumul</b>: cumulative pump electrical energy [kWh]</li>
    </ul>
    <h5>Parameters</h5>
    <ul>
      <li><b>a</b>: Pump curve coefficient (default = 1 W)</li>
      <li><b>b</b>: Pump curve exponent (default = 0.1 1/(m³/h))</li>
      <li><b>density</b>: Fluid density [kg/L] (default = 1.0)</li>
      <li><b>Medium</b>: Replaceable medium (default = water)</li>
    </ul>
    <p>The pump power is computed as <code>P = a * exp(b * Q)</code>, where
    <i>Q</i> is the volumetric flow rate in m³/h.</p>
  </html>")
);
end PumpConsumption;
