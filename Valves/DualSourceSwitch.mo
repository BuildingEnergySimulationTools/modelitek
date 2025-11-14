within Modelitek.Valves;

model DualSourceSwitch "Simplified 3-way valve selecting between two sources"
  // === Parameters ===
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium = Buildings.Media.Air "Air"), choice(redeclare package Medium = Buildings.Media.Water "Water"), choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Real m_flow_nominal(unit = "kg/s") = 1 "Nominal mass flow rate";
  parameter Real dpValve_nominal(unit = "Pa") = 2000 "Nominal pressure drop";
  // === Control input ===
  Modelica.Blocks.Interfaces.RealInput y(min = 0, max = 1) "Actuator position (0=use source 1, 1=use source 2)" annotation(
    Placement(transformation(origin = {-4, 184}, extent = {{-20, -20}, {20, 20}}, rotation = 270), iconTransformation(origin = {-40, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 270)));
  // === Fluid ports ===
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "Common inlet (base)" annotation(
    Placement(transformation(extent = {{-114, 10}, {-94, 30}}), iconTransformation(origin = {14, -34}, extent = {{-114, 10}, {-94, 30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium = Medium) "Inlet source 1" annotation(
    Placement(transformation(extent = {{74, -182}, {94, -162}}), iconTransformation(origin = {-14, 80}, extent = {{74, -182}, {94, -162}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium = Medium) "Inlet source 2" annotation(
    Placement(transformation(extent = {{74, 22}, {94, 42}}), iconTransformation(origin = {-14, -30}, extent = {{74, 22}, {94, 42}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "Common outlet (base)" annotation(
    Placement(transformation(extent = {{-114, -92}, {-94, -72}}), iconTransformation(origin = {14, 34}, extent = {{-114, -92}, {-94, -72}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = Medium) "Outlet 1 (connected to source 1 path)" annotation(
    Placement(transformation(extent = {{74, -102}, {94, -82}}), iconTransformation(origin = {-14, 32}, extent = {{74, -102}, {94, -82}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium = Medium) "Outlet 2 (connected to source 2 path)" annotation(
    Placement(transformation(extent = {{74, 108}, {94, 128}}), iconTransformation(origin = {-14, -80}, extent = {{74, 108}, {94, 128}})));
  // === Internal valves ===
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage v_a_to_b1(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, dpValve_nominal = dpValve_nominal);
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage v_a_to_b2(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, dpValve_nominal = dpValve_nominal);
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage v_a1_to_b(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, dpValve_nominal = dpValve_nominal);
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage v_a2_to_b(redeclare package Medium = Medium, m_flow_nominal = m_flow_nominal, dpValve_nominal = dpValve_nominal);
equation
// Control logic
  v_a_to_b1.y = if y < 0.5 then 1 else 0;
  v_a_to_b2.y = if y >= 0.5 then 1 else 0;
  v_a1_to_b.y = if y < 0.5 then 1 else 0;
  v_a2_to_b.y = if y >= 0.5 then 1 else 0;
// Connections
  connect(port_a, v_a_to_b1.port_a);
  connect(v_a_to_b1.port_b, port_b1);
  connect(port_a, v_a_to_b2.port_a);
  connect(v_a_to_b2.port_b, port_b2);
  connect(port_a1, v_a1_to_b.port_a);
  connect(v_a1_to_b.port_b, port_b);
  connect(port_a2, v_a2_to_b.port_a);
  connect(v_a2_to_b.port_b, port_b);
  annotation(
    Documentation(info = "
      <html>
      <h4>ThreeWayValve</h4>
      <p>Three-way valve allowing to select between <b>two sources</b> (source 1 and source 2).</p>
      <h5>Behavior</h5>
      <ul>
        <li><b>y = 0:</b> Flow from <code>port_a → port_b1</code> and <code>port_a1 → port_b</code></li>
        <li><b>y = 1:</b> Flow from <code>port_a → port_b2</code> and <code>port_a2 → port_b</code></li>
      </ul>
      </html>
    "),
    Diagram(coordinateSystem(extent = {{-120, 200}, {100, -180}})),
    Icon(graphics = {Rectangle(origin = {-40, -29}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-40, 15}, {40, -15}}), Polygon(origin = {42, -6}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{-40, -8}, {20, 38}, {20, 10}, {-40, -38}, {-40, -8}, {-40, -8}}), Polygon(origin = {41, -49}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{-39, 33}, {19, -13}, {19, -37}, {-39, 5}, {-39, 33}, {-39, 33}}), Rectangle(origin = {-24, -180}, lineColor = {238, 46, 47}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{24, 100}, {72, 60}}), Text(origin = {-22, -180}, textColor = {238, 46, 47}, extent = {{22, 98}, {76, 62}}, textString = "0"), Rectangle(origin = {-20, -28}, lineColor = {238, 46, 47}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{24, 100}, {72, 60}}), Text(origin = {-22, -28}, textColor = {238, 46, 47}, extent = {{22, 98}, {76, 62}}, textString = "1"), Text(origin = {0, -551}, textColor = {0, 0, 255}, extent = {{-83, 371}, {50, 451}}, textString = "%name")}, coordinateSystem(extent = {{-100, 80}, {80, -120}})));
end DualSourceSwitch;
