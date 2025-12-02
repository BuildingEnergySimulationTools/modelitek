within Modelitek.Hvac.Boilers.BoilerData;

record BoilerThermalParams
  parameter Real alpha_nom "α_th,nom (%/K)";
  parameter Real T_ref_nom "θ_av,ref,nom (°C)";
  parameter Real alpha_int "α_th,int (%/K)";
  parameter Real T_ref_int "θ_av,ref,int (°C)";
end BoilerThermalParams;
