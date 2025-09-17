within Modelitek.Sensors.Conversions;

model Conversion_kgs_to_ls "Convert mass flow rate (kg/s) to volumetric flow rate (L/s)"
  parameter Real density = 1.0 "Fluid density in kg/L"; 

  Modelica.Blocks.Interfaces.RealInput D_in "Mass flow rate [kg/s]" 
    annotation(Placement(transformation(origin = {-2, 0}, extent = {{-124, 4}, {-98, 30}}), 
                         iconTransformation(extent={{-130,-22},{-100,8}})));

  Modelica.Blocks.Interfaces.RealOutput D_out "Volumetric flow rate [L/s]" 
    annotation(Placement(transformation(origin = {0, 8}, extent = {{20, -4}, {46, 22}}), 
                         iconTransformation(extent={{22,-22},{50,6}})));

  Modelica.Blocks.Math.Gain gainDensity(k=1/density) 
    "Convert kg/s to L/s using density [kg/L]" 
    annotation(Placement(transformation(origin = {2.13163e-14, -3.55271e-15}, extent = {{-48, 8}, {-28, 28}})));

equation
  connect(D_in, gainDensity.u) annotation(
    Line(points = {{-112, 18}, {-50, 18}}, color = {0, 0, 127}));
  connect(gainDensity.y, D_out);
  connect(D_in, gainDensity.u) annotation(
    Line(points = {{-112, 18}, {-50, 18}}, color = {0, 0, 127}));
  connect(gainDensity.y, D_out) annotation(
    Line(points = {{-26, 18}, {34, 18}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,60},{100,-100}}),
      graphics={
        Rectangle(origin = {2, 6},lineColor={28,108,200}, fillColor={212,239,247}, 
                  fillPattern=FillPattern.Solid, extent = {{-104, 46}, {20, -62}}),
        Text(origin={-40,4}, textColor = {85, 0, 255}, 
             extent={{-70,27},{70,-42}}, textString="kg/s → L/s", 
             fontSize=48, textStyle={TextStyle.Bold}), Text(origin = {-42, 201}, textColor = {0, 0, 255}, extent = {{-138, -293}, {142, -257}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-140, 40}, {60, 0}}), graphics),
    Documentation(info="<html>
      <h4>Conversion flow rate</h4>
      <p>This block converts a mass flow rate (kg/s) into a volumetric flow rate (L/s).</p>
      <ul>
        <li>Input: mass flow rate in kg/s</li>
        <li>Output: volumetric flow rate in L/s</li>
      </ul>
      <p>The density of the fluid is set by the parameter <b>density</b>, in kg/L.</p>
      <p><i>Default: density = 1.0 (water at ~20 °C)</i></p>
      </html>")
  );
end Conversion_kgs_to_ls;
