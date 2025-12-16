within Modelitek.Hvac.HeatPumps;

model CascadeHP
  
  import Modelitek.Hvac.HeatPumps.HPData;
  
  parameter Integer n_hp = 1;
  parameter HPData.AirWater_inf100kW cfg;
  parameter Real tau = 300;

  HPmatrix HP[n_hp](each cfg=cfg);

  Modelica.Blocks.Interfaces.RealInput Q_req annotation(
    Placement(transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-122, 78}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_amont annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-120, 22}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_aval annotation(
    Placement(transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-120, -36}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput heating annotation(
    Placement(transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-122, -88}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput P_fou annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
              iconTransformation(origin = {125, 27}, extent = {{-25, -25}, {25, 25}})));

  Modelica.Blocks.Interfaces.IntegerOutput n_active annotation(
    Placement(transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}),
              iconTransformation(origin = {125, -27}, extent = {{-25, -25}, {25, 25}})));

  Real Q_remaining[n_hp];
  Real COP_cascade;
  Real P_abs_total;
  Real P_fou_pc;

  Integer n_instant;
  discrete Integer n_prev(start=0);
  discrete Integer n_active_int(start=0);
  discrete Real t_change(start=0);
  Modelica.Blocks.Interfaces.RealOutput COP annotation(
    Placement(transformation(origin = {110, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 88}, extent = {{-10, -10}, {10, 10}})));
equation

  for i in 1:n_hp loop
    connect(T_amont, HP[i].t_amont);
    connect(T_aval, HP[i].t_aval);
    connect(heating, HP[i].Heating);
    if i == 1 then
      Q_remaining[i] = Q_req;
    else
      Q_remaining[i] = max(0, Q_remaining[i-1] - HP[i-1].P_fou);
    end if;
    HP[i].Q_req = Q_remaining[i];
  end for;

  P_fou = sum(HP[i].P_fou for i in 1:n_hp);
  P_fou_pc = sum(HP[i].P_fou_pc for i in 1:n_hp);
  P_abs_total = sum(HP[i].P_abs_lr for i in 1:n_hp);

  if P_abs_total > 0 then
    COP_cascade = P_fou / P_abs_total;
  else
    COP_cascade = 0;
  end if;

  n_instant = sum(if HP[i].P_fou > 1 then 1 else 0 for i in 1:n_hp);

  when change(n_instant) then
    n_prev = n_instant;
    t_change = time;
  end when;

  when time >= t_change + tau then
    n_active_int = n_prev;
  end when;

  n_active = n_active_int;
  COP = COP_cascade;  

end CascadeHP;
