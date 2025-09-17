within Modelitek.Hvac.Tanks;

model SimpleTank_reverseFlow
  "Stratified tank with reversible upstream/downstream flow using DualSourceSwitch"

  replaceable package Medium = Modelica.Media.Water.StandardWater
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Volume VTan=0.3 "Tank volume";
  parameter Modelica.Units.SI.Height hTan=1.5 "Tank height";
  parameter Integer nSeg(min=1)=10 "Number of stratified segments";
  parameter Modelica.Units.SI.Temperature T_start=293.15
    "Initial temperature of the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.2
    "Nominal mass flow rate through the tank";
  parameter Modelica.Units.SI.Length dIns=0.05
    "Insulation thickness of the tank";

  // --- Tank
  Buildings.Fluid.Storage.Stratified tank(
    redeclare package Medium=Medium,
    VTan=VTan,
    hTan=hTan,
    nSeg=nSeg,
    T_start=T_start,
    m_flow_nominal=m_flow_nominal,
    dIns=dIns)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  // --- External ports
  Modelica.Fluid.Interfaces.FluidPort_a port_upstream_in(redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_upstream_out(redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_downstream_in(redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_downstream_out(redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  // --- Switches
  Modelitek.Valves.DualSourceSwitch switch_upstream(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal) annotation(Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelitek.Valves.DualSourceSwitch switch_downstream(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal) annotation(Placement(transformation(extent={{40,0},{60,20}})));

  // --- Control input (0=normal, 1=reversed)
  Modelica.Blocks.Interfaces.RealInput reverseFlow "Control: 0=normal, 1=reversed"
    annotation (Placement(transformation(extent={{-20,80},{20,100}})));

  // --- Outputs
  Modelica.Blocks.Interfaces.RealOutput T_top
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput T_bottom
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

equation 
  // --- Upstream side (through switch_upstream)
  connect(port_upstream_in, switch_upstream.port_a1);
  connect(port_upstream_out, switch_upstream.port_b1);
  connect(switch_upstream.port_a2, tank.port_a);
  connect(switch_upstream.port_b2, tank.port_b);
  connect(reverseFlow, switch_upstream.y);

  // --- Downstream side (through switch_downstream)
  connect(port_downstream_in, switch_downstream.port_a1);
  connect(port_downstream_out, switch_downstream.port_b1);
  connect(switch_downstream.port_a2, tank.port_b);
  connect(switch_downstream.port_b2, tank.port_a);
  connect(reverseFlow, switch_downstream.y);

  // --- Temperatures
  T_top = tank.heaPorVol[1].T;
  T_bottom = tank.heaPorVol[nSeg-1].T;

  annotation (
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,200}, fillColor={173,216,230}, fillPattern=FillPattern.Solid),
        Text(extent={{-60,40},{60,-40}}, textString="Tank\nrev. flow")
      }),
    Documentation(info = "<html><head></head><body><h4>Overview</h4><div><br></div><div><b><u><font size=\"5\">NEEDS TO BE CHECKED, PAS SURE QU'IL FONCTIONNE CORRECTEMENT (#teehub)</font></u></b></div>
    <p>
    Stratified buffer tank with upstream and downstream flow paths that can be reversed.<br>
    Uses <code>DualSourceSwitch</code> blocks to swap top and bottom connections.
    </p>
    <h4>Flow logic</h4>
    <ul>
      <li><b>reverseFlow = 0:</b><br>
        - Upstream enters bottom, exits top<br>
        - Downstream enters top, exits bottom</li>
      <li><b>reverseFlow = 1:</b><br>
        - Upstream enters top, exits bottom<br>
        - Downstream enters bottom, exits top</li>
    </ul>
    </body></html>"));
end SimpleTank_reverseFlow;
