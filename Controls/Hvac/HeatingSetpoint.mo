within Modelitek.Controls.Hvac;

model HeatingSetpoint
  // --- Choix du mode ---
  parameter Boolean usePoints = true 
    "true = calculer a,b à partir de 2 points ; false = utiliser a,b donnés";

  // --- Mode 1 : 2 points ---
  parameter Real Text1 = -7 "Température ext. 1 (°C)";
  parameter Real Tset1 = 55 "Température départ 1 (°C)";
  parameter Real Text2 = 15 "Température ext. 2 (°C)";
  parameter Real Tset2 = 35 "Température départ 2 (°C)";

  // --- Mode 2 : a et b explicites ---
  parameter Real a = -1.0 "Pente loi d’eau";
  parameter Real b = 50.0 "Ordonnée à l’origine";

  // --- Entrée/Sortie ---
  Modelica.Blocks.Interfaces.RealInput Text(unit="degC") 
    "Température extérieure"
    annotation(Placement(transformation(origin = {0, 10}, extent = {{-120, -20}, {-100, 0}}), iconTransformation(extent = {{-120, -20}, {-100, 0}})));
  Modelica.Blocks.Interfaces.RealOutput Tsetpoint(unit="degC") 
    "Consigne de départ chauffage"
    annotation(Placement(transformation(extent={{100,-10},{120,10}})));

protected 
  Real aa, bb; // pente et ordonnée calculées

equation 
  // Si usePoints = true → calculer a et b à partir de 2 points
  aa = if usePoints then (Tset2 - Tset1) / (Text2 - Text1) else a;
  bb = if usePoints then Tset1 - aa*Text1 else b;

  // Loi d’eau
  Tsetpoint = aa*Text + bb;

  annotation(
    Icon(graphics={
      Rectangle(extent={{-100,100},{100,-100}}, fillColor={200,200,255}, 
                fillPattern=FillPattern.Solid, lineColor={0,0,255}),
      Text(extent={{-80,20},{80,-20}}, textString="Heating\nSetpoint")
    }),
    Documentation(info= "<html><head></head><body><h4>HeatingSetpoint</h4>
<p>Calcule la température de départ chauffage selon une loi d’eau :</p>
<ul>
<li><b>Mode 1</b> : spécifier 2 points (Text1,Tset1) et (Text2,Tset2).</li>
<li><b>Mode 2</b> : spécifier directement la pente <i>a</i> et l’ordonnée <i>b</i>.</li>
</ul>
<p>Équation : Tset = a*Text + b</p>
</body></html>"));
end HeatingSetpoint;
