within Modelitek.Controls.Data;

record HeatingHousingFloor
  extends SetpointParams(
    usePoints = true,
    Text1 = -7,   Tset1 = 35,
    Text2 = 15,   Tset2 = 25,
    a = -0.5,
    b = 30.0
  );
end HeatingHousingFloor;
