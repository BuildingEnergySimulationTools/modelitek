within Modelitek.Hvac.HeatPumps;

model HeatPump_temp

  parameter Real COP_nominal=3.0 "Nominal COP";
  parameter Integer Np_doc=8;
  parameter Real table[Np_doc,2] = 
     [-5, 0.64;
       0, 0.75;
       5, 0.83;
      10, 0.92;
      15, 0.96;
      20, 0.99;
      25, 1;
      50, 1];

  Modelica.Blocks.Interfaces.RealInput T_ext(unit="C")
    annotation(Placement(transformation(extent={{-120,20},{-80,60}})));

  Modelica.Blocks.Interfaces.RealInput P_th(unit="W") 
    "Thermal power demand"
    annotation(Placement(transformation(origin = {0, 22}, extent = {{-20, -120}, {20, -80}}), iconTransformation(extent = {{-20, -120}, {20, -80}})));

  Modelica.Blocks.Tables.CombiTable1Ds Cop_vs_Text(
    extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=table)
    annotation(Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.Blocks.Interfaces.RealOutput P_elec(unit="W") 
    "Electrical power consumption"
    annotation(Placement(transformation(extent={{80,-20},{120,20}})));

  Modelica.Blocks.Interfaces.RealOutput COP "Effective COP"
    annotation(Placement(transformation(extent={{80,40},{120,80}})));

equation 
  COP = COP_nominal * Cop_vs_Text.y[1];
  P_elec = if COP > 0 then P_th / COP else 0;

  connect(T_ext, Cop_vs_Text.u);

annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-60, -20}, {60, 20}}, textString = "HP")}));
end HeatPump_temp;
