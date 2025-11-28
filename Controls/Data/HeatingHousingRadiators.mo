within Modelitek.Controls.Data;

record HeatingHousingRadiators
  extends SetpointParams(
    usePoints = true,
    Text1 = -7,   Tset1 = 60,
    Text2 = 15,   Tset2 = 40,
    a = -1.2,
    b = 50.0
  );
end HeatingHousingRadiators;
