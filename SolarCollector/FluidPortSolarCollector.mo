within Modelitek.SolarCollector;

model FluidPortSolarCollector
  replaceable package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220.0, X_a = 0.40) "Medium model for glycol";
  Buildings.Fluid.Sources.Boundary_pT out_PAC1(redeclare package Medium = Medium, use_T_in = false, T = 288.15, nPorts = 1) "Fluid source on source side" annotation(
    Placement(transformation(origin = {-186, -134}, extent = {{-8, -8}, {8, 8}}, rotation = -180)));
  Modelica.Blocks.Interfaces.RealOutput T_out "K" annotation(
    Placement(transformation(origin = {-26, 12}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {42, 94}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium = Medium) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(origin = {-266, 6}, extent = {{-6, -152}, {14, -132}}), iconTransformation(origin = {-138, 136}, extent = {{-6, -152}, {14, -132}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium = Medium) "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(origin = {0, -294}, extent = {{14, 150}, {-6, 170}}), iconTransformation(origin = {70, -166}, extent = {{14, 150}, {-6, 170}})));
  Modelica.Blocks.Interfaces.RealInput Irad "W/m²" annotation(
    Placement(transformation(origin = {-209, 47}, extent = {{-17, -17}, {17, 17}}), iconTransformation(origin = {84, 36}, extent = {{-194, 50}, {-170, 74}})));
  Modelica.Blocks.Interfaces.RealInput Text "degC" annotation(
    Placement(transformation(origin = {-209, 9}, extent = {{-17, -17}, {17, 17}}), iconTransformation(origin = {84, 58}, extent = {{-194, -6}, {-170, 18}})));
  Modelica.Blocks.Interfaces.RealInput Wspeed "m/s" annotation(
    Placement(transformation(origin = {-209, -31}, extent = {{-17, -17}, {17, 17}}), iconTransformation(origin = {84, 80}, extent = {{-194, -62}, {-170, -38}})));
  Modelica.Blocks.Interfaces.RealOutput T_module "K" annotation(
    Placement(transformation(origin = {-134, 46}, extent = {{96, -20}, {120, 4}}), iconTransformation(origin = {-64, 104}, extent = {{98, -52}, {118, -32}})));
  Modelica.Blocks.Interfaces.RealOutput T_in "K" annotation(
    Placement(transformation(origin = {-26, -10}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {44, 28}, extent = {{-10, -10}, {10, 10}})));
  Sensors.TemperatureFlow out_capteur1(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-256, 0}, extent = {{24, -146}, {42, -122}}, rotation = -0)));
  BaseClasses.SolarCollector1D solarCollector1D annotation(
    Placement(transformation(origin = {-98.75, -43}, extent = {{-28.75, -23}, {28.75, 23}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(redeclare package Medium = Medium, nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-43, -135}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
equation

  connect(Irad, solarCollector1D.SolarIrradiance) annotation(
    Line(points = {{-208, 48}, {-168, 48}, {-168, -26}, {-124, -26}}, color = {0, 0, 127}));
  connect(Text, solarCollector1D.AmbientTemperature) annotation(
    Line(points = {{-208, 10}, {-174, 10}, {-174, -34}, {-124, -34}}, color = {0, 0, 127}));
  connect(Wspeed, solarCollector1D.WindSpeed) annotation(
    Line(points = {{-208, -30}, {-180, -30}, {-180, -42}, {-124, -42}}, color = {0, 0, 127}));
  connect(solarCollector1D.T_module, T_module) annotation(
    Line(points = {{-78, -28}, {-62, -28}, {-62, 38}, {-26, 38}}, color = {0, 0, 127}));
  connect(solarCollector1D.Tout, T_out) annotation(
    Line(points = {{-80, -42}, {-56, -42}, {-56, 12}, {-26, 12}}, color = {0, 0, 127}));
  connect(solarCollector1D.Tin_measured, T_in) annotation(
    Line(points = {{-80, -56}, {-50, -56}, {-50, -10}, {-26, -10}}, color = {0, 0, 127}));
  connect(boundary1.ports[1], port_b) annotation(
    Line(points = {{-33, -135}, {4, -135}, {4, -134}}, color = {0, 127, 255}));
  connect(port_a, out_capteur1.port_a) annotation(
    Line(points = {{-262, -136}, {-232, -136}, {-232, -134}}));
  connect(out_capteur1.port_b, out_PAC1.ports[1]) annotation(
    Line(points = {{-214, -134}, {-194, -134}}, color = {0, 127, 255}));
  connect(out_capteur1.T, solarCollector1D.Tin) annotation(
    Line(points = {{-228, -122}, {-228, -54}, {-124, -54}}, color = {0, 0, 127}));
  connect(out_capteur1.F, solarCollector1D.MassFlow) annotation(
    Line(points = {{-218, -122}, {-216, -122}, {-216, -60}, {-124, -60}}, color = {0, 0, 127}));
  connect(out_capteur1.F, boundary1.m_flow_in) annotation(
    Line(points = {{-218, -122}, {-216, -122}, {-216, -102}, {-118, -102}, {-118, -126}, {-54, -126}}, color = {0, 0, 127}));
  connect(solarCollector1D.Tout, boundary1.T_in) annotation(
    Line(points = {{-80, -42}, {-68, -42}, {-68, -130}, {-54, -130}}, color = {0, 0, 127}));
  annotation(
  Documentation(info = "<html><head></head>
<body>
<h4>SolarCollector.FluidsPortSensor</h4>

<p>
This model provides a sensorized fluid interface for a solar collector model.
It connects a one-dimensional solar collector representation 
(<code>SolarCollector1D</code>) to fluid ports and boundary conditions,
while exposing measured signals for use in system simulations.
</p>

<h5>Inputs</h5>
<ul>
  <li><code>Irad</code> [W/m²] – incident solar irradiance</li>
  <li><code>Text</code> [°C] – ambient temperature</li>
  <li><code>Wspeed</code> [m/s] – wind speed</li>
</ul>

<h5>Fluid ports</h5>
<ul>
  <li><code>port_a</code> – fluid inlet</li>
  <li><code>port_b</code> – fluid outlet</li>
</ul>

<h5>Outputs</h5>
<ul>
  <li><code>T_out</code> [K] – outlet temperature</li>
  <li><code>T_in</code> [K] – inlet temperature (measured)</li>
  <li><code>T_module</code> [K] – representative module temperature</li>
</ul>

<p>
This wrapper can be used to connect the solar collector to HVAC loops, 
heat exchangers, or storage tanks, while still providing access 
to the collector’s thermal performance and environmental conditions.
</p>

</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-140, 160}, {80, -20}}), graphics = {Text(origin = {-22, -12}, textColor = {0, 0, 255}, extent = {{-56, 130}, {34, 158}}, textString = "%name"), Ellipse(origin = {-48, 78}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Polygon(origin = {-13, 41}, fillColor = {85, 85, 127}, fillPattern = FillPattern.Horizontal, points = {{-39, -17}, {-9, 17}, {39, 17}, {33, -17}, {-39, -17}, {-39, -17}}), Polygon(origin = {-49, 44}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-1, 8}, {-1, -8}, {1, -8}, {1, 8}, {-1, 8}, {-1, 8}}), Polygon(origin = {-28, 49}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-6, 7}, {4, -9}, {6, -7}, {-4, 9}, {-6, 7}, {-6, 7}}), Polygon(origin = {-10, 64}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-12, 4}, {12, -6}, {12, -4}, {-12, 6}, {-12, 4}, {-12, 4}}), Rectangle(origin = {-28, 74}, lineColor = {85, 170, 255}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-102, 84}, {102, -84}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-280, 60}, {20, -160}}), graphics),
    Documentation(info = "<html><head></head><body><p class=\"MsoNormal\"><br></p></body></html>"));
end FluidPortSolarCollector;
