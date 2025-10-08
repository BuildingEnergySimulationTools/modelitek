within Modelitek.Hvac.Tanks.Data;

record params_tank "Generic data record providing inputs for specific collector data records"
  extends Modelica.Icons.Record;
  parameter Real VTan "volume ballon";
  parameter Real hTan "hauteur ballon";
  parameter Real dIns "param C";
  parameter Integer nSeg "nombre segments ballon";
  parameter Real T_ref "param E";
  parameter Real T_start "param F";
  parameter Real T_secu_bas "param T_secu_bas";
  annotation(
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "params",
    Documentation(info = "<html>
  <p>
  Tableau de paramètres, pour simplifier l'externalisation des paramètres d'un modèle et faciliter l'optimisation-calibration
  </p>
</html>"));
end params_tank;
