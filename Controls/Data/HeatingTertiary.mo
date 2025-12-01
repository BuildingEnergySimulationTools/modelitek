within Modelitek.Controls.Data;

record HeatingTertiary
  extends Modelitek.Controls.Data.SetpointParams(
    usePoints = true,
    Text1 = -7,   Tset1 = 55,
    Text2 = 15,   Tset2 = 35,
    a = -1.0,
    b = 50.0
  );
end HeatingTertiary;
