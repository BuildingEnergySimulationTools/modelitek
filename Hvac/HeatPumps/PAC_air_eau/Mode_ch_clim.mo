within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model Mode_ch_clim
  Modelica.Blocks.Interfaces.RealInput Pch annotation(
    Placement(visible = true, transformation(origin = {-118, 46}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {-115, 53}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pclim annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-115, -31}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput Mode(start=1) "1 si chauffage , 2 si clim " annotation(
    Placement(visible = true, transformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

if Pclim < 0 and Pch ==0 then 
 Mode = 2 ;
else  
 Mode = 1;
end if ;

 


annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {-45, -37}, extent = {{-29, 31}, {29, -31}}), Rectangle(extent = {{-100, 100}, {100, -100}}), Polygon(origin = {-45, -40}, fillColor = {12, 47, 248}, fillPattern = FillPattern.VerticalCylinder, points = {{-55, 140}, {-55, -60}, {145, -60}, {145, -60}, {-55, 140}}), Polygon(origin = {45, 40}, rotation = 180, fillColor = {248, 8, 24}, fillPattern = FillPattern.VerticalCylinder, points = {{-55, 140}, {-55, -60}, {145, -60}, {145, -60}, {-55, 140}}), Ellipse(origin = {28, 42}, lineColor = {253, 253, 253}, fillColor = {254, 254, 254}, fillPattern = FillPattern.Solid, extent = {{-22, 22}, {22, -22}}), Line(origin = {1.64829, 59.611}, points = {{-6, 5}, {6, -5}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {51.7228, 20.1773}, points = {{-6, 5}, {4, -5}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {9.47247, 10.4753}, points = {{-6, 3}, {2, 13}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {55.1654, 53.6646}, points = {{-6, 3}, {6, 13}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {31.6929, 63.3665}, points = {{-4, 3}, {-4, 25}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {33.8836, -8.30265}, points = {{-4, 3}, {-4, 25}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {72.0655, 22.9939}, points = {{6, 17}, {-18, 17}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-3.98517, 24.8717}, points = {{6, 17}, {-18, 17}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-15.252, -47.4234}, points = {{-6, -11}, {-6, 37}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-14, -53.0567}, points = {{18, 19}, {-32, 19}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-34.6558, -53.0568}, points = {{-4, 3}, {32, 33}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-0.542567, -52.4309}, points = {{-2, 1}, {-38, 33}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-14.6259, -24.5769}, points = {{-6, 3}, {2, 13}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-26.2057, -16.1267}, points = {{-4, 5}, {4, -5}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-23.3889, -60.2549}, points = {{-6, 3}, {2, 13}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-14.9389, -52.7437}, points = {{-6, 5}, {2, -5}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-1.79427, -36.7825}, points = {{-6, 3}, {4, 11}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-1.16841, -38.9732}, points = {{-6, 5}, {2, -5}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-35.2822, -47.11}, points = {{-8, 5}, {2, 13}}, color = {255, 255, 255}, thickness = 1.5), Line(origin = {-35.5947, -28.9583}, points = {{-8, 3}, {2, -5}}, color = {255, 255, 255}, thickness = 1.5)}),
    Documentation(info = "<html><head></head><body>Ce modèle permet de choisir le mode de fonctionnement de la pompe à chaleur ON/OFF à partir despuissances de besoin chauffage et climatisation.</body></html>"));
end Mode_ch_clim;
