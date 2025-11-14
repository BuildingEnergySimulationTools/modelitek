within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Calcul_phi_rejet_ECS
  Modelica.Blocks.Interfaces.RealOutput ph_rejet annotation(
    Placement(visible = true, transformation(origin = {110, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_abs_LR annotation(
    Placement(visible = true, transformation(origin = {-112, 14}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, 66}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_fou_LR annotation(
    Placement(visible = true, transformation(origin = {-110, -38}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-112, -54}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-34, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  connect(P_abs_LR, add.u1) annotation(
    Line(points = {{-112, 14}, {-54, 14}, {-54, 10}, {-46, 10}}, color = {0, 0, 127}));
  connect(P_fou_LR, add.u2) annotation(
    Line(points = {{-110, -38}, {-52, -38}, {-52, -2}, {-46, -2}}, color = {0, 0, 127}));
  connect(add.y, ph_rejet) annotation(
    Line(points = {{-22, 4}, {22, 4}, {22, 14}, {110, 14}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
end Calcul_phi_rejet_ECS;
