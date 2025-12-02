within Modelitek.Hvac.Boilers.BoilerData;

record GasBoilerClassic
  extends BoilerThermalParams(
    alpha_nom = 0.04,
    T_ref_nom = 70,
    alpha_int = 0.05,
    T_ref_int = 40
  );
end GasBoilerClassic;
