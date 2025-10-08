within Modelitek.Controls.Data;

record params_heattank "Generic data record providing inputs for specific collector data records"
  extends Modelica.Icons.Record;
  parameter Real a = -0.85 "pente courbe de chauffe";
  parameter Real b = 39.75 "origine courbe de chauffe";
  parameter Real T_ref_tank = 20 "température de référence pour calcul des coefficients";

  annotation(
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "params",
    Documentation(info = "<html>
  <p>
  Tableau de paramètres, pour simplifier l'externalisation des paramètres d'un modèle et faciliter l'optimisation-calibration
  </p>
</html>"));
end params_heattank;
