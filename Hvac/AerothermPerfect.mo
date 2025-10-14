within Modelitek.Hvac;

model AerothermPerfect
  replaceable package Medium = Buildings.Media.Water
    "Working fluid medium";

  // Parameters
  parameter Real deltaT_winter = -3 "Temperature offset in winter [K]";
  parameter Real deltaT_summer = +3 "Temperature offset in summer [K]";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput T_ext "Outdoor air temperature [K]"
    annotation(Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput t_period
    "Season indicator: 1 = summer, 0 = winter, -0.5 = mid-season"
    annotation(Placement(transformation(extent={{-120,-20},{-80,20}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput T_diff
    "Difference between outdoor temperature and fluid inlet [K]"
    annotation(Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput P_elec
    "Instantaneous electrical power consumption [W]"
    annotation(Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_elec_cumul
    "Cumulative electrical energy consumption [kWh]"
    annotation(Placement(transformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput time_functioning
    "Total operating time [s]"
    annotation(Placement(transformation(extent={{100,-80},{120,-60}})));

  // Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a port_a_PAC(redeclare package Medium=Medium)
    "Fluid inlet port" annotation(Placement(transformation(origin = {1, -2}, extent = {{-9, -100}, {9, -80}}), iconTransformation(origin = {0, -18}, extent = {{-8, -80}, {8, -64}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_PAC(redeclare package Medium=Medium)
    "Fluid outlet port" annotation(Placement(transformation(origin = {3, 0}, extent = {{-11, 80}, {11, 100}}), iconTransformation(origin = {2, -4}, extent = {{-10, 80}, {10, 100}})));

  // Internal variables
  Real Power_aero "Aerothermal unit electrical power [W]";

equation
  // Example behavior: adjust outlet temperature relative to outdoor T_ext
  if t_period > 0.5 then
    port_b_PAC.h_outflow = Medium.specificEnthalpy_pT(port_a_PAC.p, T_ext + deltaT_summer);
  else
    port_b_PAC.h_outflow = Medium.specificEnthalpy_pT(port_a_PAC.p, T_ext + deltaT_winter);
  end if;

  // Example electrical consumption model
  P_elec = Power_aero;
  der(P_elec_cumul) = P_elec / 3600000; // kWh integration
  der(time_functioning) = if P_elec > 0 then 1 else 0;

  // Simple definition of T_diff
  T_diff = T_ext - Medium.temperature(port_a_PAC.h_outflow);

  annotation(
    Documentation(info="
<html>
<h2>AerothermPerfect</h2>

<p>This model represents an idealized aerothermal unit, assuming perfect 
heat exchange with simplified operating behavior.</p>

<h3>Operation principle</h3>
<ul>
  <li><b>Winter:</b> outlet fluid temperature = T<sub>ext</sub> − 3 K</li>
  <li><b>Summer:</b> outlet fluid temperature = T<sub>ext</sub> + 3 K</li>
</ul>

<p>The electrical power of the aerothermal unit is represented by 
<code>Power_aero</code> (in W).</p>

<h3>Inputs</h3>
<ul>
  <li><b>T_ext</b>: outdoor air temperature [K]</li>
  <li><b>t_period</b>: season indicator 
      (1 = summer, 0 = winter, −0.5 = mid-season)</li>
  <li><b>port_a_PAC</b>: fluid inlet port</li>
</ul>

<h3>Outputs</h3>
<ul>
  <li><b>T_diff</b>: temperature difference between outdoor air and inlet fluid</li>
  <li><b>port_b_PAC</b>: fluid outlet port</li>
  <li><b>P_elec</b>: instantaneous electrical power consumption [W]</li>
  <li><b>P_elec_cumul</b>: cumulative electrical energy consumption [kWh]</li>
  <li><b>time_functioning</b>: total operating time [s]</li>
</ul>
</html>
"));
end AerothermPerfect;
