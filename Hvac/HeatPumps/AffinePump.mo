within Modelitek.Hvac.HeatPumps;

model AffinePump
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
      redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
        final prescribedHeatFlowRate=true));
        
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Heat_flow annotation(
    Placement(visible = true, transformation(origin = {-52, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow annotation(
    Placement(visible = true, transformation(origin = {-106, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-107, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(Heat_flow.port, vol.heatPort) annotation(
    Line(points = {{-42, -60}, {-26, -60}, {-26, -10}, {-8, -10}}, color = {191, 0, 0}));
  connect(Q_flow, Heat_flow.Q_flow) annotation(
    Line(points = {{-106, -60}, {-62, -60}}, color = {0, 0, 127}));
end AffinePump;
