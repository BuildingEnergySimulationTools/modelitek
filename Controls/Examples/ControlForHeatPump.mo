within Modelitek.Controls.Examples;

model ControlForHeatPump
  Controls.Hvac.DhwControl_cstSetpoint DHWControl annotation(
    Placement(transformation(origin = {70.586, 35.216}, extent = {{-18.8022, -14.2646}, {13.0169, 12.2268}}, rotation = -0)));
  Controls.Hvac.TankControl TankControl annotation(
    Placement(transformation(origin = {65.7956, -33.0744}, extent = {{-23.5646, -16.2385}, {16.314, 13.9186}})));
  Controls.Hvac.HeatpumpControl Switch_btwn_tanks annotation(
    Placement(transformation(origin = {142.235, 9.92308}, extent = {{-12.2353, -12.9231}, {39.7647, 11.0769}})));
  Hvac.HeatingSetpoint heatingSetpoint annotation(
    Placement(transformation(origin = {-23, -26}, extent = {{-19, -14}, {19, 14}})));
  Modelica.Blocks.Sources.Cosine T_bottom_tank(amplitude = 15, offset = 273.15 + 55, f = 1E-4) annotation(
    Placement(transformation(origin = {28, -184}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine Text_winter(f = 1.12E-5, amplitude = 4, offset = 273.15 + 7) annotation(
    Placement(transformation(origin = {-112, -122}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression setpoint_Tint(y = 273.15 + 21) "kg/s" annotation(
    Placement(transformation(origin = {-114, -149}, extent = {{-14, -7}, {14, 7}})));
  Modelica.Blocks.Sources.Cosine T_top_tank(amplitude = 10, f = 1E-4, offset = 273.15 + 55) annotation(
    Placement(transformation(origin = {28, -152}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Cosine T_top_DHW(amplitude = 15, f = 1E-4, offset = 273.15 + 40) annotation(
    Placement(transformation(origin = {117, -169}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression period_of_year(y = 0) "0 for winter, 1 for summer, 0.5 for inbetween" annotation(
    Placement(transformation(origin = {-114, -167}, extent = {{-14, -7}, {14, 7}})));
equation
  connect(DHWControl.Demande_ECS, Switch_btwn_tanks.bool_DHW) annotation(
    Line(points = {{80, 34}, {88, 34}, {88, 16}, {132, 16}}, color = {255, 0, 255}));
  connect(TankControl.Demande_BT, Switch_btwn_tanks.bool_heatTank) annotation(
    Line(points = {{80, -40}, {88, -40}, {88, 2}, {132, 2}}, color = {255, 0, 255}));
  connect(Text_winter.y, heatingSetpoint.Text) annotation(
    Line(points = {{-101, -122}, {-69, -122}, {-69, -19}, {-40, -19}}, color = {0, 0, 127}));
  connect(T_top_tank.y, TankControl.T_top) annotation(
    Line(points = {{40, -152}, {64, -152}, {64, -72}, {20, -72}, {20, -34}, {44, -34}}, color = {0, 0, 127}));
  connect(T_bottom_tank.y, TankControl.T_bottom) annotation(
    Line(points = {{40, -184}, {72, -184}, {72, -66}, {28, -66}, {28, -42}, {44, -42}}, color = {0, 0, 127}));
  connect(heatingSetpoint.Tconsigne, TankControl.Tconsigne) annotation(
    Line(points = {{-2, -26}, {44, -26}}, color = {0, 0, 127}));
  connect(setpoint_Tint.y, heatingSetpoint.Tdemande) annotation(
    Line(points = {{-99, -149}, {-62, -149}, {-62, -32}, {-40, -32}}, color = {0, 0, 127}));
  connect(period_of_year.y, TankControl.t_period) annotation(
    Line(points = {{-99, -167}, {-34, -167}, {-34, -60}, {60, -60}, {60, -46}}, color = {0, 0, 127}));
  connect(T_top_DHW.y, DHWControl.T_top_tank) annotation(
    Line(points = {{128, -168}, {134, -168}, {134, -82}, {14, -82}, {14, 34}, {54, 34}}, color = {0, 0, 127}));
  annotation(
  Documentation(info = "<html><head></head><body><h4>Overview</h4>
<p>
The <code>ControlForHeatPump</code> example demonstrates supervisory control
for a system with one buffer tank (space heating) and one DHW tank. 
It collects tank temperature signals and demand setpoints, then sends
activation requests to the heat pump through the block <code>Switch_btwn_tanks</code>.
</p>

<h4>Inputs</h4>
<ul>
<li><b>Text_winter (K):</b> Outdoor temperature (sinusoidal profile).</li>
<li><b>setpoint_Tint (K):</b> Indoor temperature setpoint (fixed at 21 °C).</li>
<li><b>period_of_year (-):</b> Operating flag (0=winter, 1=summer, 0.5=mid-season).</li>
<li><b>T_top_tank (K):</b> Top temperature of buffer tank.</li>
<li><b>T_bottom_tank (K):</b> Bottom temperature of buffer tank.</li>
<li><b>T_top_DHW (K):</b> Top temperature of DHW tank.</li>
</ul>

<h4>Controllers</h4>
<ul>
<li><b>HeatingSetpoint:</b> Computes heating setpoint from outdoor and indoor temperatures.</li>
<li><b>TankControl:</b> Supervisory control of the heating buffer tank.
Output <code>Demande_BT</code> requests charging.</li>
<li><b>DHWControl_cstSetpoint:</b> Supervisory control of the DHW tank.
Output <code>Demande_ECS</code> requests charging.</li>
</ul>

<h4>Core logic</h4>
<p>
<code>Switch_btwn_tanks</code> arbitrates between DHW and buffer tank demands.
It decides when the heat pump should be on and which tank should be charged.
</p>

<h4>Outputs of Switch_btwn_tanks</h4>
<ul>
<li><b>switch_between_tanks</b><b>&nbsp;(real):</b>&nbsp;0 or 1, usefull with component DualSourceSwitch to orient fluid downstream</li>
<li><b>bool_activation_heatpump (Boolean):</b>&nbsp;activation on/off of the heatpump if required</li><li>Cycles of the heatpump (cumulated)</li>
</ul>

<h4>Notes</h4>
<ul>
<li>Tank temperatures here are generated by cosine signals, not detailed thermal models.</li>
<li>This example focuses only on control logic; no physical heat pump is included.</li>
</ul>

</body></html>"),
    Diagram(coordinateSystem(extent = {{-140, 60}, {200, -220}}), graphics = {Rectangle(origin = {-34, -25}, extent = {{40, -25}, {-40, 25}}), Text(origin = {-53, -4}, extent = {{-15, 4}, {15, -4}}, textString = "Heating curve"), Rectangle(origin = {73, -30}, extent = {{-39, 26}, {39, -26}}), Text(origin = {70, -11}, extent = {{-36, 6}, {36, -6}}, textString = "Buffer tank (heating) control"), Rectangle(origin = {73, 37}, extent = {{-39, 27}, {39, -27}}), Text(origin = {73, 52}, extent = {{-31, 8}, {31, -8}}, textString = "DHW requests to the heat pump"), Rectangle(origin = {162, 11}, extent = {{-39, 27}, {39, -27}}), Text(origin = {167, -21}, extent = {{-39, 9}, {39, -9}}, textString = "Activation of heatpump and choice 
between DHW and heatbuffer tank.
 Here only one is modelled downstream"), Rectangle(origin = {29, -169}, fillColor = {85, 170, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-31, 39}, {31, -39}}), Rectangle(origin = {116, -170}, fillColor = {85, 170, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-31, 39}, {31, -39}}), Rectangle(origin = {-94, -148}, fillColor = {170, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-44, 48}, {44, -48}}), Text(origin = {-108, -186}, extent = {{-30, 2}, {30, -2}}, textString = "Conditions"), Text(origin = {32, -125}, textColor = {0, 0, 127}, extent = {{-38, 5}, {38, -5}}, textString = "BUFFER TANK FOR HEATING", textStyle = {TextStyle.Bold}), Text(origin = {120, -124}, textColor = {0, 0, 127}, extent = {{-27, 3}, {27, -3}}, textString = "DHW TANK", textStyle = {TextStyle.Bold})}),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
  experiment(StartTime = 0, StopTime = 1e6, Tolerance = 1e-06, Interval = 2000),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=aliasConflicts ",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end ControlForHeatPump;
