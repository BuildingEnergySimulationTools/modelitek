within Modelitek.Sensors.Conversions;

model Conversion_kgs_to_m3h "Convert mass flow rate (kg/s) to volumetric flow rate (m3/h)"
  parameter Real density = 1.0 "Fluid density in kg/L";
  Modelica.Blocks.Interfaces.RealInput D_in "Mass flow rate [kg/s]" annotation(
    Placement(transformation(origin = {-9.07692, -15.6923}, extent = {{-108.923, 3.69231}, {-84.9231, 27.6923}}), iconTransformation(origin = {-8, 6}, extent = {{-130, -22}, {-100, 8}})));
  Modelica.Blocks.Interfaces.RealOutput D_out "Volumetric flow rate [m3/h]" annotation(
    Placement(transformation(origin = {-3.07692, -13.8462}, extent = {{35.0769, 1.84615}, {59.0769, 25.8462}}), iconTransformation(origin = {-4, 4}, extent = {{22, -22}, {50, 6}})));
  Modelica.Blocks.Math.Gain gainTime(k = 3600) "Convert seconds to hours" annotation(
    Placement(transformation(origin = {-2, -16}, extent = {{-74, 10}, {-62, 22}})));
  Modelica.Blocks.Math.Gain gainDensity(k = 1/(density*1000)) "Convert kg to m3 using density (kg/L -> kg/m3)" annotation(
    Placement(transformation(origin = {10, -16}, extent = {{-48, 10}, {-36, 22}})));
  Modelica.Blocks.Math.Abs abs1 "Ensure positive flow output" annotation(
    Placement(transformation(origin = {2, 0}, extent = {{-6, -6}, {6, 6}})));
equation
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-106, 0}, {-77, 0}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u) annotation(
    Line(points = {{-63, 0}, {-38.4, 0}}, color = {0, 0, 127}));
  connect(gainDensity.y, abs1.u) annotation(
    Line(points = {{-25.4, 0}, {-5, 0}}, color = {0, 0, 127}));
  connect(abs1.y, D_out) annotation(
    Line(points = {{8.6, 0}, {44.6, 0}}, color = {0, 0, 127}));
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-104, 18}, {-76, 18}, {-76, 16}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u) annotation(
    Line(points = {{-62, 16}, {-50, 16}}, color = {0, 0, 127}));
  connect(gainDensity.y, abs1.u) annotation(
    Line(points = {{-24, 16}, {6, 16}}, color = {0, 0, 127}));
  connect(abs1.y, D_out) annotation(
    Line(points = {{20, 16}, {52, 16}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-180, 60}, {100, -100}}), graphics = {Rectangle(origin = {-4, 8}, lineColor = {28, 108, 200}, fillColor = {212, 239, 247}, fillPattern = FillPattern.Solid, extent = {{-104, 46}, {20, -62}}), Text(origin = {-36, 6}, textColor = {85, 0, 255}, extent = {{-70, 27}, {70, -42}}, textString = "kg/s → m3/h", fontSize = 48, textStyle = {TextStyle.Bold}), Text(origin = {-42, 201}, textColor = {0, 0, 255}, extent = {{-138, -293}, {142, -257}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 20}, {60, -20}}), graphics),
    Documentation(info = "<html>
      <h4>Conversion flow rate</h4>
      <p>This block converts a mass flow rate (kg/s) into a volumetric flow rate (m³/h).</p>
      <ul>
        <li>Input: mass flow rate in kg/s</li>
        <li>Output: volumetric flow rate in m³/h</li>
      </ul>
      <p>The density of the fluid is set by the parameter <b>density</b>, in kg/L.</p>
      <p><i>Default: density = 1.0 (water at ~20 °C)</i></p>
      </html>"));
end Conversion_kgs_to_m3h;
