within Modelitek.Hvac.Boilers.BoilerData;

record GasBoilerCondensation
  extends BoilerThermalParams(
    alpha_nom = 0.20,
    T_ref_nom = 70,
    alpha_int = 0.20,
    T_ref_int = 33
  );
end GasBoilerCondensation;
