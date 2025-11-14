within Modelitek.Controls.Data;

record params_heattanksimple "Generic data record providing inputs for specific collector data records"
  extends Modelica.Icons.Record;
  parameter Real a = -1.4 "pente courbe de chauffe";
  parameter Real b = 56 "origine courbe de chauffe";
  annotation(
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "params",
    Documentation(info = "<html>
  <p>
  Tableau de paramètres, pour simplifier l'externalisation des paramètres d'un modèle et faciliter l'optimisation-calibration
  </p>
</html>"));
end params_heattanksimple;
