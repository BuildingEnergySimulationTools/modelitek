within Modelitek.Controls.Data;

record params_Control_pac "Generic data record providing inputs for specific collector data records"
  extends Modelica.Icons.Record;
  parameter Real Delta_Arret_BT "Delta_Arret_Normal";
  parameter Real Delta_Arret_ECS "Delta_Arret_Normal";
  parameter Real coeff_T_haut_BT "param coeff_T_haut_BT";
  parameter Real coeff_T_bas_BT "param coeff_T_bas_BT";
  parameter Real T_arret_normal_ECS = 47 +273.15 "K";
  parameter Real T_arret_optimise_ECS = 54 +273.15 "K";
  parameter Real Delta_arret_optimise_ECS =5 "K";
  parameter Real Delta_marche_forcee_ECS = 3 "K";
  parameter Real T_marche_normal = 40 +273.15 "Consigne basse, K";
  parameter Real T_consigne_clim_summer = 16 +273.15 "";
  parameter Real T_arret_clim_summer = 10+273.15 "";
  parameter Real Delta_Activ_ECS_winter=2 "Delta_Activ_ECS hiver";
  parameter Real Delta_Activ_ECS_summer=2 "Delta_Activ_ECS ete";
  parameter Real Temps_avant_releve "secondes";
  parameter Real Tmin_vanne = 5 *60 "secondes";
  parameter Real t_desact_releve = 10 *60 "secondes";
  parameter Boolean marche_normal = true "ou forcée";
  annotation(
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "params",
    Documentation(info = "<html>
  <p>
  Tableau de paramètres, pour simplifier l'externalisation des paramètres d'un modèle et faciliter l'optimisation-calibration
  </p>
</html>"));
end params_Control_pac;
