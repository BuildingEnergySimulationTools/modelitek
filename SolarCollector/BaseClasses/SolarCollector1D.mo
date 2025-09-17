within Modelitek.SolarCollector.BaseClasses;

model SolarCollector1D
  "1D discretized solar thermal collector with absorber plate, interface layer, and heat transfer fluid"

  // --- Inputs
  Modelica.Blocks.Interfaces.RealInput SolarIrradiance(unit="W/m2") 
    "Incident solar irradiance [W/m²]" 
    annotation (Placement(transformation(extent = {{-120, 72}, {-100, 92}}), iconTransformation(origin = {20, -2}, extent = {{-120, 72}, {-100, 92}})));
  Modelica.Blocks.Interfaces.RealInput AmbientTemperature(unit="K") 
    "Ambient air temperature [K]" 
    annotation (Placement(transformation(extent = {{-120, 42}, {-100, 62}}), iconTransformation(origin = {20, -2}, extent = {{-120, 42}, {-100, 62}})));
  Modelica.Blocks.Interfaces.RealInput WindSpeed(unit="m/s") 
    "Wind speed [m/s]" 
    annotation (Placement(transformation(extent = {{-120, 12}, {-100, 32}}), iconTransformation(origin = {20, 0}, extent = {{-120, 12}, {-100, 32}})));
  Modelica.Blocks.Interfaces.RealInput MassFlow(unit="kg/s") 
    "Mass flow rate of heat transfer fluid [kg/s]" 
    annotation (Placement(transformation(extent = {{-120, -78}, {-100, -58}}), iconTransformation(origin = {20, 26}, extent = {{-120, -78}, {-100, -58}})));
  Modelica.Blocks.Interfaces.RealInput Tin(unit="K") 
    "Inlet fluid temperature [K]" 
    annotation (Placement(transformation(extent = {{-120, -42}, {-100, -22}}), iconTransformation(origin = {20, 16}, extent = {{-120, -42}, {-100, -22}})));

  // --- Outputs
  Modelica.Blocks.Interfaces.RealOutput Tout(unit="K") 
    "Outlet fluid temperature [K]" 
    annotation (Placement(transformation(extent = {{100, -40}, {140, 0}}), iconTransformation(origin = {-28, 38}, extent = {{80, -32}, {112, 0}})));
  Modelica.Blocks.Interfaces.RealOutput Tin_measured(unit="K") 
    "Measured inlet fluid temperature [K]" 
    annotation (Placement(transformation(extent = {{100, -80}, {140, -40}}), iconTransformation(origin = {-28, 20}, extent = {{80, -64}, {112, -32}})));
  Modelica.Blocks.Interfaces.RealOutput T_module(unit="K") 
    "Fluid temperature at cassette (mid-channel)" 
    annotation (Placement(transformation(extent = {{100, 20}, {140, 60}}), iconTransformation(origin = {-38, 38}, extent = {{90, 18}, {126, 54}})));

  // --- Geometry and discretization
  parameter Integer nb_cells = 20 
    "Number of discretization cells along the collector" 
    annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length L = 5.1 
    "Collector length [m]" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length W = 0.04 
    "Collector width [m]" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length channelWidth = 0.02 
    "Channel width [m]" annotation(Dialog(group="Geometry"));
  parameter Integer nChannels = 120 
    "Number of parallel channels" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length thickness_fluid = 0.002 
    "Channel depth [m]" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length thickness_abs = 0.002 
    "Absorber plate thickness [m]" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length thickness_ins = 0.035 
    "Insulation thickness [m]" annotation(Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length thickness_int = 0.002 
    "Interface layer thickness [m]" annotation(Dialog(group="Geometry"));

  // --- Material properties: absorber
  parameter Modelica.Units.SI.ThermalConductivity k_abs = 200 
    "Absorber conductivity [W/mK]" annotation(Dialog(group="Materials - Absorber"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_abs = 900 
    "Absorber heat capacity [J/kgK]" annotation(Dialog(group="Materials - Absorber"));
  parameter Modelica.Units.SI.Density rho_abs = 2700 
    "Absorber density [kg/m³]" annotation(Dialog(group="Materials - Absorber"));

  // --- Material properties: interface
  parameter Modelica.Units.SI.ThermalConductivity k_int = 0.1 
    "Interface conductivity [W/mK]" annotation(Dialog(group="Materials - Interface"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_int = 1000 
    "Interface heat capacity [J/kgK]" annotation(Dialog(group="Materials - Interface"));
  parameter Modelica.Units.SI.Density rho_int = 1000 
    "Interface density [kg/m³]" annotation(Dialog(group="Materials - Interface"));

  // --- Material properties: fluid
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_fluid = 3800 
    "Heat transfer fluid heat capacity [J/kgK]" annotation(Dialog(group="Materials - Fluid"));
  parameter Modelica.Units.SI.Density rho_fluid = 1000 
    "Heat transfer fluid density [kg/m³]" annotation(Dialog(group="Materials - Fluid"));

  // --- Optical properties
  parameter Real epsilon = 0.9 
    "Emissivity [-]" annotation(Dialog(group="Optics"));
  parameter Real alpha = 0.85 
    "Absorptance [-]" annotation(Dialog(group="Optics"));

  // --- Initial conditions
  parameter Modelica.Units.SI.Temperature T_start = 293.15 
    "Initial temperature in collector [K]" annotation(Dialog(group="Initialization"));

  // --- States (per cell)
  Real T_abs[nb_cells](start=T_start*ones(nb_cells)) "Absorber temperature [K]";
  Real T_intLayer[nb_cells](start=T_start*ones(nb_cells)) "Interface layer temperature [K]";
  Real T_fluid[nb_cells](start=T_start*ones(nb_cells)) "Fluid temperature [K]";

equation 
  // Inlet boundary condition
  T_fluid[1] = Tin;

  for i in 1:nb_cells loop
    // Energy balance on absorber
    der(T_abs[i]) = (
      alpha*L*W/nb_cells*SolarIrradiance
      - epsilon*L*W/nb_cells*5.67e-8*((T_abs[i])^4 - AmbientTemperature^4)
      - (T_abs[i] - AmbientTemperature)*(5.678*L*W/nb_cells)
      - (k_abs/thickness_abs)*(T_abs[i] - T_fluid[i])
      - (k_int/thickness_int)*(T_abs[i] - T_intLayer[i])
    ) / (rho_abs*cp_abs*thickness_abs*W*L/nb_cells);

    // Energy balance on interface layer
    der(T_intLayer[i]) = (
      (k_int/thickness_int)*(T_abs[i] - T_intLayer[i])
      - (k_int/thickness_int)*(T_intLayer[i] - T_fluid[i])
    ) / (rho_int*cp_int*thickness_int*W*L/nb_cells);
  end for;

  for i in 2:nb_cells loop
    // Energy balance on fluid
    der(T_fluid[i]) = (
      (k_abs/thickness_abs)*(T_abs[i] - T_fluid[i])
      + (k_int/thickness_int)*(T_intLayer[i] - T_fluid[i])
      + MassFlow/nChannels*cp_fluid*(T_fluid[i-1] - T_fluid[i])
    ) / (rho_fluid*cp_fluid*thickness_fluid*channelWidth*L/nb_cells);
  end for;

  // Outputs
  Tin_measured = T_fluid[1];
  Tout = T_fluid[nb_cells];
  T_module = T_fluid[integer(nb_cells/2)];

  annotation(Documentation(info = "<html>
  <h4>SolarCollector1D</h4>
  <p>
  Simplified 1D finite-volume model of a solar thermal collector. 
  The absorber plate exchanges heat with a heat transfer fluid through a generic interface layer, 
  while also exchanging with the ambient environment.
  </p>
  <ul>
    <li>Inputs: solar irradiance [W/m²], ambient temperature [K], wind speed [m/s], fluid inlet temperature [K], and mass flow rate [kg/s].</li>
    <li>Outputs: outlet temperature [K], inlet temperature [K], and mid-channel temperature (cassette) [K].</li>
    <li>Parameters are grouped by <i>Geometry</i>, <i>Materials</i> (absorber, interface, fluid), <i>Optics</i>, and <i>Initialization</i>.</li>
  </ul>
  </html>"),
  Icon(graphics = {Ellipse(origin = {-48, 78}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Polygon(origin = {-11, 3}, fillColor = {85, 85, 127}, fillPattern = FillPattern.Horizontal, points = {{-39, -17}, {-9, 17}, {39, 17}, {33, -17}, {-39, -17}, {-39, -17}}), Polygon(origin = {-49, 44}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-1, 8}, {-1, -8}, {1, -8}, {1, 8}, {-1, 8}, {-1, 8}}), Polygon(origin = {-28, 49}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-6, 7}, {4, -9}, {6, -7}, {-4, 9}, {-6, 7}, {-6, 7}}), Polygon(origin = {-10, 64}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-12, 4}, {12, -6}, {12, -4}, {-12, 6}, {-12, 4}, {-12, 4}}), Text(origin = {-16, 153}, textColor = {0, 0, 255}, extent = {{-36, -204}, {38, -179}}, textString = "%name")}, coordinateSystem(extent = {{-100, 100}, {100, -60}})),
  Diagram);
end SolarCollector1D;
