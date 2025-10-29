within Modelitek.Hvac.Tanks.BaseClasses;

block TankPowerRequest

  replaceable package Medium = Buildings.Media.Water
    "Medium model"
    annotation (choicesAllMatching=true);

  // --- Paramètres
  parameter Real T_set = 333.15 "60°C, température cible [K]";
  parameter Real dT_hys = 5 "Bande hystérésis [K]";
  parameter Real VTan = 5 "Volume du ballon [m3]";
  parameter Real f_top = 0.30 "Fraction de volume haut utile";
  parameter Real tau_charge = 1800 "Temps de remontée visé [s]";
  parameter Real p_nom = 3e5 "Pression nominale pour calcul cp [Pa]";

  // --- Entrées
  Modelica.Blocks.Interfaces.RealInput T_top "Température haut ballon [K]"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput T_bot "Température bas ballon [K]"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput m_flow "Débit PAC [kg/s]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput T_HP_out_max "Température max sortie PAC [K]"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Q_losses "Pertes thermiques [W]"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  // --- Sorties
  Modelica.Blocks.Interfaces.BooleanOutput besoinON
    "True when tank requests heating (hysteresis)"
    annotation(Placement(transformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q_req_th
    "Besoin thermique brut du ballon [W]"
    annotation(Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q_req
    "Puissance demandée à la PAC, limitée hydrauliquement [W]"
    annotation(Placement(transformation(extent={{100,-20},{140,20}})));

protected 
  Medium.ThermodynamicState sta = Medium.setState_pTX(p_nom, T_top, Medium.X_default);
  Real rho = Medium.density(sta);
  Real cp_top = Medium.specificHeatCapacityCp(sta);

  Medium.ThermodynamicState staBot = Medium.setState_pTX(p_nom, T_bot, Medium.X_default);
  Real cp_bot = Medium.specificHeatCapacityCp(staBot);

  Real C_eff = rho*cp_top*(VTan*f_top);
  Boolean on(start=false, fixed=true);
  Real Q_ch;
  Real Q_max;

equation
  besoinON = on;

  // Hystérésis
  on = if T_top < (T_set - dT_hys) then true
       else if T_top > (T_set + dT_hys) then false
       else pre(on);

  // Puissance de recharge visée (indépendante du débit)
  Q_ch = C_eff/tau_charge * max(0, T_set - T_top);

  // Besoin thermique brut
  Q_req_th = if on then (Q_losses + Q_ch) else 0;

  // Limite hydraulique (fonction du débit réel dispo)
  Q_max = m_flow * cp_bot * max(0, T_HP_out_max - T_bot);

  // Demande finale = limité par l’hydraulique
  Q_req = if on then Q_req_th else 0;

annotation(
Documentation(info = "<html><head></head>
<body>

<h3>Modèle <code>TankPowerRequest</code></h3>

<p>
Ce bloc calcule le <b>besoin de puissance thermique</b> d’un ballon de stockage (tank) en fonction de sa température actuelle, 
de ses pertes thermiques et de ses conditions hydrauliques.  
Il émet une demande de charge (<code>besoinON</code>) lorsque la température en haut du ballon descend en dessous de la bande d’hystérésis, 
et s’arrête lorsque la température dépasse la consigne.
</p>

<hr>

<h4>Principe de fonctionnement</h4>
<p>
Le modèle évalue :
</p><ul>
<li>le <b>besoin de recharge</b> du ballon pour atteindre la consigne <code>T_set</code>,</li>
<li>les <b>pertes thermiques</b> à compenser,</li>
<li>et la <b>limitation hydraulique</b> imposée par le débit de la PAC et sa température maximale de sortie.</li>
</ul>
<p></p>

<p>Le signal logique <code>besoinON</code> est activé selon une <b>hystérésis</b> autour de la consigne :</p>

<p style=\"text-align:center; font-style:italic\">
on = true si T_top &lt; (T_set - dT_hys)<br>
on = false si T_top &gt; (T_set + dT_hys)
</p>

<p>
Le besoin thermique brut <code>Q_req_th</code> est la somme :
</p>

<p style=\"text-align:center; font-style:italic\">
Q_req_th = Q_losses + C_eff/τ_charge × (T_set - T_top)
</p>

<p>
où <code>C_eff</code> représente la capacité thermique effective du volume haut utile du ballon.
</p>

<p>
La puissance réellement demandée à la PAC (<code>Q_req</code>) est ensuite bornée hydrauliquement par :
</p>

<p style=\"text-align:center; font-style:italic\">
Q_max = m_flow × cp_bot × (T_HP_out_max - T_bot)
</p>

<p>
et limitée à zéro lorsque le ballon est en température ou si le besoin est inactif.
</p>

<hr>

<h4>Paramètres</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Unité</th><th>Description</th></tr>
<tr><td><code>T_set</code></td><td>K</td><td>Température cible du ballon (par défaut 333.15 K ≈ 60°C)</td></tr>
<tr><td><code>dT_hys</code></td><td>K</td><td>Bande d’hystérésis sur la température haute</td></tr>
<tr><td><code>VTan</code></td><td>m³</td><td>Volume total du ballon</td></tr>
<tr><td><code>f_top</code></td><td>-</td><td>Fraction du volume haut utilisée pour le contrôle (par défaut 0.30)</td></tr>
<tr><td><code>tau_charge</code></td><td>s</td><td>Temps de remontée thermique visé pour la recharge</td></tr>
<tr><td><code>p_nom</code></td><td>Pa</td><td>Pression nominale utilisée pour calculer les propriétés du fluide</td></tr>
</tbody></table>

<hr>

<h4>Entrées</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Type</th><th>Description</th></tr>
<tr><td><code>T_top</code></td><td>Real [K]</td><td>Température en haut du ballon</td></tr>
<tr><td><code>T_bot</code></td><td>Real [K]</td><td>Température en bas du ballon</td></tr>
<tr><td><code>m_flow</code></td><td>Real [kg/s]</td><td>Débit massique traversant la PAC</td></tr>
<tr><td><code>T_HP_out_max</code></td><td>Real [K]</td><td>Température maximale de sortie de la PAC</td></tr>
<tr><td><code>Q_losses</code></td><td>Real [W]</td><td>Pertes thermiques du ballon</td></tr>
</tbody></table>

<hr>

<h4>Sorties</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">
<tbody><tr><th>Nom</th><th>Type</th><th>Description</th></tr>
<tr><td><code>besoinON</code></td><td>Boolean</td><td>Vrai si le ballon demande une recharge (hystérésis active)</td></tr>
<tr><td><code>Q_req_th</code></td><td>Real [W]</td><td>Besoin thermique brut (recharge + pertes)</td></tr>
<tr><td><code>Q_req</code></td><td>Real [W]</td><td>Puissance réellement demandée à la PAC (limitée hydrauliquement)</td></tr>
</tbody></table>

<hr>

<h4>Calculs internes</h4>
<ul>
<li>Le modèle utilise le modèle de fluide <code>Medium</code> (par défaut : <code>Buildings.Media.Water</code>).</li>
<li>La densité et la capacité thermique massique sont évaluées à la pression <code>p_nom</code> et aux températures locales (haut et bas).</li>
<li>La capacité thermique effective du volume haut utile est calculée comme :
<code>C_eff = ρ × cp_top × (Vtan × f_top)</code>.</li>
<li>Le besoin <code>Q_ch</code> dépend de la différence à la consigne et du temps de charge visé.</li>
</ul>

<hr>

<h4>Remarques</h4>
<ul>
<li>Le modèle ne contient pas de dynamique propre (statique à chaque pas de calcul).</li>
<li>La variable <code>besoinON</code> peut être utilisée pour piloter la PAC ou une vanne de charge.</li>
<li>Les pertes thermiques <code>Q_losses</code> peuvent provenir du bloc <code>TankHeatLosses</code>.</li>
<li>Convient pour les schémas ECS ou stockage tampon avec gestion par bande de température haute.</li>
</ul>


</body></html>"),
    Icon(graphics = {Rectangle(origin = {-2, 0}, fillColor = {85, 255, 255}, 
                               fillPattern = FillPattern.Cross, 
                               extent = {{-104, 100}, {104, -100}}), 
                      Text(origin = {-24, 127}, textColor = {0, 0, 255}, 
                           extent = {{-132, 31}, {132, -31}}, 
                           textString = "%name")}),
    Diagram(graphics),
    Documentation(info = "<html><head></head><body>
<p><br></p><ul>
</ul>
</body></html>"));
end TankPowerRequest;
