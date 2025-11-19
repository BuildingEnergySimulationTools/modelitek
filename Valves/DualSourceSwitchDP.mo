within Modelitek.Valves;

model DualSourceSwitchDP
  "Simplified 3-way valve selecting between two sources (DP-compatible version)"

  parameter Real y_start_valve = 0.0;
  parameter Real T_filter = 0.1 "Filter time constant [s]";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;

  parameter Real m_flow_nominal(unit="kg/s") = 1;
  parameter Real dpValve_nominal(unit="Pa") = 2000;

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    annotation(Placement(transformation(origin = {-4, 184}, extent = {{-20, -20},{20,20}}, rotation = 270)));

  // --- ONLY ONE STATE ---
  Real yFilt(start=y_start_valve, fixed=true);

  // === Fluid ports ===
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{-114,10},{-94,30}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{74,-182},{94,-162}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{74,22},{94,42}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{-114,-92},{-94,-72}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{74,-102},{94,-82}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium = Medium)
    annotation(Placement(transformation(extent = {{74,108},{94,128}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear v_a_to_b1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal);

  Buildings.Fluid.Actuators.Valves.TwoWayLinear v_a_to_b2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal);

  Buildings.Fluid.Actuators.Valves.TwoWayLinear v_a1_to_b(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal);

  Buildings.Fluid.Actuators.Valves.TwoWayLinear v_a2_to_b(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal);

equation
  // === FILTER ===
  der(yFilt) = (y - yFilt) / T_filter;
  assert(yFilt >= 0 and yFilt <= 1, "yFilt out of bounds");

  // === LOGIC (unchanged except filtered input) ===
  v_a_to_b1.y = if yFilt < 0.5 then 1 else 0;
  v_a_to_b2.y = if yFilt >= 0.5 then 1 else 0;

  v_a1_to_b.y = if yFilt < 0.5 then 1 else 0;
  v_a2_to_b.y = if yFilt >= 0.5 then 1 else 0;

  // === Connections ===
  connect(port_a, v_a_to_b1.port_a);
  connect(v_a_to_b1.port_b, port_b1);

  connect(port_a, v_a_to_b2.port_a);
  connect(v_a_to_b2.port_b, port_b2);

  connect(port_a1, v_a1_to_b.port_a);
  connect(v_a1_to_b.port_b, port_b);

  connect(port_a2, v_a2_to_b.port_a);
  connect(v_a2_to_b.port_b, port_b);

annotation(Documentation(info="<html><p>DP-compatible 3-way switch</p></html>"),
           Diagram(graphics), Icon(graphics));

end DualSourceSwitchDP;
