within Modelitek.Controls.Hvac;

model DhwControl_cstSetpoint
  //  parameter Boolean bool = true ;
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(
    Placement(visible = true, transformation(extent = {{0, 102}, {20, 122}}, rotation = 0)));
  Modelica.StateGraph.InitialStep initialStep(nIn = 1, nOut = 1) annotation(
    Placement(visible = true, transformation(origin = {-72, 134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.StateGraph.TransitionWithSignal toOn(enableTimer = true, waitTime = params.Temps_avant_releve) "Transition to on" annotation(
    Placement(visible = true, transformation(origin = {-72, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.StateGraph.StepWithSignal P_active(nIn = 1, nOut = 1) annotation(
    Placement(visible = true, transformation(origin = {-72, 48}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.StateGraph.TransitionWithSignal toOff(enableTimer = false, waitTime = 10) "Transition to off" annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput T_top_tank annotation(
    Placement(visible = true, transformation(origin = {-386, 160}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-258, -28}, {-218, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Demande_ECS annotation(
    Placement(transformation(origin = {-112, 78}, extent = {{114, -46}, {144, -16}}), iconTransformation(origin = {-262, 62}, extent = {{172, -90}, {210, -52}})));
  Modelitek.Controls.Data.params_Control_pac params(Delta_Activ_ECS_summer = 5, Delta_Activ_ECS_winter = 7, Delta_Arret_BT = 0, Delta_Arret_ECS = 2, T_arret_normal_ECS = 52 + 273.15, T_marche_normal = 45 + 273.15, Temps_avant_releve = 60*60, coeff_T_bas_BT = 0.25, coeff_T_haut_BT = 0.75, marche_normal = true) annotation(
    Placement(visible = true, transformation(origin = {-154, 138}, extent = {{-224, -76}, {-204, -56}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = params.T_arret_normal_ECS) annotation(
    Placement(visible = true, transformation(origin = {-301, -11}, extent = {{-53, -13}, {53, 13}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-212, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = params.T_marche_normal) annotation(
    Placement(visible = true, transformation(origin = {-287, 93}, extent = {{-49, -10}, {49, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {-188, 102}, extent = {{-38, -108}, {-18, -88}}, rotation = 0)));
equation
  connect(initialStep.outPort[1], toOn.inPort) annotation(
    Line(points = {{-72, 123.5}, {-72, 102}}));
  connect(toOn.outPort, P_active.inPort[1]) annotation(
    Line(points = {{-72, 96.5}, {-72, 59}}));
  connect(P_active.outPort[1], toOff.inPort) annotation(
    Line(points = {{-72, 37.5}, {-70, 37.5}, {-70, 4}}));
  connect(toOff.outPort, initialStep.inPort[1]) annotation(
    Line(points = {{-70, -1.5}, {-70, -22}, {-36, -22}, {-36, 145}, {-72, 145}}));
  connect(P_active.active, Demande_ECS) annotation(
    Line(points = {{-61, 48}, {17, 48}}, color = {255, 0, 255}));
  connect(T_top_tank, less1.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, 104}, {-224, 104}}, color = {0, 0, 127}));
  connect(T_top_tank, greaterEqual.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, 4}, {-228, 4}}, color = {0, 0, 127}));
  connect(realExpression.y, greaterEqual.u2) annotation(
    Line(points = {{-242.7, -11}, {-231.7, -11}, {-231.7, -4}, {-227.7, -4}}, color = {0, 0, 127}));
  connect(realExpression3.y, less1.u2) annotation(
    Line(points = {{-233, 93}, {-228.5, 93}, {-228.5, 96}, {-224, 96}}, color = {0, 0, 127}));
  connect(greaterEqual.y, toOff.condition) annotation(
    Line(points = {{-204, 4}, {-82, 4}, {-82, 0}}, color = {255, 0, 255}));
  connect(less1.y, toOn.condition) annotation(
    Line(points = {{-200, 104}, {-84, 104}, {-84, 98}}, color = {255, 0, 255}));
  annotation(
  Documentation(info = "
<html>
<h4>DhwControl_cstSetpoint</h4>
<p>
This model implements a simplified control logic for <b>domestic hot water (DHW)</b> production, 
based on a constant temperature setpoint at the top of a storage tank.
</p>

<h5>Functionality</h5>
<p>
The control is modeled using a <code>StateGraph</code> structure with two states:
<ul>
  <li><b>Inactive</b> (no DHW request)</li>
  <li><b>Active</b> (DHW request issued to the heat pump)</li>
</ul>
The transition between these states depends on the measured temperature at the 
top of the tank (<code>T_top_tank</code>) and the configured temperature thresholds.
</p>

<h5>Inputs</h5>
<ul>
  <li><b>T_top_tank</b>: Measured temperature at the top of the storage tank [K].</li>
</ul>

<h5>Outputs</h5>
<ul>
  <li><b>Demande_ECS</b>: Boolean output (DHW request). 
      <ul>
        <li><code>true</code> → DHW demand is active, heat pump should start production.</li>
        <li><code>false</code> → DHW demand is inactive, no hot water request.</li>
      </ul>
  </li>
</ul>

<h5>Parameters</h5>
<p>
The thresholds and delays are defined in the <code>params</code> record, for example:
<ul>
  <li><b>T_marche_normal</b>: activation threshold (default: 45 °C).</li>
  <li><b>T_arret_normal_ECS</b>: deactivation threshold (default: 52 °C).</li>
  <li><b>Temps_avant_releve</b>: minimum waiting time before re-activation.</li>
</ul>
</p>

<h5>Control Logic</h5>
<ul>
  <li>If <code>T_top_tank</code> < <code>T_marche_normal</code>, the model transitions to the <b>Active</b> state, issuing a DHW request.</li>
  <li>If <code>T_top_tank</code> ≥ <code>T_arret_normal_ECS</code>, the model transitions to the <b>Inactive</b> state, stopping the DHW request.</li>
</ul>

<h5>Use case</h5>
<p>
This model can be used to generate a DHW request signal for a heat pump 
or boiler, based on a constant temperature setpoint strategy for a buffer tank.
</p>
</html>
"),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-260, 80}, {-40, -100}}), graphics = {Rectangle(origin = {-151, -9}, lineColor = {102, 44, 145}, fillColor = {170, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-103, 79}, {71, -89}}), Text(origin = {-144, -330}, textColor = {0, 0, 255}, extent = {{-98, 238}, {42, 309}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-400, 180}, {40, -20}}), graphics = {Rectangle(origin = {-130, 68}, lineColor = {0, 0, 127}, fillColor = {0, 255, 157}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-176, 72}, {16, 0}}), Text(origin = {-68, 40}, lineColor = {0, 0, 127}, extent = {{-118, 102}, {-60, 92}}, textString = "Activation"), Rectangle(origin = {-131, 79}, lineColor = {0, 0, 127}, fillColor = {255, 191, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-175, -27}, {19, -98}}), Text(origin = {-68, 86}, lineColor = {0, 0, 127}, extent = {{-106, -38}, {-48, -48}}, textString = "Desactivation")}),
    Documentation(info = "<html><head></head><body><br></body></html>"));
end DhwControl_cstSetpoint;
