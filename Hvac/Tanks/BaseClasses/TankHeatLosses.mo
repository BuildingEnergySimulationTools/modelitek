within Modelitek.Hvac.Tanks.BaseClasses;

block TankHeatLosses
  "Compute thermal losses of a cylindrical storage tank with insulation"

  // ---- Parameters ----
  parameter Real Vtan = 5 "Tank volume [m3]";
  parameter Real H = 2 "Tank height [m]";
  parameter Real dIns = 0.1 "Insulation thickness [m]";
  parameter Real kIns = 0.04 "Insulation conductivity [W/m.K]";
  parameter Real hExt = 5 "External convection coeff [W/m2.K]";

  // ---- Inputs ----
  Modelica.Blocks.Interfaces.RealInput T_tank(unit="K")
    "Average tank water temperature [K]"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_amb(unit="K")
    "Ambient temperature [K]"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  // ---- Output ----
  Modelica.Blocks.Interfaces.RealOutput Q_losses(unit="W")
    "Heat losses from tank [W]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected 
  // Geometry
  Real ri = sqrt(Vtan/(Modelica.Constants.pi*H));
  Real ro = ri + dIns;
  Real Aside = 2*Modelica.Constants.pi*ro*H;
  Real Aend = Modelica.Constants.pi*ro^2;

  // Resistances
  Real Rcond_side = log(ro/ri)/(2*Modelica.Constants.pi*H*kIns);
  Real Rconv_side = 1/(hExt*Aside);
  Real UA_side = 1/(Rcond_side + Rconv_side);

  Real Rcond_end = dIns/(kIns*Aend);
  Real Rconv_end = 1/(hExt*Aend);
  Real UA_end = 1/(Rcond_end + Rconv_end);

  Real UA_tot = UA_side + 2*UA_end;

equation 
  Q_losses = UA_tot*(T_tank - T_amb);

  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), 
      graphics={
        Rectangle(extent={{-100,100},{100,-100}}, fillPattern=FillPattern.Solid, fillColor={230,230,255}),
        Text(extent={{-90,70},{90,40}}, textString="Tank losses"),
        Text(extent={{-90,-70},{90,-90}}, textString="Q = UA*(Ttank-Tamb)")
      }),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,100},{140,-100}}))
  );

end TankHeatLosses;
