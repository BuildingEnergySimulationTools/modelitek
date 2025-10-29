within Modelitek.Hvac.Tanks.BaseClasses;

block TankHeatLosses
  "Compute thermal losses of a cylindrical storage tank with insulation"

// ---- Parameters ----
  parameter Real Vtan = 5 "Tank volume [m3]";
  parameter Real H = 2 "Tank height [m]";
  parameter Real dIns = 0.1 "Insulation thickness [m]";
  parameter Real kIns = 0.04 "Insulation conductivity [W/m.K]";
  parameter Real hExt = 5 "External convection coeff [W/m2.K]";

// ---- Inputs ----
  Modelica.Blocks.Interfaces.RealInput T_tank(unit="K")
    "Average tank water temperature [K]"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_amb(unit="K")
    "Ambient temperature [K]"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

// ---- Output ----
  Modelica.Blocks.Interfaces.RealOutput Q_losses(unit="W")
    "Heat losses from tank [W]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected 
// Geometry
  Real ri = sqrt(Vtan/(Modelica.Constants.pi*H));
  Real ro = ri + dIns;
  Real Aside = 2*Modelica.Constants.pi*ro*H;
  Real Aend = Modelica.Constants.pi*ro^2;

// Resistances
  Real Rcond_side = log(ro/ri)/(2*Modelica.Constants.pi*H*kIns);
  Real Rconv_side = 1/(hExt*Aside);
  Real UA_side = 1/(Rcond_side + Rconv_side);

  Real Rcond_end = dIns/(kIns*Aend);
  Real Rconv_end = 1/(hExt*Aend);
  Real UA_end = 1/(Rcond_end + Rconv_end);

  Real UA_tot = UA_side + 2*UA_end;
public
equation 
  Q_losses = UA_tot*(T_tank - T_amb);

  annotation(
  Documentation(info = "<html><head></head>
<body>

<h3>Modèle <code>TankHeatLosses</code></h3>

<p>
Ce bloc calcule les <b>pertes thermiques d’un ballon de stockage cylindrique isolé</b> en fonction de sa géométrie, 
de ses propriétés d’isolation et de la température ambiante.  
Il estime les pertes de chaleur globales par conduction à travers l’isolation et convection externe, 
sur les parois latérales et les extrémités du cylindre.
</p>

<hr>

<h4>Principe de fonctionnement</h4>
<p>
Le modèle représente le ballon comme un <b>cylindre vertical isolé</b> de hauteur <code>H</code> et de volume <code>Vtan</code>.  
Les pertes thermiques totales <code>Q_losses</code> sont évaluées à partir d’un coefficient global d’échange <code>UA_tot</code> :
</p>

<p style=\"text-align:center; font-style:italic\">
Q_losses = UA_tot × (T_tank − T_amb)
</p>

<p>
où :
</p><ul>
<li><code>T_tank</code> est la température moyenne de l’eau dans le ballon,</li>
<li><code>T_amb</code> est la température ambiante,</li>
<li><code>UA_tot</code> est la somme des coefficients d’échange latéraux et aux extrémités.</li>
</ul>
<p></p>

<p>
Le modèle distingue deux contributions :
</p><ul>
<li><b>Latérale</b> : conduction à travers la paroi cylindrique et convection externe,</li>
<li><b>Extrémités</b> : conduction à travers les faces supérieure et inférieure et convection externe.</li>
</ul>
<p></p>

<hr>

<h4>Formulation</h4>

<p>Le modèle calcule successivement :</p>

<ul>
<li>le rayon interne <code>ri</code> à partir du volume et de la hauteur,</li>
<li>le rayon externe <code>ro = ri + dIns</code>,</li>
<li>les surfaces latérales et d’extrémités :
  <ul>
    <li><code>Aside = 2·π·ro·H</code></li>
    <li><code>Aend = π·ro²</code></li>
  </ul></li>
<li>les résistances thermiques :
  <ul>
    <li><b>Paroi latérale :</b> <code>Rcond_side = ln(ro/ri) / (2·π·H·kIns)</code></li>
    <li><b>Convection externe :</b> <code>Rconv_side = 1 / (hExt·Aside)</code></li>
  </ul></li>
<li>les résistances équivalentes aux extrémités (formulation plane) :</li>
  <ul>
    <li><code>Rcond_end = dIns / (kIns·Aend)</code></li>
    <li><code>Rconv_end = 1 / (hExt·Aend)</code></li>
  </ul>
<li>et enfin le coefficient global :</li>
<p style=\"text-align:center; font-style:italic\">
UA_tot = UA_side + 2·UA_end
</p>
</ul>

<hr>

<h4>&nbsp;Paramètres</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Unité</th><th>Description</th></tr>
<tr><td><code>Vtan</code></td><td>m³</td><td>Volume total du ballon</td></tr>
<tr><td><code>H</code></td><td>m</td><td>Hauteur du ballon</td></tr>
<tr><td><code>dIns</code></td><td>m</td><td>Épaisseur de l’isolation</td></tr>
<tr><td><code>kIns</code></td><td>W/m·K</td><td>Conductivité thermique de l’isolation</td></tr>
<tr><td><code>hExt</code></td><td>W/m²·K</td><td>Coefficient de convection externe</td></tr>
</tbody></table>

<hr>

<h4>Entrées</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Unité</th><th>Description</th></tr>
<tr><td><code>T_tank</code></td><td>K</td><td>Température moyenne de l’eau dans le ballon</td></tr>
<tr><td><code>T_amb</code></td><td>K</td><td>Température ambiante</td></tr>
</tbody></table>

<hr>

<h4>Sorties</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Unité</th><th>Description</th></tr>
<tr><td><code>Q_losses</code></td><td>W</td><td>Pertes thermiques totales du ballon</td></tr>
</tbody></table>

<hr>

<h4>Remarques</h4>
<ul>
<li>Le modèle suppose un champ de température homogène dans le ballon (<i>isotherme</i>).</li>
<li>Les pertes sont purement stationnaires (pas de dynamique thermique interne).</li>
<li>Les paramètres par défaut (kIns = 0.04 W/m·K, dIns = 0.1 m) représentent une isolation standard en mousse de polyuréthane.</li>
</ul>


</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), 
      graphics={
        Rectangle(extent={{-100,100},{100,-100}}, fillPattern=FillPattern.Solid, fillColor={230,230,255}),
        Text(extent={{-90,70},{90,40}}, textString="Tank losses"),
        Text(extent={{-90,-70},{90,-90}}, textString="Q = UA*(Ttank-Tamb)")
      , Text(origin = {2, 131}, textColor = {0, 0, 255}, extent = {{-132, 31}, {132, -31}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-140, 60}, {140, -60}})));

end TankHeatLosses;
