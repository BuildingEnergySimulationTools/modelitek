within Modelitek.Valves;

model FeedbackLoop "Generic feedback loop with configurable PID and 3-way valve"
  // === Medium ===
  replaceable package Medium = 
    Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220.0, X_a = 0.40);

  // === Buffer Parameters ===
  parameter Modelica.Units.SI.Volume V_buffer = 0.001 "Mixing volume (buffer storage)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1 "Nominal mass flow rate";
  parameter Modelica.Units.SI.Temperature T_start = 298.15 "Initial temperature";

  // === PID Parameters ===
  parameter Real k = 0.5 "Controller gain";
  parameter Modelica.Units.SI.Time Ti = 5 "Integral time";
  parameter Modelica.Units.SI.Time Td = 1 "Derivative time";
  parameter Modelica.Blocks.Types.SimpleController controllerType = 
    Modelica.Blocks.Types.SimpleController.PI "Controller type (P/PI/PD/PID)";
  parameter Boolean strict = true "Strict PID formulation";

  // === Controller ===
  Buildings.Controls.Continuous.LimPID pidController(
    k = k,
    Ti = Ti,
    Td = Td,
    controllerType = controllerType,
    strict = strict) "PID regulating outlet temperature" annotation(
      Placement(transformation(origin={2,76}, extent={{-10,10},{10,-10}}, rotation=-90)));

  // === Fluid components ===
  Buildings.Fluid.MixingVolumes.MixingVolume mixingVolume(
    redeclare package Medium = Medium,
    V = V_buffer,
    allowFlowReversal = true,
    m_flow_nominal = m_flow_nominal,
    nPorts = 2) "Buffer storage volume" annotation(
      Placement(transformation(origin = {2, -202},extent = {{-16, 112}, {6, 90}}, rotation = -0)));

  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valve3way(
    redeclare package Medium = Medium,
    dpValve_nominal = 2000,
    energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState,
    l={0.01,0.01},
    m_flow_nominal = m_flow_nominal) "3-way valve controlled by PID" annotation(
      Placement(transformation(origin={2,-6}, extent={{-14,-14},{14,14}})));

  // === Sensors ===
  Buildings.Fluid.Sensors.TemperatureTwoPort T_from_source(
    redeclare package Medium = Medium,
    T_start = T_start,
    m_flow_nominal = m_flow_nominal) "Temperature from source" annotation(
      Placement(transformation(origin={-50,-6}, extent={{14,16},{-14,-16}}, rotation=180)));

  Buildings.Fluid.Sensors.TemperatureTwoPort T_to_source(
    redeclare package Medium = Medium,
    T_start = T_start,
    m_flow_nominal = m_flow_nominal) "Temperature to source" annotation(
      Placement(transformation(origin={-50,-90}, extent={{-14,16},{14,-16}}, rotation=180)));

  Buildings.Fluid.Sensors.TemperatureTwoPort T_from_sink(
    redeclare package Medium = Medium,
    T_start = T_start,
    m_flow_nominal = m_flow_nominal) "Temperature from sink" annotation(
      Placement(transformation(origin={54,-90}, extent={{-14,16},{14,-16}}, rotation=180)));

  Buildings.Fluid.Sensors.TemperatureTwoPort T_to_sink(
    redeclare package Medium = Medium,
    T_start = T_start,
    m_flow_nominal = m_flow_nominal) "Temperature to sink" annotation(
      Placement(transformation(origin={52,-6}, extent={{14,16},{-14,-16}}, rotation=180)));

  // === External ports (kept visible) ===
  Modelica.Fluid.Interfaces.FluidPort_a port_source_in(redeclare package Medium = Medium)
    "Inlet from source" annotation(
      Placement(transformation(extent={{-118,-20},{-90,8}}),
                iconTransformation(origin = {-14, 214}, extent = {{-118, -20}, {-90, 8}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_source_out(redeclare package Medium = Medium)
    "Outlet to source" annotation(
      Placement(transformation(extent={{-118,-102},{-90,-74}}),
                iconTransformation(origin = {-10, 78}, extent = {{-118, -102}, {-90, -74}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_sink_in(redeclare package Medium = Medium)
    "Inlet from sink" annotation(
      Placement(transformation(extent={{86,-104},{114,-76}}),
                iconTransformation(origin = {10, 80}, extent = {{86, -104}, {114, -76}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_sink_out(redeclare package Medium = Medium)
    "Outlet to sink" annotation(
      Placement(transformation(extent={{112,-20},{84,8}}),
                iconTransformation(origin = {20, 218}, extent = {{112, -20}, {84, 8}})));

  // === Control ports ===
  Modelica.Blocks.Interfaces.RealOutput M_feedback "Thermal production signal" annotation(
    Placement(transformation(origin = {122, 36}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {60, 102}, extent = {{-16, -16}, {16, 16}})));

  Modelica.Blocks.Interfaces.RealInput T_set(displayUnit="degC", final unit="K")
    "Set point for leaving fluid temperature at port_sink_out [K]" annotation(
      Placement(transformation(origin = {2, 153}, extent = {{-20, -20}, {20, 20}}, rotation = 270), iconTransformation(origin = {-4, 277}, extent = {{-20, -20}, {20, 20}}, rotation = 270)));

equation
  connect(port_source_in, T_from_source.port_a) annotation(
    Line(points = {{-104, -6}, {-64, -6}}));
  connect(T_from_source.port_b, valve3way.port_1) annotation(
    Line(points = {{-36, -6}, {-12, -6}}, color = {0, 127, 255}));
  connect(valve3way.port_2, T_to_sink.port_a) annotation(
    Line(points = {{16, -6}, {38, -6}}, color = {0, 127, 255}));
  connect(T_to_sink.port_b, port_sink_out) annotation(
    Line(points = {{66, -6}, {98, -6}}, color = {0, 127, 255}));
  connect(port_source_out, T_to_source.port_b) annotation(
    Line(points = {{-104, -88}, {-64, -88}, {-64, -90}}));
  connect(T_to_source.port_a, mixingVolume.ports[1]) annotation(
    Line(points = {{-36, -90}, {-3, -90}}, color = {0, 127, 255}));
  connect(mixingVolume.ports[2], T_from_sink.port_b) annotation(
    Line(points = {{-2, -90}, {40, -90}}, color = {0, 127, 255}));
  connect(T_from_sink.port_a, port_sink_in) annotation(
    Line(points = {{68, -90}, {100, -90}}, color = {0, 127, 255}));
  connect(pidController.y, valve3way.y) annotation(
    Line(points = {{2, 66}, {2, 10}}, color = {0, 0, 127}));
  connect(T_to_sink.T, pidController.u_m) annotation(
    Line(points = {{52, 12}, {52, 76}, {14, 76}}, color = {0, 0, 127}));
  connect(T_set, pidController.u_s) annotation(
    Line(points = {{2, 154}, {2, 88}}, color = {0, 0, 127}));
  connect(pidController.y, M_feedback) annotation(
    Line(points = {{2, 66}, {2, 36}, {122, 36}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "
<html>
<h4>FeedbackLoop</h4>
<p>
Generic model of a thermal feedback loop with a configurable PID controller.  
It regulates the outlet temperature <code>T_to_sink</code> towards a setpoint 
<code>T_set</code> by modulating a 3-way valve.
</p>

<h5>Main components</h5>
<ul>
<li><b>pidController</b>: PID comparing outlet temperature with setpoint.</li>
<li><b>valve3way</b>: 3-way valve adjusting flow distribution between source and sink.</li>
<li><b>mixingVolume</b>: buffer storage representing thermal inertia.</li>
<li><b>temperature sensors</b>: at source and sink connections.</li>
</ul>

<h5>Ports</h5>
<ul>
<li><b>port_source_in / port_source_out</b>: connect to source system.</li>
<li><b>port_sink_in / port_sink_out</b>: connect to sink system.</li>
<li><b>T_set</b>: control setpoint (K).</li>
<li><b>M_feedback</b>: controller output signal.</li>
</ul>
</html>
    "),
  Diagram(graphics),
  Icon(graphics = {Rectangle(origin = {0, -40}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-92, 278}, {98, 232}}), Rectangle(origin = {-1, 71}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-21, 145}, {21, -48}}), Rectangle(origin = {-2, 104}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-88, -92}, {94, -136}}), Rectangle(origin = {-59, 94}, fillColor = {0, 0, 127}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{37, -32}, {149, -72}}), Text(origin = {26, -523}, textColor = {0, 0, 255}, extent = {{-128, 409}, {78, 497}}, textString = "%name"), Polygon(origin = {-6, -44}, fillColor = {85, 255, 255}, fillPattern = FillPattern.Solid, points = {{4, 256}, {-72, 316}, {-72, 196}, {4, 256}}), Polygon(origin = {-6, -42}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{4, 256}, {80, 316}, {80, 196}, {4, 256}}), Polygon(origin = {-6, -46}, fillColor = {0, 255, 255}, fillPattern = FillPattern.Solid, points = {{4, 256}, {64, 180}, {-56, 180}, {4, 256}})}, coordinateSystem(extent = {{-140, 300}, {140, -120}})));
end FeedbackLoop;
