within Modelitek.Controls.Hvac;

model DhwControl

//  parameter Boolean bool = true ;
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot annotation(
    Placement(visible = true, transformation(extent = {{112, 24}, {132, 44}}, rotation = 0)));
  Modelica.StateGraph.InitialStep initialStep(nIn = 1, nOut = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = -90, origin = {40, 56})));
  Modelica.StateGraph.TransitionWithSignal toOn(enableTimer = true, waitTime = params.Temps_avant_releve) "Transition to on" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {40, 20}, rotation = 270)));
  Modelica.StateGraph.StepWithSignal P_active(nIn = 1, nOut = 1) annotation(
    Placement(visible = true, transformation(origin = {40, -30}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.StateGraph.TransitionWithSignal toOff(enableTimer = false, waitTime = 10) "Transition to off" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {42, -78}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput T_haut annotation(
    Placement(visible = true, transformation(origin = {-386, 160}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-258, -28}, {-218, 12}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual Desactivation annotation(
    Placement(visible = true, transformation(origin = {-188, 68}, extent = {{-38, -108}, {-18, -88}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Demande_ECS annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{114, -46}, {144, -16}}, rotation = 0), iconTransformation(origin = {0, 106}, extent = {{172, -90}, {210, -52}}, rotation = 0)));
  Modelitek.Controls.Data.params_Control_pac params(Delta_Activ_ECS_summer = 5, Delta_Activ_ECS_winter = 7, Delta_Arret_BT = 0, Delta_Arret_ECS = 2, Temps_avant_releve = 60*60, coeff_T_bas_BT = 0.25, coeff_T_haut_BT = 0.75, marche_normal = true) annotation(
    Placement(visible = true, transformation(origin = {-166, 52}, extent = {{-224, -76}, {-204, -56}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tref_ECS(y = params.T_arret_optimise_ECS) annotation(
    Placement(visible = true, transformation(origin = {-370, 139}, extent = {{-64, -13}, {64, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput t_period annotation(
    Placement(visible = true, transformation(origin = {-102, -12}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {53, -133}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = params.T_arret_normal_ECS) annotation(
    Placement(visible = true, transformation(origin = {-301, -97}, extent = {{-53, -13}, {53, 13}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = params.Delta_arret_optimise_ECS) annotation(
    Placement(visible = true, transformation(origin = {-382, 114}, extent = {{-68, -15}, {68, 15}}, rotation = 0)));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch annotation(
    Placement(visible = true, transformation(origin = {-12, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch1 annotation(
    Placement(visible = true, transformation(origin = {-8, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-68, 76}, extent = {{-216, 50}, {-198, 68}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {-216, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = params.T_arret_optimise_ECS) annotation(
    Placement(visible = true, transformation(origin = {-301, -49}, extent = {{-47, -13}, {47, 13}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-212, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = params.T_marche_normal) annotation(
    Placement(visible = true, transformation(origin = {-287, 93}, extent = {{-49, -10}, {49, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {-188, 16}, extent = {{-38, -108}, {-18, -88}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = params.T_marche_normal) annotation(
    Placement(visible = true, transformation(origin = {-301, -193}, extent = {{-53, -11}, {53, 11}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less2 annotation(
    Placement(visible = true, transformation(origin = {-218, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-178, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = params.Temps_avant_releve) annotation(
    Placement(visible = true, transformation(origin = {-142, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And cond(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-90, -196}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer = true, waitTime = params.Temps_avant_releve) annotation(
    Placement(visible = true, transformation(origin = {44, -166}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal1(enableTimer = false, waitTime = 10) annotation(
    Placement(visible = true, transformation(origin = {46, -264}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.StateGraph.StepWithSignal stepWithSignal(nIn = 1, nOut = 1) annotation(
    Placement(visible = true, transformation(origin = {44, -216}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.StateGraph.InitialStep initialStep1(nIn = 1, nOut = 1) annotation(
    Placement(visible = true, transformation(origin = {44, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput Demande_releve annotation(
    Placement(visible = true, transformation(origin = {-10, -186}, extent = {{114, -46}, {144, -16}}, rotation = 0), iconTransformation(origin = {0, -8}, extent = {{172, -90}, {210, -52}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-217, -220}, extent = {{-9, -10}, {9, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {-178, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold2(threshold = params.t_desact_releve) annotation(
    Placement(visible = true, transformation(origin = {-142, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And and1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-92, -248}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less3 annotation(
    Placement(visible = true, transformation(origin = {-214, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression5(y = params.T_marche_normal) annotation(
    Placement(visible = true, transformation(origin = {-364, 43}, extent = {{-58, -12}, {58, 12}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-58, -22}, extent = {{-216, 50}, {-198, 68}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression6(y = params.Delta_marche_forcee_ECS) annotation(
    Placement(visible = true, transformation(origin = {-372, 13}, extent = {{-64, -12}, {64, 12}}, rotation = 0)));
  Modelica.Blocks.Logical.LogicalSwitch normal_force annotation(
    Placement(visible = true, transformation(origin = {-160, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression marche_normal_bool(y = params.marche_normal)  annotation(
    Placement(visible = true, transformation(origin = {-248, 82}, extent = {{-46, -14}, {46, 14}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold summer(threshold = 0.5)  annotation(
    Placement(visible = true, transformation(origin = {-62, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(initialStep.outPort[1], toOn.inPort) annotation(
    Line(points = {{40, 45.5}, {40, 24}}, color = {0, 0, 0}));
  connect(toOn.outPort, P_active.inPort[1]) annotation(
    Line(points = {{40, 18.5}, {40, -19}}));
  connect(P_active.outPort[1], toOff.inPort) annotation(
    Line(points = {{40, -40.5}, {42, -40.5}, {42, -74}}));
  connect(toOff.outPort, initialStep.inPort[1]) annotation(
    Line(points = {{42, -79.5}, {42, -100}, {76, -100}, {76, 67}, {40, 67}}, color = {0, 0, 0}));
  connect(P_active.active, Demande_ECS) annotation(
    Line(points = {{52, -30}, {130, -30}}, color = {255, 0, 255}));
  connect(logicalSwitch.y, toOn.condition) annotation(
    Line(points = {{0, 20}, {28, 20}}, color = {255, 0, 255}));
  connect(logicalSwitch1.y, toOff.condition) annotation(
    Line(points = {{4, -80}, {30, -80}, {30, -78}}, color = {255, 0, 255}));
  connect(Tref_ECS.y, add1.u1) annotation(
    Line(points = {{-300, 139}, {-294, 139}, {-294, 140}, {-286, 140}}, color = {0, 0, 127}));
  connect(realExpression1.y, add1.u2) annotation(
    Line(points = {{-307, 114}, {-307, 130}, {-286, 130}}, color = {0, 0, 127}));
  connect(T_haut, less.u1) annotation(
    Line(points = {{-386, 160}, {-228, 160}}, color = {0, 0, 127}));
  connect(add1.y, less.u2) annotation(
    Line(points = {{-265, 135}, {-247.1, 135}, {-247.1, 153}, {-227.1, 153}}, color = {0, 0, 127}));
  connect(T_haut, Desactivation.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, -30}, {-228, -30}}, color = {0, 0, 127}));
  connect(realExpression2.y, Desactivation.u2) annotation(
    Line(points = {{-249, -49}, {-227.5, -49}, {-227.5, -38}, {-228, -38}}, color = {0, 0, 127}));
  connect(less.y, logicalSwitch.u1) annotation(
    Line(points = {{-205, 160}, {-36, 160}, {-36, 28}, {-24, 28}}, color = {255, 0, 255}));
  connect(Desactivation.y, logicalSwitch1.u1) annotation(
    Line(points = {{-204, -30}, {-110, -30}, {-110, -72}, {-20, -72}}, color = {255, 0, 255}));
  connect(T_haut, less1.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, 104}, {-224, 104}}, color = {0, 0, 127}));
  connect(T_haut, greaterEqual.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, -82}, {-228, -82}}, color = {0, 0, 127}));
  connect(realExpression.y, greaterEqual.u2) annotation(
    Line(points = {{-243, -97}, {-232, -97}, {-232, -90}, {-228, -90}}, color = {0, 0, 127}));
  connect(greaterEqual.y, logicalSwitch1.u3) annotation(
    Line(points = {{-204, -82}, {-110, -82}, {-110, -88}, {-20, -88}}, color = {255, 0, 255}));
  connect(realExpression3.y, less1.u2) annotation(
    Line(points = {{-233, 93}, {-228.5, 93}, {-228.5, 96}, {-224, 96}}, color = {0, 0, 127}));
  connect(T_haut, less2.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, -170}, {-230, -170}}, color = {0, 0, 127}));
  connect(realExpression4.y, less2.u2) annotation(
    Line(points = {{-243, -193}, {-240, -193}, {-240, -178}, {-230, -178}}, color = {0, 0, 127}));
  connect(less2.y, timer.u) annotation(
    Line(points = {{-206, -170}, {-190, -170}}, color = {255, 0, 255}));
  connect(timer.y, greaterEqualThreshold.u) annotation(
    Line(points = {{-166, -170}, {-154, -170}}, color = {0, 0, 127}));
  connect(less2.y, cond.u[1]) annotation(
    Line(points = {{-206, -170}, {-200, -170}, {-200, -196}, {-102, -196}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, cond.u[2]) annotation(
    Line(points = {{-130, -170}, {-104, -170}, {-104, -196}, {-102, -196}}, color = {255, 0, 255}));
  connect(transitionWithSignal1.outPort, initialStep1.inPort[1]) annotation(
    Line(points = {{46, -265.5}, {46, -286}, {80, -286}, {80, -119}, {44, -119}}));
  connect(stepWithSignal.outPort[1], transitionWithSignal1.inPort) annotation(
    Line(points = {{44, -226.5}, {46, -226.5}, {46, -260}}));
  connect(initialStep1.outPort[1], transitionWithSignal.inPort) annotation(
    Line(points = {{44, -140.5}, {44, -162}}));
  connect(transitionWithSignal.outPort, stepWithSignal.inPort[1]) annotation(
    Line(points = {{44, -167.5}, {44, -205}}));
  connect(cond.y, transitionWithSignal.condition) annotation(
    Line(points = {{-76, -196}, {-36, -196}, {-36, -166}, {32, -166}}, color = {255, 0, 255}));
  connect(stepWithSignal.active, Demande_releve) annotation(
    Line(points = {{56, -216}, {120, -216}}, color = {255, 0, 255}));
  connect(T_haut, greater.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, -220}, {-228, -220}}, color = {0, 0, 127}));
  connect(realExpression4.y, greater.u2) annotation(
    Line(points = {{-243, -193}, {-240, -193}, {-240, -228}, {-228, -228}}, color = {0, 0, 127}));
  connect(greater.y, timer1.u) annotation(
    Line(points = {{-208, -220}, {-190, -220}}, color = {255, 0, 255}));
  connect(timer1.y, greaterEqualThreshold2.u) annotation(
    Line(points = {{-166, -220}, {-154, -220}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold2.y, and1.u[1]) annotation(
    Line(points = {{-130, -220}, {-104, -220}, {-104, -248}}, color = {255, 0, 255}));
  connect(greater.y, and1.u[2]) annotation(
    Line(points = {{-208, -220}, {-198, -220}, {-198, -248}, {-104, -248}}, color = {255, 0, 255}));
  connect(and1.y, transitionWithSignal1.condition) annotation(
    Line(points = {{-78, -248}, {-38, -248}, {-38, -264}, {34, -264}}, color = {255, 0, 255}));
  connect(T_haut, less3.u1) annotation(
    Line(points = {{-386, 160}, {-306, 160}, {-306, 62}, {-226, 62}}, color = {0, 0, 127}));
  connect(add.y, less3.u2) annotation(
    Line(points = {{-256, 38}, {-250, 38}, {-250, 52}, {-226, 52}}, color = {0, 0, 127}));
  connect(realExpression5.y, add.u1) annotation(
    Line(points = {{-300, 43}, {-288, 43}, {-288, 42}, {-276, 42}}, color = {0, 0, 127}));
  connect(realExpression6.y, add.u2) annotation(
    Line(points = {{-302, 13}, {-288, 13}, {-288, 32}, {-276, 32}}, color = {0, 0, 127}));
  connect(less1.y, normal_force.u1) annotation(
    Line(points = {{-201, 104}, {-184, 104}, {-184, 90}, {-172, 90}}, color = {255, 0, 255}));
  connect(less3.y, normal_force.u3) annotation(
    Line(points = {{-202, 60}, {-186, 60}, {-186, 74}, {-172, 74}}, color = {255, 0, 255}));
  connect(normal_force.y, logicalSwitch.u3) annotation(
    Line(points = {{-148, 82}, {-112, 82}, {-112, 12}, {-24, 12}}, color = {255, 0, 255}));
  connect(marche_normal_bool.y, normal_force.u2) annotation(
    Line(points = {{-198, 82}, {-172, 82}}, color = {255, 0, 255}));
  connect(summer.y, logicalSwitch.u2) annotation(
    Line(points = {{-51, -12}, {-38, -12}, {-38, 20}, {-24, 20}}, color = {255, 0, 255}));
  connect(summer.y, logicalSwitch1.u2) annotation(
    Line(points = {{-51, -12}, {-36, -12}, {-36, -80}, {-20, -80}}, color = {255, 0, 255}));
  connect(t_period, summer.u) annotation(
    Line(points = {{-102, -12}, {-74, -12}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-260, -140}, {180, 120}}), graphics = {Rectangle(lineColor = {102, 44, 145}, fillColor = {170, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-252, 116}, {172, -132}}), Text(lineColor = {0, 0, 255}, extent = {{-210, 134}, {90, 174}}, textString = "%name"), Text(extent = {{-176, 78}, {74, -94}}, textString = "PAC-ECS")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-480, 180}, {140, -300}}), graphics = {Rectangle(origin = {-128, 22}, lineColor = {0, 0, 127}, fillColor = {0, 255, 157}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-178, 156}, {16, 0}}), Text(origin = {-68, 40}, lineColor = {0, 0, 127}, extent = {{-118, 102}, {-60, 92}}, textString = "Activation"), Rectangle(origin = {-129, 35}, lineColor = {0, 0, 127}, fillColor = {255, 191, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-177, -45}, {19, -164}}), Text(origin = {-68, 0}, lineColor = {0, 0, 127}, extent = {{-106, -38}, {-48, -48}}, textString = "Desactivation"), Rectangle(origin = {-129, -99}, lineColor = {0, 0, 127}, fillColor = {255, 162, 115}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-177, -45}, {19, -164}}), Text(origin = {-198, -112}, lineColor = {0, 0, 127}, extent = {{-106, -38}, {-48, -48}}, textString = "Relève")}),
    Documentation(info = "<html><head></head><body><div><b><u>La marche normale (hiver) est enclenchée :</u></b></div><div><b><u><br></u></b></div><div><ul><li>Par une activation du mode marche « Normal » sur le webserver.</li><li><b>ET Si la température du ballon ECS est inférieure à la température de consigne basse (Marche normal).</b></li><li>ET La sonde de températures du ballon n’est pas en défaut.</li><li>ET Pas de défaut interdisant le fonctionnement de la PAC</li><li>ET Pas de priorité en cours plus importante.</li></ul></div><div><br></div><div>➢ La marche normale s’arrête :</div><div><ul><li>Par une désactivation du mode marche « Normal » sur le webserver.</li><li><b>OU Si la température du ballon ECS est supérieure ou égale à la température d’arrêt (Arrêt normal).</b></li><li>OU Si la sonde de températures du ballon est en défaut.</li><li>OU Si un défaut interdit le fonctionnement de la PAC</li><li>OU Par l’activation d’une priorité plus haute.</li></ul></div><div><br></div><div><div><b><u>La marche forcée est enclenchée :</u></b></div><div><ul><li>Par une activation du mode marche « Forcé » sur le webserver.</li><li><b>ET Si la température du ballon ECS est inférieure à la température d’arrêt (Arrêt normal) – 3°C</b></li><li>ET La sonde de température du ballon n’est pas en défaut.</li><li>ET Pas de défaut interdisant le fonctionnement de la PAC</li><li>ET Pas de priorité en cours plus importante.</li></ul></div><div>➢ La marche forcée s’arrête :</div><div><ul><li>Par une désactivation du mode marche « Forcé » sur le webserver.</li><li><b>OU Si la température du ballon ECS est supérieure ou égale à la température d’arrêt (Arrêt normal).</b></li><li>OU Si la sonde de température du ballon est en défaut.</li><li>OU Si un défaut interdit le fonctionnement de la PAC</li><li>OU Par l’activation d’une priorité plus haute.</li></ul></div></div><div><br></div><div><br></div><div><div><b><u>➢ La marche optimisée (été) est enclenchée :</u></b></div><div><ul><li>Par une activation du mode marche « Optimisé » sur le webserver.</li><li><b>ET Si la température du ballon ECS est inférieure à la température d’arrêt (Arrêt optimisé) – 5°C.</b></li><li>ET Si la boucle solaire est optimisable (StatutBSol_Opt=VRAI) voir (voir Chap : Détection optimisation)</li><li>ET La sonde de température du ballon n’est pas en défaut.</li><li>ET Pas de défaut interdisant le fonctionnement de la PAC</li><li>ET Pas de priorité en cours plus importante.</li></ul></div></div><div><br></div><div><div>➢ La marche optimisée s’arrête :</div><div><ul><li>Par une désactivation du mode marche « Optimisé » sur le webserver.</li><li><b>OU Si la température du ballon est supérieure ou égale à la température d’arrêt optimisé (Arrêt optimisé).</b></li><li>OU Si la boucle solaire n’est plus optimisable (StatutBSol_Opt=VRAI) (voir Chap : Détection optimisation)</li><li>OU Si la sonde de température du ballon est en défaut.</li><li>OU Si un défaut interdit le fonctionnement de la PAC</li><li>OU Par l’activation d’une priorité plus haute.</li><li>OU La saison sélectionnée n’est plus « Stand-by OU Eté »</li></ul></div></div><div><br></div><div><br></div><div><div><b><u>La marche normale de la résistance électrique est enclenchée :</u></b></div><div><ul><li>Par une activation du mode marche «Normal» sur le webserver.</li><li>E<b>T Si la température du ballon est inférieure à la température de marche (Marche normal) pendant un temps défini en paramètre (Temps avant activation)</b></li><li>ET Les sondes de températures associées du ballon ne sont pas en défaut.</li></ul></div><div><br></div><div>➢ La marche normale de la résistance électrique s’arrête :</div><div><ul><li>Par une désactivation du mode marche «Normal» sur le webserver.</li><li>OU <b>Si la température du ballon est supérieure à la température de marche (Marche normal) pendant 10 minutes</b></li><li>OU La sonde de température du ballon est en défaut.</li></ul></div></div></body></html>"));
end DhwControl;
