within Modelitek.Sensors;

model TemperatureFlow

    replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=220,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package
      Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T_mes(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Outlet temperature of the heater"
    annotation (Placement(transformation(origin = {-12.3636, -0.769231}, extent = {{-55.6364, -9.23077}, {-37.6364, 10.7692}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flow(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(origin = {17.3333, -1.66667}, extent = {{16.6667, -8.33333}, {36.6667, 11.6667}})));
  Modelica.Blocks.Interfaces.RealOutput T "(K)" annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-80,106}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-62,102})));
  Modelica.Blocks.Interfaces.RealOutput F "(kg/s)" annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={62,106}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={64,102})));
equation
  connect(T_mes.T, T) annotation (Line(points={{-59,11},{-59,88},{-80,
          88},{-80,106}},
                 color={0,0,127}));
  connect(m_flow.m_flow, F) annotation (Line(points={{44,11},{44,
          88},{62,88},{62,106}},
                               color={0,0,127}));
  connect(port_a, T_mes.port_a) annotation (Line(points={{-100,0},{-68, 0}},        color={0,127,255}));
  connect(T_mes.port_b, m_flow.port_a) annotation (Line(points={{-50,0},
          {34, 0}},
                                color={0,127,255}));
  connect(m_flow.port_b, port_b) annotation (Line(points={{54, 0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(origin = {-4, 14},textColor = {0, 0, 255}, extent = {{-152, -150}, {148, -110}}, textString = "%name"), Rectangle(fillColor = {0, 140, 72}, pattern = LinePattern.Dash, fillPattern = FillPattern.VerticalCylinder, extent = {{-92, 92}, {94, -96}}), Text( extent = {{-60, 62}, {58, -66}}, textString = "T, F")}),
        Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 120}, {120, -20}})),
  Documentation(info = "<html><head></head><body><!--StartFragment-->The <code data-start=\"162\" data-end=\"179\">TemperatureFlow</code> sensor model measures both the <strong data-start=\"211\" data-end=\"232\">fluid temperature</strong> and the <strong data-start=\"241\" data-end=\"259\">mass flow rate</strong> through a two–port fluid component.<br data-start=\"295\" data-end=\"298\">
It is intended for use in fluid systems where the medium can be air, water, or a glycol–water mixture.<!--EndFragment--><div><br></div><div><!--StartFragment--><p data-start=\"924\" data-end=\"1045\"><strong data-start=\"924\" data-end=\"946\">Replaceable medium</strong><br data-start=\"946\" data-end=\"949\">
The working fluid is defined via the replaceable package <code data-start=\"1006\" data-end=\"1014\">Medium</code>. Predefined choices include:</p>
<ul data-start=\"1046\" data-end=\"1299\">
<li data-start=\"1046\" data-end=\"1087\">
<p data-start=\"1048\" data-end=\"1087\"><strong data-start=\"1048\" data-end=\"1061\">Moist air</strong> (<code data-start=\"1063\" data-end=\"1084\">Buildings.Media.Air</code>)</p>
</li>
<li data-start=\"1088\" data-end=\"1127\">
<p data-start=\"1090\" data-end=\"1127\"><strong data-start=\"1090\" data-end=\"1099\">Water</strong> (<code data-start=\"1101\" data-end=\"1124\">Buildings.Media.Water</code>)</p>
</li>
<li data-start=\"1128\" data-end=\"1299\">
<p data-start=\"1130\" data-end=\"1299\"><strong data-start=\"1130\" data-end=\"1156\">Propylene glycol water</strong> (<code data-start=\"1158\" data-end=\"1207\">Buildings.Media.Antifreeze.PropyleneGlycolWater</code>) with user-defined properties (default: 40% mass fraction, property temperature = 220 K).</p></li></ul><!--EndFragment--></div></body></html>"));
end TemperatureFlow;
