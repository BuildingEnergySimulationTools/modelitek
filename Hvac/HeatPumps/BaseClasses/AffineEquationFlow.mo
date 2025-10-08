within Modelitek.Hvac.HeatPumps.BaseClasses;

block AffineEquationFlow "Output the product of a gain value with the input signal"
  Modelica.Blocks.Interfaces.RealInput T(final unit = "K", displayUnit = "degC") "Température entrée amont PAC" annotation(
    Placement(transformation(extent = {{-146, 22}, {-78, 90}}), iconTransformation(extent = {{-110, 26}, {-68, 68}})));
  Modelica.Blocks.Interfaces.RealOutput COP(final unit = "") "COP" annotation(
    Placement(transformation(extent = {{56, -98}, {126, -28}}), iconTransformation(extent = {{58, -90}, {98, -50}})));
  Modelica.Blocks.Interfaces.RealOutput Debit(final unit = "kg/s") "Debit amont" annotation(
    Placement(transformation(extent = {{56, 50}, {126, 120}}), iconTransformation(extent = {{58, 58}, {98, 98}})));
  parameter Real xA(start = 1, unit = "K") "Abscisse du point A [°C]";
  parameter Real yA(start = 1, unit = "K") "Ordonnée du point A [°C]";
  parameter Real xB(start = 1, unit = "K") "Abscisse du point B [°C]";
  parameter Real yB(start = 1, unit = "K") "Ordonnée du point B [°C]";
  parameter Real D(start = 1, unit = "kg/s") "Debit [kg/s]";
  parameter Real time_data(start = 1, unit = "s") "Fréquence de données [s]";
  Real a;
  Real b;
equation
  a = (yB - yA)/(xB - xA);
  b = yA - a*xA;
  COP = a*T + b;
  Debit = D annotation(
    Placement(transformation(extent = {{-122, 76}, {-82, 116}}), iconTransformation(extent = {{-100, 88}, {-72, 116}})),
    Documentation(info = "<html>
<p>
CE model calcul le <em>COP</em> en fonction d'une fonction affine de
<em>T in amont</em>:
</p>
<pre>
y = k * u;
</pre>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-90, -98}, {-90, 102}, {110, 2}, {-90, -98}}, lineColor = {0, 0, 127}, fillColor = {244, 125, 35}, fillPattern = FillPattern.Solid), Text(extent = {{-150, -140}, {150, -100}}, textString = "k=%k"), Text(extent = {{-150, 140}, {150, 100}}, textString = "%name", lineColor = {0, 0, 255})}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-86, -96}, {-86, 104}, {114, 4}, {-86, -96}}, lineColor = {0, 0, 127}, fillColor = {244, 125, 35}, fillPattern = FillPattern.Solid)}));
end AffineEquationFlow;
