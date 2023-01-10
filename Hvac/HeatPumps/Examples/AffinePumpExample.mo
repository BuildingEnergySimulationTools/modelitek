within Modelitek.Hvac.HeatPumps.Examples;
model AffinePumpExample
  extends Modelica.Icons.Example;
  Modelitek.Hvac.HeatPumps.AffinePump affinePump annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.Boundary_pT Source(T = 273.15 + 15, nPorts = 1, p = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.Boundary_pT boundary_pT(T = 273.15 + 30, nPorts = 1, p = 1200) annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(Source.ports[1], affinePump.port_a) annotation(
    Line(points = {{-62, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(affinePump.port_b, boundary_pT.ports[1]) annotation(
    Line(points = {{10, 0}, {68, 0}}, color = {0, 127, 255}));
end AffinePumpExample;
