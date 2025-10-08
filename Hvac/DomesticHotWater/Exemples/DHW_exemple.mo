within Modelitek.Hvac.DomesticHotWater.Exemples;
    model DHW_exemple
    extends Modelica.Icons.Example;
      Modelitek.Hvac.DomesticHotWater.DHW_generator dHW_generator annotation(
        Placement(visible = true, transformation(origin = {17, 5}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
      Modelica.Blocks.Sources.Sine sine(amplitude = 10, freqHz = 1 / 63064800, offset = 11)  annotation(
        Placement(visible = true, transformation(origin = {-78, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(sine.y, dHW_generator.T_eau_froide) annotation(
        Line(points = {{-67, 6}, {-8, 6}}, color = {0, 0, 127}));
    
    annotation(
        uses(Modelica(version = "3.2.3")));
    end DHW_exemple;
