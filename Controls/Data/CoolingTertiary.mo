within Modelitek.Controls.Data;

record CoolingTertiary
  extends SetpointParams(
    usePoints = true,
    Text1 = 26,   Tset1 = 14,
    Text2 = 32,   Tset2 = 7,
    a = -1.17,
    b = 44.4
  );
end CoolingTertiary;
