within Modelitek.Sensors;

model EnergyMeter
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choices(choice(redeclare package Medium = Buildings.Media.Air "Moist air"), choice(redeclare package Medium = Buildings.Media.Water "Water"), choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T = 220, X_a = 0.40) "Propylene glycol water, 40% mass fraction")));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(extent = {{-108, 88}, {-88, 108}}), iconTransformation(origin = {24, -42}, extent = {{-108, 84}, {-88, 104}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = Medium) "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(extent = {{-88, -80}, {-108, -60}}), iconTransformation(origin = {28, 0}, extent = {{-84, -220}, {-104, -200}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "Fluid connector b (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(extent = {{90, 88}, {70, 108}}), iconTransformation(origin = {-8, -46}, extent = {{90, 88}, {70, 108}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium = Medium) "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation(
    Placement(transformation(extent = {{66, -78}, {86, -58}}), iconTransformation(origin = {-14, -6}, extent = {{70, -218}, {90, -198}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu = 2) annotation(
    Placement(transformation(extent = {{-12, -4}, {6, 14}})));
  Modelica.Blocks.Math.Gain a1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-46, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator2(k = 1/3.6e6) annotation(
    Placement(transformation(extent = {{44, 48}, {58, 62}})));
  Modelica.Blocks.Interfaces.RealOutput Q_cumul "production thermique" annotation(
    Placement(transformation(origin = {87, 55}, extent = {{-13, -13}, {13, 13}}), iconTransformation(origin = {38, -114}, extent = {{-14, -14}, {14, 14}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate H_distri_out(redeclare package Medium = Medium, m_flow_nominal = 1) "Enthalpy flow rate" annotation(
    Placement(visible = true, transformation(origin = {-2.22045e-16, 98}, extent = {{-14, 14}, {14, -14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q "production thermique" annotation(
    Placement(transformation(origin = {88, -26}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {38, -34}, extent = {{-14, -14}, {14, 14}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate H_distri_out1(redeclare package Medium = Medium, m_flow_nominal = 1) "Enthalpy flow rate" annotation(
    Placement(visible = true, transformation(extent = {{16, -88}, {-18, -54}}, rotation = 0)));
equation
  connect(multiSum.y, integrator2.u) annotation(
    Line(points = {{7.53, 5}, {23.765, 5}, {23.765, 55}, {42.6, 55}}, color = {0, 0, 127}));
  connect(integrator2.y, Q_cumul) annotation(
    Line(points = {{58.7, 55}, {87, 55}}, color = {0, 0, 127}));
  connect(multiSum.y, Q) annotation(
    Line(points = {{7.53, 5}, {41.765, 5}, {41.765, -26}, {88, -26}}, color = {0, 0, 127}));
  connect(H_distri_out1.H_flow, a1.u) annotation(
    Line(points = {{-1, -52}, {-18, -52}, {-18, -24}, {-72, -24}, {-72, 4}, {-58, 4}}, color = {0, 0, 127}));
  connect(H_distri_out1.port_a, port_a2) annotation(
    Line(points = {{16, -70}, {76, -70}, {76, -68}}, color = {0, 127, 255}));
  connect(H_distri_out1.port_b, port_b1) annotation(
    Line(points = {{-18, -70}, {-98, -70}}, color = {0, 127, 255}));
  connect(H_distri_out.port_a, port_a) annotation(
    Line(points = {{-14, 98}, {-98, 98}}, color = {0, 127, 255}));
  connect(H_distri_out.port_b, port_b) annotation(
    Line(points = {{14, 98}, {80, 98}}, color = {0, 127, 255}));
  connect(H_distri_out.H_flow, multiSum.u[1]) annotation(
    Line(points = {{0, 82}, {0, 32}, {-26, 32}, {-26, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(a1.y, multiSum.u[2]) annotation(
    Line(points = {{-34, 4}, {-23, 4}, {-23, 6}, {-12, 6}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-160, 100}, {160, -300}}), graphics = {Rectangle(origin = {7, -35}, fillColor = {28, 108, 200}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-64, 123}, {47, 37}}), Rectangle(origin = {3, -42}, fillPattern = FillPattern.Backward, extent = {{-31, 44}, {21, -120}}), Text(origin = {0, 28},textColor = {0, 0, 255}, extent = {{-148, -326}, {152, -286}}, textString = "%name"), Text(textColor = {238, 46, 47}, extent = {{-28, -160}, {26, -196}}, textString = "0"), Rectangle(origin = {4, -53}, fillColor = {28, 108, 200}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-54, -107}, {45, -199}}), Rectangle(origin = {-3, -46}, lineColor = {238, 46, 47}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-43, 100}, {21, 84}}), Polygon(origin = {-14, -54}, lineColor = {238, 46, 47}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{26, 120}, {26, 80}, {56, 102}, {26, 120}}), Polygon(origin = {-14, 0}, lineColor = {238, 46, 47}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{6, -190}, {6, -230}, {-26, -210}, {6, -190}}), Rectangle(origin = {21, -294}, lineColor = {238, 46, 47}, fillColor = {238, 46, 47}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-39, 91}, {19, 76}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 120}, {100, -100}}), graphics),
    Documentation(info = "<html>
  <h4>EnergyMeter</h4>
  <p>
    This block measures the thermal energy flow through a hydraulic system.
    It is based on enthalpy flow rate sensors located on the supply and return
    lines.
  </p>

  <h5>Functionality</h5>
  <ul>
    <li>Computes the instantaneous thermal power <b>Q</b> (W) as the difference
        between supply and return enthalpy flow rates.</li>
    <li>Integrates the thermal power over time to compute the cumulative thermal
        energy <b>Q_cumul</b> (kWh).</li>
  </ul>

  <h5>Connectors</h5>
  <ul>
    <li><b>port_a</b>, <b>port_b</b>: Fluid ports for the supply line
        (positive flow direction: port_a → port_b).</li>
    <li><b>port_a2</b>, <b>port_b1</b>: Fluid ports for the return line
        (positive flow direction: port_a2 → port_b1).</li>
    <li><b>Q</b>: Instantaneous thermal power output [W].</li>
    <li><b>Q_cumul</b>: Cumulative thermal energy output [kWh].</li>
  </ul>

  <h5>Parameters</h5>
  <ul>
    <li><b>Medium</b>: Replaceable fluid medium
      (default choices: moist air, water, propylene glycol/water mixture).</li>
  </ul>

  <h5>Notes</h5>
  <ul>
    <li>The integration constant is scaled by 1/3.6e6 to convert W·s into kWh.</li>
    <li>By convention, a positive result corresponds to net heat production
        through the measured system.</li>
  </ul>
  </html>"));
end EnergyMeter;
