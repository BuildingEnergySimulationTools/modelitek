within Modelitek.Controls;

model PID_withSeasonSign "PID simple avec inversion automatique du signe en été + On/Off pour bloquer la sortie"
  import Modelica.Units.SI;
  // === Paramètres PID ===
  parameter Real kPID = 1 "Gain PID";
  parameter SI.Time Ti = 10 "Temps d'intégration";
  parameter SI.Time Td = 0 "Dérivation";
  parameter Real yMin = 0 "Sortie min";
  parameter Real yMax = 5 "Sortie max";
  parameter Real y_start = 3 "Sortie max";
  // === Entrées ===
  Modelica.Blocks.Interfaces.RealInput T_depart(unit = "K") "Température de départ" annotation(
    Placement(transformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput T_retour(unit = "K") "Température de retour" annotation(
    Placement(transformation(extent = {{-140, -10}, {-100, 30}})));
  Modelica.Blocks.Interfaces.RealInput DeltaT_set(unit = "K") "Consigne de DeltaT" annotation(
    Placement(transformation(extent = {{-140, -60}, {-100, -20}})));
  Modelica.Blocks.Interfaces.BooleanInput isSummer "true => inversion du signe" annotation(
    Placement(transformation(extent = {{-140, -110}, {-100, -70}})));
  Modelica.Blocks.Interfaces.BooleanInput onOff "true => sortie active, false => sortie forcée à 0" annotation(
    Placement(transformation(extent = {{-140, -160}, {-100, -120}})));
  // === Sortie ===
  Modelica.Blocks.Interfaces.RealOutput u_cmd "Commande (typ. dp_in ou m_flow_cmd)" annotation(
    Placement(transformation(origin = {60, -36}, extent = {{100, -10}, {140, 30}}), iconTransformation(extent = {{100, -10}, {140, 30}})));
  // === Calcul ΔT mesuré ===
  Modelica.Blocks.Math.Add deltaMeas(k2 = -1) annotation(
    Placement(transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  // === PID ===
  Modelica.Blocks.Continuous.LimPID pid(controllerType = Modelica.Blocks.Types.SimpleController.PID, k = kPID, Ti = Ti, Td = Td, yMin = yMin, yMax = yMax, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = y_start) annotation(
    Placement(transformation(origin = {20, 4}, extent = {{-10, -10}, {10, 10}})));
  // === Convertisseur été/hiver ===
  Modelica.Blocks.Math.BooleanToReal signConv(realTrue = -1, realFalse = +1) annotation(
    Placement(transformation(origin = {50, -34}, extent = {{-10, -10}, {10, 10}})));
  // === Produit PID * signe ===
  Modelica.Blocks.Math.Product prod annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}})));
  // === On/Off : 0 ou prod.y ===
  Modelica.Blocks.Math.BooleanToReal onOffConv(realTrue = 1, realFalse = 1e-4) annotation(
    Placement(transformation(origin = {88, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product prodOnOff annotation(
    Placement(transformation(origin = {120, -26}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(signConv.y, prod.u2) annotation(
    Line(points = {{62, -34}, {68, -34}, {68, -6}}, color = {0, 0, 127}));
  connect(prod.u1, pid.y) annotation(
    Line(points = {{68, 6}, {68, 4}, {31, 4}}, color = {0, 0, 127}));
  connect(isSummer, signConv.u) annotation(
    Line(points = {{-120, -90}, {-14, -90}, {-14, -34}, {38, -34}}, color = {255, 0, 255}));
  connect(onOff, onOffConv.u) annotation(
    Line(points = {{-120, -140}, {40, -140}, {40, -66}, {76, -66}}, color = {255, 0, 255}));
  connect(prod.y, prodOnOff.u1) annotation(
    Line(points = {{92, 0}, {96, 0}, {96, -20}, {108, -20}}, color = {0, 0, 127}));
  connect(onOffConv.y, prodOnOff.u2) annotation(
    Line(points = {{100, -66}, {108, -66}, {108, -32}}, color = {0, 0, 127}));
  connect(prodOnOff.y, u_cmd) annotation(
    Line(points = {{132, -26}, {180, -26}}, color = {0, 0, 127}));
  connect(T_depart, deltaMeas.u1) annotation(
    Line(points = {{-120, 60}, {-82, 60}, {-82, 26}, {-52, 26}}, color = {0, 0, 127}));
  connect(T_retour, deltaMeas.u2) annotation(
    Line(points = {{-120, 10}, {-52, 10}, {-52, 14}}, color = {0, 0, 127}));
  connect(DeltaT_set, pid.u_m) annotation(
    Line(points = {{-120, -40}, {-40, -40}, {-40, -18}, {20, -18}, {20, -8}}, color = {0, 0, 127}));
  connect(deltaMeas.y, pid.u_s) annotation(
    Line(points = {{-28, 20}, {-14, 20}, {-14, 4}, {8, 4}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {240, 240, 255}, extent = {{-100, 100}, {100, -100}}), Text(origin = {5, 0}, extent = {{-75, 20}, {75, -20}}, textString = "PID±"), Text(extent = {{-80, -60}, {80, -90}}, textString = "On/Off", fontSize = 18)}),
    Documentation(info = "
  <html>
  <p><b>PID_withSeasonSign</b> + On/Off</p>
  <p>
  Bloc PID sur le DeltaT avec inversion automatique du signe en mode été.
  Un On/Off booléen permet de forcer la sortie à zéro sans modifier l'état du PID.
  </p>
  <h5>Logique</h5>
  <ul>
    <li>ΔT_mesuré = T_depart - T_retour</li>
    <li>error = DeltaT_set - ΔT_mesuré</li>
    <li>u_pid = PID(error)</li>
    <li>u_signed = u_pid   (hiver)</li>
    <li>u_signed = -u_pid  (été)</li>
    <li>u_cmd = u_signed * (onOff ? 1 : 0)</li>
  </ul>
  </html>
  "),
    Diagram(coordinateSystem(extent = {{-140, 80}, {180, -160}})));
end PID_withSeasonSign;
