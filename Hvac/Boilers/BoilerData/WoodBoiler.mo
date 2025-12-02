within Modelitek.Hvac.Boilers.BoilerData;

record WoodBoiler
  extends BoilerThermalParams(
    alpha_nom = 0.00,
    T_ref_nom = 70,
    alpha_int = 0.00,
    T_ref_int = 70
  );
end WoodBoiler;
