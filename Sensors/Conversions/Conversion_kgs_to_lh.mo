within Modelitek.Sensors.Conversions;

model Conversion_kgs_to_lh "Convert mass flow rate (kg/s) to volumetric flow rate (L/h)"
  parameter Real density = 1.0 "Fluid density in kg/L";

  Modelica.Blocks.Interfaces.RealInput D_in "Mass flow rate [kg/s]" 
    annotation(Placement(transformation(origin = {-7.53846, 0.307692}, extent = {{-114.462, 3.69231}, {-90.4615, 27.6923}}), 
                         iconTransformation(extent={{-130,-22},{-100,8}})));

  Modelica.Blocks.Interfaces.RealOutput D_out "Volumetric flow rate [L/h]" 
    annotation(Placement(transformation(origin = {-12.4615, 7.69231}, extent = {{18.4615, -3.69231}, {42.4615, 20.3077}}), 
                         iconTransformation(extent={{22,-22},{50,6}})));

  Modelica.Blocks.Math.Gain gainTime(k=3600) 
    "Convert seconds to hours"
    annotation(Placement(transformation(extent={{-74,10},{-62,22}})));

  Modelica.Blocks.Math.Gain gainDensity(k=1/density) 
    "Convert kg to L using density [kg/L]" 
    annotation(Placement(transformation(origin = {-10, 5.2}, extent = {{-24, 4.8}, {-12, 16.8}})));

equation
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-110, 16}, {-75, 16}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u) annotation(
    Line(points = {{-61, 16}, {-35, 16}}, color = {0, 0, 127}));
  connect(gainDensity.y, D_out) annotation(
    Line(points = {{-21, 16}, {18, 16}}, color = {0, 0, 127}));
  connect(D_in, gainTime.u) annotation(
    Line(points = {{-110, 18}, {-76, 18}, {-76, 16}}, color = {0, 0, 127}));
  connect(gainTime.y, gainDensity.u) annotation(
    Line(points = {{-62, 16}, {-38, 16}}, color = {0, 0, 127}));
  connect(gainDensity.y, D_out) annotation(
    Line(points = {{-20, 16}, {34, 16}, {34, 10}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,60},{100,-100}}),
      graphics={
        Rectangle(origin = {2, 3},lineColor={28,108,200}, fillColor={212,239,247},
                  fillPattern=FillPattern.Solid, extent = {{-106, 47}, {20, -63}}),
        Text(origin={-34,8}, textColor = {85, 0, 255}, 
             extent={{-70,27},{70,-42}}, textString="kg/s → L/h", 
             fontSize=48, textStyle={TextStyle.Bold}), Text(origin = {-42, 201}, textColor = {0, 0, 255}, extent = {{-138, -293}, {142, -257}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-120, 40}, {40, 0}}), graphics),
    Documentation(info="<html>
      <h4>Conversion flow rate</h4>
      <p>This block converts a mass flow rate (kg/s) into a volumetric flow rate (L/h).</p>
      <ul>
        <li>Input: mass flow rate in kg/s</li>
        <li>Output: volumetric flow rate in L/h</li>
      </ul>
      <p>The density of the fluid is set by the parameter <b>density</b>, in kg/L.</p>
      <p><i>Default: density = 1.0 (water at ~20 °C)</i></p>
      </html>")
  );
end Conversion_kgs_to_lh;
