within Modelitek.Sensors.Conversions;

model Conversion_lh_to_kgs "Convert volumetric flow rate (L/h) to mass flow rate (kg/s)"
  parameter Real density = 1.0 "Fluid density in kg/L";
  Modelica.Blocks.Interfaces.RealInput D_in "Volumetric flow rate [L/h]" annotation(
    Placement(transformation(origin = {0, -2}, extent = {{-124, 4}, {-98, 30}}), iconTransformation(extent = {{-130, -22}, {-100, 8}})));
  Modelica.Blocks.Interfaces.RealOutput D_out "Mass flow rate [kg/s]" annotation(
    Placement(transformation(origin = {-14, 8}, extent = {{20, -4}, {46, 22}}), iconTransformation(extent = {{22, -22}, {50, 6}})));
  Modelica.Blocks.Math.Gain gainTime(k = 1/3600) "Convert hours to seconds" annotation(
    Placement(transformation(extent = {{-74, 10}, {-62, 22}})));
  Modelica.Blocks.Math.Gain gainDensity(k = density) "Convert L to kg using density [kg/L]" annotation(
    Placement(transformation(origin = {-4, 1.6}, extent = {{-32, 6.4}, {-16, 22.4}})));
equation
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-111, 15}, {-76, 15}, {-76, 16}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u);
  connect(gainDensity.y, D_out);
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-110, 18}, {-76, 18}, {-76, 16}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u) annotation(
    Line(points = {{-62, 16}, {-38, 16}}, color = {0, 0, 127}));
  connect(gainDensity.y, D_out) annotation(
    Line(points = {{-20, 16}, {20, 16}, {20, 18}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-180, 60}, {100, -100}}), graphics = {Rectangle(origin = {2, 7}, lineColor = {28, 108, 200}, fillColor = {212, 239, 247}, fillPattern = FillPattern.Solid, extent = {{-104, 39}, {20, -53}}), Text(origin = {-38, 4}, textColor = {0, 0, 255}, extent = {{-70, 27}, {70, -42}}, textString = "L/h → kg/s", fontSize = 48, textStyle = {TextStyle.Bold}), Text(origin = {-42, 201}, textColor = {0, 0, 255}, extent = {{-138, -293}, {142, -257}}, textString = "%name"), Text(origin = {-42, 201}, textColor = {0, 0, 255}, extent = {{-138, -293}, {142, -257}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 40}, {40, 0}}), graphics),
    Documentation(info = "<html>
      <h4>Conversion flow rate</h4>
      <p>This block converts a volumetric flow rate (L/h) into a mass flow rate (kg/s).</p>
      <ul>
        <li>Input: volumetric flow rate in L/h</li>
        <li>Output: mass flow rate in kg/s</li>
      </ul>
      <p>The density of the fluid is set by the parameter <b>density</b>, in kg/L.</p>
      <p><i>Default: density = 1.0 (water at ~20 °C)</i></p>
      </html>"));
end Conversion_lh_to_kgs;
