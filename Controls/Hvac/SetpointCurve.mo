within Modelitek.Controls.Hvac;

model SetpointCurve
  replaceable parameter Modelitek.Controls.Data.SetpointParams params 
    constrainedby SetpointParams
    "= Profil utilisé (chauffage, refroidissement, etc.)"
    annotation(choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput Text(unit="degC") 
  "Température extérieure"
  annotation(Placement(transformation(origin = {0, 10}, extent = {{-120, -20}, {-100, 0}}), iconTransformation(extent = {{-120, -20}, {-100, 0}})));
  Modelica.Blocks.Interfaces.RealOutput Tsetpoint(unit="degC") 
  "Consigne de départ chauffage"
  annotation(Placement(transformation(extent={{100,-10},{120,10}})));

protected 
  Real aa, bb;
public
equation 
  aa = if params.usePoints 
       then (params.Tset2 - params.Tset1) / (params.Text2 - params.Text1)
       else params.a;

  bb = if params.usePoints 
       then params.Tset1 - aa * params.Text1
       else params.b;

  Tsetpoint = aa*Text + bb;
annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {155, 245, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-6, 4}, textColor = {0, 0, 255}, extent = {{-88, 38}, {88, -38}}, textString = "%name")}));
end SetpointCurve;
