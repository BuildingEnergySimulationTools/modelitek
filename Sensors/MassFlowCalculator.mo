within Modelitek.Sensors;

model MassFlowCalculator "Calcule le débit massique théorique en fonction de la puissance demandée et du ΔT"
  import Modelica.Units.SI;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    "Milieu utilisé (eau par défaut)" 
    annotation(choicesAllMatching = true);

  // Entrées
  Modelica.Blocks.Interfaces.RealInput Q_demand(unit="W") 
    "Puissance thermique demandée (W)" 
    annotation(Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput DeltaT(unit="K") 
    "DeltaT visé (K)" 
    annotation(Placement(transformation(extent={{-140,-80},{-100,-40}})));

  // Sortie
  Modelica.Blocks.Interfaces.RealOutput m_flow_calc(unit="kg/s") 
    "Débit massique théorique (kg/s)" 
    annotation(Placement(transformation(extent={{100,-20},{140,20}})));

protected 
  parameter Medium.ThermodynamicState state = 
    Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default);

  parameter SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(state);

equation
  m_flow_calc = Q_demand / (cp * DeltaT);

  annotation(
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Rectangle(extent={{-100,100},{100,-100}}, fillColor={200,200,255}, fillPattern=FillPattern.Solid),
      Text(extent={{-80,20},{80,-20}}, textString="m_flow = Q/(cp*ΔT)")
    }),
    Documentation(info="<html>
    <p>
    Ce bloc calcule le débit massique théorique requis pour fournir une puissance <b>Q_demand</b> 
    avec une différence de température <b>DeltaT</b>, selon le fluide défini (par défaut eau).
    </p>
    <p>
    Formule : m_flow = Q / (cp * DeltaT)
    </p>
    </html>")
  );
end MassFlowCalculator;
