within Modelitek.Hvac.HeatPumps;

model HeatPump_COPs_temporary
  // Parameters
  parameter Real COP_nominal = 3.0 "Nominal COP at reference conditions";
  parameter Integer Np_doc = 8 "Number of datasheet performance points in table"; 
  parameter Real table[Np_doc, 2] = 
    [-5, 0.64;
      0, 0.75;
      5, 0.83;
     10, 0.92;
     15, 0.96;
     20, 0.99;
     25, 1.00;
     35, 0.95] 
     "Correction factors vs outdoor temperature (relative to nominal)";
  
  // Inputs
  Modelica.Blocks.Interfaces.RealInput T_ext(unit="degC") 
    "Outdoor air temperature [°C]"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  
  Modelica.Blocks.Interfaces.RealInput T_depart(unit="degC") 
    "Supply temperature [°C]"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));

  Modelica.Blocks.Interfaces.RealInput P_th_demand(unit="W") 
    "Thermal power demand [W]"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput P_th(unit="W") 
    "Delivered thermal power [W]"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

  Modelica.Blocks.Interfaces.RealOutput P_elec(unit="W") 
    "Electrical power consumed [W]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Modelica.Blocks.Interfaces.RealOutput COP_eff(unit="-") 
    "Effective COP"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

  // Internal blocks
  Modelica.Blocks.Tables.CombiTable1Ds Cop_vs_Text(
    extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table = table) 
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  // connect inputs
  connect(T_ext, Cop_vs_Text.u);

  // effective COP = nominal COP × correction(T_ext) × correction(T_depart)
  COP_eff = COP_nominal * Cop_vs_Text.y[1] * max(0.2, 1 - (T_depart - 35)/40);

  // delivered thermal power (limited here to the demand)
  P_th = P_th_demand;

  // electrical consumption
  P_elec = if COP_eff > 0 then P_th / COP_eff else 0;

  annotation(
    Icon(graphics = {Rectangle(extent={{-100,100},{100,-100}}, 
                               fillColor={200,200,200}, 
                               fillPattern=FillPattern.Solid),
                      Text(extent={{-60,-20},{60,20}}, textString="HP")}),
    Documentation(info="<html>
    <p>Simple heat pump model:</p>
    <ul>
      <li>Inputs: thermal demand P_th_demand [W], outdoor temperature T_ext [°C], supply temperature T_depart [°C].</li>
      <li>Outputs: delivered power P_th [W], electric consumption P_elec [W], effective COP [-].</li>
      <li>The COP is calculated from a nominal COP corrected by T_ext (datasheet table) and penalized with T_depart.</li>
    </ul>
    </html>"));
end HeatPump_COPs_temporary;
