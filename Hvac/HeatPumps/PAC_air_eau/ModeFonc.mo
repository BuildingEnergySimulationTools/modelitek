within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model ModeFonc
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {170, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Chauffage annotation(
    Placement(visible = true, transformation(origin = {-236, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Climatisation annotation(
    Placement(visible = true, transformation(origin = {-234, -74}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ECS annotation(
    Placement(visible = true, transformation(origin = {-240, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {178, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {294, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {113, 3}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput P_besoin_ECS annotation(
    Placement(visible = true, transformation(origin = {44, 180}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-52, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput P_besoin_clim annotation(
    Placement(visible = true, transformation(origin = {170, 178}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput P_besoin_chauf annotation(
    Placement(visible = true, transformation(origin = {-76, 178}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, -122}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {176, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-146, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PAC_air_eau.ModFoncPAC modFoncPAC annotation(
    Placement(visible = true, transformation(origin = {10, 78}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.MultiSum multiSum(nu = 3)  annotation(
    Placement(visible = true, transformation(origin = {247, 5}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
equation
  connect(const.y, switch.u3) annotation(
    Line(points = {{-134, -14}, {12, -14}, {12, -12}, {166, -12}}, color = {0, 0, 127}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{-134, -14}, {-50, -14}, {-50, 46}, {158, 46}}, color = {0, 0, 127}));
  connect(const.y, switch2.u3) annotation(
    Line(points = {{-134, -14}, {-52, -14}, {-52, -84}, {164, -84}}, color = {0, 0, 127}));
  connect(P_besoin_chauf, modFoncPAC.Q_req_chauffage) annotation(
    Line(points = {{-76, 178}, {-76, 108}, {2, 108}, {2, 90}}, color = {0, 0, 127}));
  connect(P_besoin_ECS, modFoncPAC.Q_req_ECS) annotation(
    Line(points = {{44, 180}, {38, 180}, {38, 110}, {10, 110}, {10, 90}}, color = {0, 0, 127}));
  connect(P_besoin_clim, modFoncPAC.Q_req_clim) annotation(
    Line(points = {{170, 178}, {170, 100}, {16, 100}, {16, 90}}, color = {0, 0, 127}));
  connect(modFoncPAC.ModChauf, switch1.u2) annotation(
    Line(points = {{4, 68}, {4, 54}, {158, 54}}, color = {255, 0, 255}));
  connect(modFoncPAC.ModECS, switch.u2) annotation(
    Line(points = {{10, 68}, {10, -4}, {166, -4}}, color = {255, 0, 255}));
  connect(modFoncPAC.ModClim, switch2.u2) annotation(
    Line(points = {{16, 68}, {16, -76}, {164, -76}}, color = {255, 0, 255}));
  connect(ECS, switch.u1) annotation(
    Line(points = {{-240, 10}, {156, 10}, {156, 4}, {166, 4}}, color = {0, 0, 127}));
  connect(Chauffage, switch1.u1) annotation(
    Line(points = {{-236, 84}, {-82, 84}, {-82, 62}, {158, 62}}, color = {0, 0, 127}));
  connect(Climatisation, switch2.u1) annotation(
    Line(points = {{-234, -74}, {86, -74}, {86, -68}, {164, -68}}, color = {0, 0, 127}));
  connect(switch1.y, multiSum.u[1]) annotation(
    Line(points = {{182, 54}, {224, 54}, {224, 4}, {238, 4}, {238, 6}}, color = {0, 0, 127}));
  connect(switch.y, multiSum.u[2]) annotation(
    Line(points = {{190, -4}, {230, -4}, {230, 6}, {238, 6}}, color = {0, 0, 127}));
  connect(switch2.y, multiSum.u[3]) annotation(
    Line(points = {{188, -76}, {226, -76}, {226, 6}, {238, 6}}, color = {0, 0, 127}));
  connect(multiSum.y, y) annotation(
    Line(points = {{258, 6}, {272, 6}, {272, -4}, {294, -4}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 85, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(extent = {{-260, 200}, {300, -100}})));
end ModeFonc;
