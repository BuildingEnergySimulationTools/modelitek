within Modelitek.Utilities;

model ROI_Calculator
  "Generic model to estimate simple payback time (ROI) of an energy installation"

  // --- Parameters (costs)
  parameter Real baseCost = 20000 "Fixed installation cost [EUR]";
  parameter Real costPerArea = 100.0 "Cost per square meter of collector [EUR/m²]";
  parameter Real costPerVolume = 1.0 "Cost per storage volume unit [EUR/litre]";
  parameter Real safetyFactor = 0.9 "Cost safety margin [-]";

  // --- Parameters (reference)
  parameter Real referenceAnnualCost = 5000 "Annual reference energy cost [EUR/year]";
  parameter Real energyPrice = 0.20 "Unit energy price [EUR/kWh]";

  // --- Calculated values
  Real totalCost;
  Real cost_area;
  Real cost_volume;
  Real deltaCost;

  // --- Inputs
  Modelica.Blocks.Interfaces.RealInput Area "Collector surface area [m²]" annotation(
    Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput Volume "Storage volume [m³]" annotation(
    Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealInput EnergySaved "Annual energy savings [kWh]" annotation(
    Placement(transformation(extent={{-120,-40},{-80,0}})));

  // --- Outputs
  Modelica.Blocks.Interfaces.RealOutput TotalInvestment "Total investment cost [EUR]" annotation(
    Placement(transformation(extent={{80,20},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PaybackTime "Simple payback period [years]" annotation(
    Placement(transformation(extent={{80,-40},{120,0}})));

equation
  cost_area   = costPerArea * Area;
  cost_volume = costPerVolume * Volume * 1000 * safetyFactor;
  totalCost   = baseCost + cost_area + cost_volume;
  deltaCost   = referenceAnnualCost - (EnergySaved * energyPrice);

  TotalInvestment = totalCost;
  PaybackTime     = if deltaCost > 0 then totalCost / deltaCost else 1e9;

  annotation (
    Documentation(info= "<html><head></head>
<body>
<h4>ROI_Calculator</h4>
<p>
Generic model to estimate the simple payback period of an energy system installation.
It combines fixed and variable investment costs with annual energy savings to compute
the return-on-investment (ROI).</p>

<h5>Inputs</h5>
<ul>
<li><b>Area</b> [m²]: collector or installation surface</li>
<li><b>Volume</b> [m³]: storage or fluid volume</li>
<li><b>EnergySaved</b> [kWh]: annual energy savings compared to reference</li>
</ul>

<h5>Outputs</h5>
<ul>
<li><b>TotalInvestment</b> [EUR]: estimated installation cost</li>
<li><b>PaybackTime</b> [years]: simple payback period (ROI)</li>
</ul><div><br></div><div><b>Important note: This model serves as a base for more complex calculations.</b></div>

</body></html>"));
end ROI_Calculator;
