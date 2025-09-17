within Modelitek.Hvac.Tanks.Examples;

model Example_reverseFlow
  replaceable package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220.0, X_a = 0.40) "Medium model for glycol";
  Buildings.Fluid.Sources.Boundary_pT boundary_pT(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {92, 8}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Buildings.Fluid.Sources.Boundary_pT in_echangeur1(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-74, -52}, extent = {{8, -8}, {-8, 8}}, rotation = -180)));
  Buildings.Fluid.Sources.MassFlowSource_T In_CAPT(redeclare package Medium = Medium, nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-51, 11}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Buildings.Fluid.Sources.MassFlowSource_T In_PAC(redeclare package Medium = Medium, nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {48, -50}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 12, f = 1.15e-5, offset = 273.15+ 20) annotation(
    Placement(visible = true, transformation(origin = {-100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 10, f = 1.25e-5, offset = 273.15+ 3) annotation(
    Placement(visible = true, transformation(origin = {86, -48}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1.115) annotation(
    Placement(visible = true, transformation(origin = {-96, -5}, extent = {{-14, -7}, {14, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 2) annotation(
    Placement(visible = true, transformation(origin = {88, -77}, extent = {{14, -7}, {-14, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression hiver(y = 0) annotation(
    Placement(transformation(origin = {-18, 29}, extent = {{-14, -7}, {14, 7}})));
  SimpleTank_reverseFlow simpleTank_reverseFlow(redeclare package Medium = Medium, nSeg = 20)  annotation(
    Placement(transformation(origin = {-3, -19}, extent = {{13, -13}, {-13, 13}}, rotation = -0)));
equation
  connect(sine.y, In_CAPT.T_in) annotation(
    Line(points = {{-89, 20}, {-79, 20}, {-79, 14}, {-59, 14}}, color = {0, 0, 127}));
  connect(sine1.y, In_PAC.T_in) annotation(
    Line(points = {{75, -48}, {57, -48}, {57, -46}}, color = {0, 0, 127}));
  connect(realExpression.y, In_CAPT.m_flow_in) annotation(
    Line(points = {{-80.6, -5}, {-72.6, -5}, {-72.6, 17}, {-59, 17}}, color = {0, 0, 127}));
  connect(realExpression1.y, In_PAC.m_flow_in) annotation(
    Line(points = {{72.6, -77}, {68.6, -77}, {68.6, -45}, {58.6, -45}}, color = {0, 0, 127}));
  connect(hiver.y, simpleTank_reverseFlow.reverseFlow) annotation(
    Line(points = {{-3, 29}, {-3, -8}, {-2, -8}}, color = {0, 0, 127}));
  connect(In_CAPT.ports[1], simpleTank_reverseFlow.port_downstream_in) annotation(
    Line(points = {{-44, 12}, {-30, 12}, {-30, -12}, {-16, -12}}, color = {0, 127, 255}));
  connect(in_echangeur1.ports[1], simpleTank_reverseFlow.port_downstream_out) annotation(
    Line(points = {{-66, -52}, {-36, -52}, {-36, -24}, {-16, -24}, {-16, -26}}, color = {0, 127, 255}));
  connect(boundary_pT.ports[1], simpleTank_reverseFlow.port_upstream_out) annotation(
    Line(points = {{84, 8}, {38, 8}, {38, -12}, {10, -12}}, color = {0, 127, 255}));
  connect(In_PAC.ports[1], simpleTank_reverseFlow.port_upstream_in) annotation(
    Line(points = {{40, -50}, {22, -50}, {22, -24}, {10, -24}}, color = {0, 127, 255}));
  annotation(
  Documentation(info= "<html><head></head><body><h4>Overview</h4><div><br></div><div><b><u><font size=\"5\">NEEDS TO BE CHECKED, PAS SURE QU'IL FONCTIONNE CORRECTEMENT (#teehub)</font></u></b></div>
  <p>
    This example demonstrates the use of <code>SimpleTank_reverseFlow</code>, 
    a stratified buffer tank with switchable upstream and downstream connections.
  </p>

  <h4>Configuration</h4>
  <ul>
    <li><b>Medium:</b> Propylene glycol-water mixture (40% mass fraction, property_T=220 K)</li>
    <li><b>Upstream side:</b> Heat pump represented by a <code>MassFlowSource_T</code> with 
        varying temperature and flow rate.</li>
    <li><b>Downstream side:</b> Collector loop represented by another 
        <code>MassFlowSource_T</code>, with its return connected to a boundary condition.</li>
    <li><b>Boundary conditions:</b> Fixed pressure boundaries are placed at both ends 
        of the circuit.</li>
  </ul>

  <h4>Control</h4>
  <p>
    The <code>reverseFlow</code> input of the tank is driven by the signal 
    <code>hiver</code>. In this example, <code>hiver=0</code>, so the tank operates 
    in normal flow mode:
  </p>
  <ul>
    <li><b>Normal mode (reverseFlow=0):</b> 
        upstream enters from the bottom, exits from the top; 
        downstream enters from the top, exits from the bottom.</li>
    <li><b>Reversed mode (reverseFlow=1):</b> 
        upstream enters from the top, exits from the bottom; 
        downstream enters from the bottom, exits from the top.</li>
  </ul>

  <h4>Signals</h4>
  <ul>
    <li><b>Sine source 1:</b> provides a slowly varying supply temperature 
        (20 °C ± 12 °C).</li>
    <li><b>Sine source 2:</b> provides another variable inlet temperature 
        (3 °C ± 10 °C).</li>
    <li><b>Flow rate inputs:</b> fixed at ~1.115 kg/s for the collector and 
        2 kg/s for the heat pump in this test case.</li>
  </ul>

  <h4>Purpose</h4>
  <p>
    This test case is intended to validate the <code>SimpleTank_reverseFlow</code> 
    component under dynamic inlet conditions and to illustrate the effect of 
    reversible flow control on tank stratification.
  </p>

</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(lineColor = {0, 128, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-96, -100}, {104, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {0, 128, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-34, 56}, {70, 0}, {-32, -58}, {-34, 56}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 40}, {120, -80}})),
    experiment(StopTime = 86400, Interval = 60));
end Example_reverseFlow;
