within Modelitek.Hvac.Boilers.BoilerData;

record BoilerData
  parameter Real P_nom = 100 "Nominal power (kW)";
  parameter Real P_int = 0.3 * P_nom "Intermediate-load heating capacity (kW, typically 30% of P_nom)";


  replaceable parameter BoilerCoeffs coeffs
    constrainedby BoilerCoeffs
    annotation(choicesAllMatching=true);

  replaceable parameter BoilerThermalParams therm
    constrainedby BoilerThermalParams
    annotation(choicesAllMatching=true);

  // === Récupération sur pertes (1051)
  parameter Real p_rec = 0 
    "Fraction of recoverable losses (0 = none, RE2020 default)";

  // === Veille (1018, valeur par défaut si non spécifiée)
  parameter Real W_veille_default = 20 
    "Standby electrical power (W), default value when no data available";

end BoilerData;
