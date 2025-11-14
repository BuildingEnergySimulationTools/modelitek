within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model ModFoncPAC
  Modelica.Blocks.Interfaces.RealInput Q_req_chauffage annotation(
    Placement(transformation(origin = {-119, 59}, extent = {{-19, -19}, {19, 19}}), iconTransformation(origin = {-120, 68}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput Q_req_ECS annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput Q_req_clim annotation(
    Placement(transformation(origin = {-120, -56}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -68}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanOutput ModChauf annotation(
    Placement(transformation(origin = {228, 64}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput ModECS annotation(
    Placement(transformation(origin = {230, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput ModClim annotation(
    Placement(transformation(origin = {230, -58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0.0001)  annotation(
    Placement(transformation(origin = {-60, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold = 0.0001) annotation(
    Placement(transformation(origin = {-60, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2 annotation(
    Placement(transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(transformation(origin = {14, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And and2 annotation(
    Placement(transformation(origin = {10, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(transformation(origin = {40, 44}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(transformation(origin = {-26, -16}, extent = {{-8, -8}, {8, 8}})));
  Modelica.StateGraph.InitialStep initialStep(nOut = 1, nIn = 1)  annotation(
    Placement(transformation(origin = {65, -11}, extent = {{-9, -9}, {9, 9}})));
  Modelica.StateGraph.StepWithSignal chauffage(nIn = 1, nOut = 1)  annotation(
    Placement(transformation(origin = {140, 32}, extent = {{-10, 10}, {10, -10}})));
  Modelica.StateGraph.StepWithSignal ECS(nIn = 1, nOut = 1)  annotation(
    Placement(transformation(origin = {142, -6}, extent = {{-10, 10}, {10, -10}})));
  Modelica.StateGraph.StepWithSignal Clim(nIn = 1, nOut = 1)  annotation(
    Placement(transformation(origin = {146, -48}, extent = {{-10, 10}, {10, -10}})));
  Modelica.StateGraph.TransitionWithSignal Start_ModChauf annotation(
    Placement(transformation(origin = {110, 32}, extent = {{-10, 10}, {10, -10}})));
  Modelica.StateGraph.TransitionWithSignal stop_ModChauf annotation(
    Placement(transformation(origin = {170, 30}, extent = {{-10, 10}, {10, -10}})));
  Modelica.StateGraph.TransitionWithSignal start_ModECS annotation(
    Placement(transformation(origin = {112, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.StateGraph.TransitionWithSignal stop_ModECS annotation(
    Placement(transformation(origin = {174, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.StateGraph.TransitionWithSignal start_ModClim annotation(
    Placement(transformation(origin = {114, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.StateGraph.TransitionWithSignal stop_ModClim annotation(
    Placement(transformation(origin = {172, -48}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.StateGraph.Alternative alternative(nBranches = 3)  annotation(
    Placement(transformation(origin = {145, -24}, extent = {{-55, -58}, {55, 58}})));
  Modelica.Blocks.Logical.Not not2 annotation(
    Placement(transformation(origin = {-26, 38}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Logical.Not not3 annotation(
    Placement(transformation(origin = {-28, -86}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Logical.Or or2 annotation(
    Placement(transformation(origin = {40, -86}, extent = {{-8, -8}, {8, 8}})));
equation
  connect(Q_req_chauffage, greaterThreshold.u) annotation(
    Line(points = {{-118, 60}, {-84, 60}, {-84, 66}, {-72, 66}}, color = {0, 0, 127}));
  connect(Q_req_ECS, greaterThreshold1.u) annotation(
    Line(points = {{-120, 0}, {-86, 0}, {-86, 6}, {-72, 6}}, color = {0, 0, 127}));
  connect(Q_req_clim, greaterThreshold2.u) annotation(
    Line(points = {{-120, -56}, {-92, -56}, {-92, -50}, {-72, -50}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, and1.u1) annotation(
    Line(points = {{-48, 66}, {-40, 66}, {-40, 64}, {2, 64}}, color = {255, 0, 255}));
  connect(greaterThreshold1.y, not1.u) annotation(
    Line(points = {{-48, 6}, {-48, -16}, {-36, -16}}, color = {255, 0, 255}));
  connect(not1.y, and1.u2) annotation(
    Line(points = {{-17, -16}, {-12, -16}, {-12, 56}, {2, 56}}, color = {255, 0, 255}));
  connect(Start_ModChauf.outPort, chauffage.inPort[1]) annotation(
    Line(points = {{111.5, 32}, {130, 32}}));
  connect(chauffage.outPort[1], stop_ModChauf.inPort) annotation(
    Line(points = {{150, 32}, {158, 32}, {158, 30}, {166, 30}}));
  connect(start_ModECS.outPort, ECS.inPort[1]) annotation(
    Line(points = {{113.5, -6}, {132, -6}}));
  connect(ECS.outPort[1], stop_ModECS.inPort) annotation(
    Line(points = {{152, -6}, {170, -6}}));
  connect(start_ModClim.outPort, Clim.inPort[1]) annotation(
    Line(points = {{115.5, -50}, {125.5, -50}, {125.5, -48}, {135, -48}}));
  connect(Clim.outPort[1], stop_ModClim.inPort) annotation(
    Line(points = {{156, -48}, {168, -48}}));
  connect(chauffage.active, ModChauf) annotation(
    Line(points = {{140, 44}, {140, 64}, {228, 64}}, color = {255, 0, 255}));
  connect(ECS.active, ModECS) annotation(
    Line(points = {{142, 6}, {142, 14}, {210, 14}, {210, 2}, {230, 2}}, color = {255, 0, 255}));
  connect(Clim.active, ModClim) annotation(
    Line(points = {{146, -36}, {148, -36}, {148, -28}, {210, -28}, {210, -58}, {230, -58}}, color = {255, 0, 255}));
  connect(initialStep.outPort[1], alternative.inPort) annotation(
    Line(points = {{74, -10}, {80, -10}, {80, -24}, {88, -24}}));
  connect(alternative.outPort, initialStep.inPort[1]) annotation(
    Line(points = {{201, -24}, {208, -24}, {208, -72}, {42, -72}, {42, -10}, {56, -10}}));
  connect(and1.y, Start_ModChauf.condition) annotation(
    Line(points = {{26, 64}, {110, 64}, {110, 44}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, not2.u) annotation(
    Line(points = {{-48, 66}, {-40, 66}, {-40, 38}, {-34, 38}}, color = {255, 0, 255}));
  connect(not2.y, or1.u1) annotation(
    Line(points = {{-20, 38}, {10, 38}, {10, 44}, {30, 44}}, color = {255, 0, 255}));
  connect(greaterThreshold1.y, or1.u2) annotation(
    Line(points = {{-48, 6}, {6, 6}, {6, 38}, {30, 38}}, color = {255, 0, 255}));
  connect(or1.y, stop_ModChauf.condition) annotation(
    Line(points = {{48, 44}, {62, 44}, {62, 76}, {170, 76}, {170, 42}}, color = {255, 0, 255}));
  connect(greaterThreshold1.y, start_ModECS.condition) annotation(
    Line(points = {{-48, 6}, {26, 6}, {26, -26}, {112, -26}, {112, -18}}, color = {255, 0, 255}));
  connect(not1.y, stop_ModECS.condition) annotation(
    Line(points = {{-18, -16}, {20, -16}, {20, -26}, {174, -26}, {174, -18}}, color = {255, 0, 255}));
  connect(greaterThreshold2.y, and2.u1) annotation(
    Line(points = {{-48, -50}, {-32, -50}, {-32, -48}, {-2, -48}}, color = {255, 0, 255}));
  connect(not1.y, and2.u2) annotation(
    Line(points = {{-18, -16}, {-12, -16}, {-12, -56}, {-2, -56}}, color = {255, 0, 255}));
  connect(and2.y, start_ModClim.condition) annotation(
    Line(points = {{22, -48}, {38, -48}, {38, -70}, {114, -70}, {114, -62}}, color = {255, 0, 255}));
  connect(greaterThreshold2.y, not3.u) annotation(
    Line(points = {{-48, -50}, {-44, -50}, {-44, -86}, {-38, -86}}, color = {255, 0, 255}));
  connect(not3.y, or2.u2) annotation(
    Line(points = {{-19, -86}, {-8, -86}, {-8, -92}, {30, -92}}, color = {255, 0, 255}));
  connect(greaterThreshold1.y, or2.u1) annotation(
    Line(points = {{-48, 6}, {26, 6}, {26, -86}, {30, -86}}, color = {255, 0, 255}));
  connect(or2.y, stop_ModClim.condition) annotation(
    Line(points = {{49, -86}, {172, -86}, {172, -60}}, color = {255, 0, 255}));
  connect(alternative.split[1], Start_ModChauf.inPort) annotation(
    Line(points = {{102, -24}, {102, 11}, {106, 11}, {106, 32}}));
  connect(alternative.split[2], start_ModECS.inPort) annotation(
    Line(points = {{102, -24}, {109, -24}, {109, -6}, {108, -6}}));
  connect(alternative.split[3], start_ModClim.inPort) annotation(
    Line(points = {{102, -24}, {102, -30}, {110, -30}, {110, -50}}));
  connect(stop_ModChauf.outPort, alternative.join[1]) annotation(
    Line(points = {{172, 30}, {174, 30}, {174, -24}, {188, -24}}));
  connect(stop_ModECS.outPort, alternative.join[2]) annotation(
    Line(points = {{176, -6}, {188, -6}, {188, -24}}));
  connect(stop_ModClim.outPort, alternative.join[3]) annotation(
    Line(points = {{174, -48}, {188, -48}, {188, -24}}));

annotation(
    Diagram(coordinateSystem(extent = {{-140, 80}, {240, -100}})),
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}));
end ModFoncPAC;
