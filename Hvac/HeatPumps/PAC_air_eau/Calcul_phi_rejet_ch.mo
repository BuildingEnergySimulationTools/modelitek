within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Calcul_phi_rejet_ch
  Modelica.Blocks.Interfaces.RealInput P_compma_LR annotation(
    Placement(visible = true, transformation(origin = {-108, 12}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, -2}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_fou_LR annotation(
    Placement(visible = true, transformation(origin = {-110, -38}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, -82}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_comp_LR annotation(
    Placement(visible = true, transformation(origin = {-107, 55}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 81}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ph_rejet annotation(
    Placement(visible = true, transformation(origin = {102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MultiSum multiSum(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-24, 12}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-62, -38}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {46, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {6, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(gain.y, multiSum.u[1]) annotation(
    Line(points = {{-55, -38}, {-50, -38}, {-50, 12}, {-30, 12}}, color = {0, 0, 127}));
  connect(P_compma_LR, multiSum.u[2]) annotation(
    Line(points = {{-108, 12}, {-30, 12}}, color = {0, 0, 127}));
  connect(P_comp_LR, multiSum.u[3]) annotation(
    Line(points = {{-107, 55}, {-50, 55}, {-50, 12}, {-30, 12}}, color = {0, 0, 127}));
  connect(const.y, min.u2) annotation(
    Line(points = {{12, -24}, {24, -24}, {24, -10}, {34, -10}}, color = {0, 0, 127}));
  connect(multiSum.y, min.u1) annotation(
    Line(points = {{-16, 12}, {6, 12}, {6, 2}, {34, 2}}, color = {0, 0, 127}));
  connect(min.y, ph_rejet) annotation(
    Line(points = {{57, -4}, {102, -4}}, color = {0, 0, 127}));
  connect(P_fou_LR, gain.u) annotation(
    Line(points = {{-110, -38}, {-69, -38}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end Calcul_phi_rejet_ch;
