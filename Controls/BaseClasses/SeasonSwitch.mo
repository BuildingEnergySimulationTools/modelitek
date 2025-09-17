within Modelitek.Controls.BaseClasses;
model SeasonSwitch
  Modelica.Blocks.Interfaces.RealInput D_winter annotation(
    Placement(visible = true, transformation(extent = {{-72, -66}, {-46, -40}}, rotation = 0), iconTransformation(extent = {{-112, 62}, {-86, 88}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-20, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput D_summer annotation(
    Placement(visible = true, transformation(extent = {{-72, 48}, {-46, 74}}, rotation = 0), iconTransformation(extent = {{-112, -16}, {-86, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch chaSwi annotation(
    Placement(visible = true, transformation(extent = {{18, -4}, {38, 16}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput D annotation(
    Placement(visible = true, transformation(extent = {{58, -6}, {84, 20}}, rotation = 0), iconTransformation(origin = {101, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput t_period annotation(
    Placement(visible = true, transformation(extent = {{-74, -6}, {-48, 20}}, rotation = 0), iconTransformation(extent = {{-110, -84}, {-84, -58}}, rotation = 0)));
equation
  connect(chaSwi.y, D) annotation(
    Line(points = {{39, 6}, {66, 6}, {66, 7}, {71, 7}}, color = {0, 0, 127}));
  connect(t_period, greaterThreshold.u) annotation(
    Line(points = {{-61, 7}, {-35, 7}, {-35, 5}, {-33, 5}}, color = {0, 0, 127}));
  connect(D_winter, chaSwi.u3) annotation(
    Line(points = {{-59, -53}, {3, -53}, {3, -3}, {15, -3}, {15, -3}}, color = {0, 0, 127}));
  connect(D_summer, chaSwi.u1) annotation(
    Line(points = {{-59, 61}, {3, 61}, {3, 13}, {15, 13}, {15, 13}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, chaSwi.u2) annotation(
    Line(points = {{-9, 6}, {15, 6}, {15, 6}, {15, 6}}, color = {255, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(fillColor = {170, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {2, -2}, extent = {{-40, 124}, {40, -124}}, textString = "D")}),
    Diagram(coordinateSystem(extent = {{-80, -120}, {80, 120}})),
    version = "");
end SeasonSwitch;
