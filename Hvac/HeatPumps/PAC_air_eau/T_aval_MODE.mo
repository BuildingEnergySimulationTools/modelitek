within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model T_aval_MODE
  parameter Real T_aval_ECS = 60 "Température de consigne départ ECS";
  parameter Real T_aval_Chauffage = 45 "Température de consigne départ chauffage";
  parameter Real T_aval_Clim = 7 "Température de consigne départ Climatisation";
  PAC_air_eau.ModFoncPAC modFoncPAC annotation(
    Placement(transformation(origin = {-32, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Climatisation annotation(
    Placement(visible = true, transformation(origin = {-183, 123}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-120, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ECS annotation(
    Placement(visible = true, transformation(origin = {-181, 13}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-120, 88}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Chauffage annotation(
    Placement(visible = true, transformation(origin = {-189, -93}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-120, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {76, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {234, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {113, 3}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(transformation(origin = {156, 6}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Constant const(k = T_aval_Chauffage) annotation(
    Placement(visible = true, transformation(origin = {-30, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = T_aval_Clim) annotation(
    Placement(transformation(origin = {28, -22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constant1(k = T_aval_ECS) annotation(
    Placement(visible = true, transformation(origin = {84, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Climatisation, modFoncPAC.Q_req_clim) annotation(
    Line(points = {{-182, 124}, {-112, 124}, {-112, 16}, {-44, 16}}, color = {0, 0, 127}));
  connect(ECS, modFoncPAC.Q_req_ECS) annotation(
    Line(points = {{-180, 14}, {-180, 18}, {-44, 18}, {-44, 9}}, color = {0, 0, 127}));
  connect(Chauffage, modFoncPAC.Q_req_chauffage) annotation(
    Line(points = {{-188, -92}, {-88, -92}, {-88, 2}, {-44, 2}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{-19, 88}, {12, 88}, {12, 48}, {64, 48}}, color = {0, 0, 127}));
  connect(modFoncPAC.ModChauf, switch1.u2) annotation(
    Line(points = {{-21, 3}, {-4, 3}, {-4, 40}, {64, 40}}, color = {255, 0, 255}));
  connect(modFoncPAC.ModECS, switch.u2) annotation(
    Line(points = {{-21, 10}, {56.5, 10}, {56.5, 6}, {144, 6}}, color = {255, 0, 255}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{96, -46}, {110, -46}, {110, -2}, {144, -2}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{40, -22}, {52, -22}, {52, 32}, {64, 32}}, color = {0, 0, 127}));
  connect(switch1.y, switch.u3) annotation(
    Line(points = {{88, 40}, {106, 40}, {106, 14}, {144, 14}}, color = {0, 0, 127}));
  connect(switch.y, y) annotation(
    Line(points = {{168, 6}, {180, 6}, {180, 4}, {234, 4}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Documentation(info = "<html><head></head><body><h3>Température aval Mode</h3><p>Ce modèle permet de determiner la température aval que doit fournir la PAC selon la puissance des besoins.</p><p>Il faut noter que le mode ECS est prioritaire aux moments de superposition de besoins d'ECS et de chauffage ou de climatisation.</p><div><div><h4><u>Paramètres du modèle :</u></h4></div><div><ul><li><font face=\"Courier New\">T_aval_ECS: la température consigne pour l'eau chaude sanitaire.</font></li><li><font face=\"Courier New\">T_aval_Chauffage: la température consigne pour le chauffage.</font></li><li><font face=\"Courier New\">T_aval_Clim: la température consigne pour la climatisation.</font></li></ul></div></div><div></div></body></html>"));
end T_aval_MODE;
