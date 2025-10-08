within Modelitek.Hvac.DomesticHotWater;

  
  model DHW_generator
    function generate_shower_schedule
      input Integer nb_showers;
      input Integer t_shower;
      input Integer state_in[4];
      output Integer schedule[60];
      output Integer state_out[4];
    protected
      Integer start_minute;
      Real random_value;
    algorithm
      for i in 1:60 loop
        schedule[i] := 0;
      end for;
      state_out := state_in;
      for i in 1:nb_showers loop
        (random_value, state_out) := Modelica.Math.Random.Generators.Xorshift128plus.random(state_out);
        start_minute := 1 + integer(noEvent(random_value * (60 - t_shower)));
        for j in start_minute:start_minute + t_shower - 1 loop
          if j <= 60 then
            schedule[j] := schedule[j] + 1;
          end if;
        end for;
      end for;
    end generate_shower_schedule;
  
    function getCurrentMonth
      input Integer day_of_year;
      input Integer daysCumulative[12];
      output Integer current_month;
    algorithm
      current_month := 1;
      for i in 2:12 loop
        if noEvent(day_of_year > daysCumulative[i - 1]) then
          current_month := i;
        end if;
      end for;
    end getCurrentMonth;
  
    parameter Integer n_dwellings = 19 "Nombre de logements ";
    parameter Real v_per_pers = 55"Volume d'eau chaude par personne par jour (L)";
    Real v_per_dwelling = n_people_per_dwelling * v_per_pers;
    parameter Real ratio_bath_shower = 0.8;
    parameter Integer t_shower = 7"Durée d'une douche (min)";
    parameter Real d_shower = 8 "Débit d'eau (L/min)";
    parameter Integer n_people_per_dwelling = 3 "Nombre de personnes par logement en moyenne";
    parameter Real s_tot_building = 2480" Surface habitable du bâtiment (m2)";
    parameter Real Tc_utile = 40 "Température d'utilisation de l'eau chaude sanitaire (°C)";
    parameter Real Tc_produit = 60"Température de production de l'eau chaude sanitaire (°C)";
  
  
    Modelica.Blocks.Interfaces.RealOutput Q_ecs_RE2020_h annotation(
      Placement(visible = true, transformation(origin = {120, -10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {114, -42}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Q_ecs_COSTIC_h annotation(
      Placement(visible = true, transformation(origin = {120, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {115, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Q_ecs_RANDOM_min annotation(
      Placement(visible = true, transformation(origin = {120, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {114, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput Puissance_ECS annotation(
      Placement(visible = true, transformation(origin = {120, -52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {114, 84}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput T_eau_froide annotation(
      Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput E_ecs annotation(
      Placement(visible = true, transformation(origin = {119, -87}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {115, -85}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    Real P;
  protected
    parameter Real Cp = 4186 "J/kg/K";
    parameter Real rho = 1 "kg/L";
    parameter Integer start_day = 1;
    parameter Integer month_lengths[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    parameter Integer daysCumulative[12] = {31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
    parameter Real coefficients_COSTIC_hour_weekday[24] = {0.264, 0.096, 0.048, 0.024, 0.144, 0.384, 1.152, 2.064, 1.176, 1.08, 1.248, 1.224, 1.296, 1.104, 0.84, 0.768, 0.768, 1.104, 1.632, 2.088, 2.232, 1.608, 1.032, 0.624};
    parameter Real coefficients_COSTIC_hour_saturday[24] = {0.408, 0.192, 0.072, 0.048, 0.072, 0.168, 0.312, 0.624, 1.08, 1.584, 1.872, 1.992, 1.92, 1.704, 1.536, 1.2, 1.248, 1.128, 1.296, 1.32, 1.392, 1.2, 0.936, 0.696};
    parameter Real coefficients_COSTIC_hour_sunday[24] = {0.384, 0.168, 0.096, 0.048, 0.048, 0.048, 0.12, 0.216, 0.576, 1.128, 1.536, 1.752, 1.896, 1.872, 1.656, 1.296, 1.272, 1.248, 1.776, 2.016, 2.04, 1.392, 0.864, 0.552};
    parameter Real coefficients_RE2020_weekday[24] = {0, 0, 0, 0, 0, 0, 0, 0.028, 0.029, 0, 0, 0, 0, 0, 0, 0, 0, 0.007, 0.022, 0.022, 0.022, 0.007, 0.007, 0.007};
    parameter Real coefficients_RE2020_weekend[24] = {0, 0, 0, 0, 0, 0, 0, 0.028, 0.029, 0, 0, 0, 0, 0, 0, 0, 0, 0.011, 0.011, 0.029, 0.011, 0.0011, 0.0011, 0.0};
    parameter Real coefficients_COSTIC_month[12] = {1.11, 1.20, 1.11, 1.06, 1.03, 0.93, 0.84, 0.72, 0.92, 1.03, 1.04, 1.01};
    parameter Real coefficients_RE2020_month[12] = {1.05, 1.05, 1.05, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 1.05, 1.05, 1.05};
    Integer current_day;
    Integer current_month;
    Integer current_hour;
    Integer current_minute;
    Integer day_of_year;
    Real v_liters_day;
    Real v_shower_bath_per_day;
    Real Q_ECS_RE2020;
    Real Q_ECS_COSTIC;
    Real coef_hour_COSTIC;
    Real coef_hour_RE2020;
    Integer shower_schedule[60];
    Integer active_showers;
    Integer nb_showers_hour;
    Integer state[4];
  initial equation
    state = Modelica.Math.Random.Generators.Xorshift128plus.initialState(5, 10);
  equation
    day_of_year = noEvent(integer(time / 86400));
    current_hour = noEvent(mod(integer(time / 3600), 24));
    current_minute = noEvent(integer(mod(time / 60, 60)));
    current_day = noEvent(mod(start_day + day_of_year, 7)) + 1;
    current_month = noEvent(getCurrentMonth(day_of_year, daysCumulative));
    v_liters_day = n_dwellings * v_per_dwelling;
    v_shower_bath_per_day = ratio_bath_shower * v_liters_day;
    coef_hour_COSTIC = noEvent(coefficients_COSTIC_month[current_month] * (if current_day == 7 then coefficients_COSTIC_hour_sunday[current_hour + 1] elseif current_day == 6 then coefficients_COSTIC_hour_saturday[current_hour + 1] else coefficients_COSTIC_hour_weekday[current_hour + 1]));
    coef_hour_RE2020 = noEvent(coefficients_RE2020_month[current_month] * (if current_day >= 6 then coefficients_RE2020_weekend[current_hour + 1] else coefficients_RE2020_weekday[current_hour + 1]));
    Q_ECS_COSTIC = noEvent(coef_hour_COSTIC * v_shower_bath_per_day / sum(if current_day == 7 then coefficients_COSTIC_hour_sunday elseif current_day == 6 then coefficients_COSTIC_hour_saturday else coefficients_COSTIC_hour_weekday));
    Q_ECS_RE2020 = noEvent(coef_hour_RE2020 * v_shower_bath_per_day / sum(if current_day >= 6 then coefficients_RE2020_weekend else coefficients_RE2020_weekday));
    Q_ecs_RE2020_h = Q_ECS_RE2020;
    Q_ecs_COSTIC_h = Q_ECS_COSTIC;
    when sample(0, 3600) then
      nb_showers_hour = integer(coef_hour_COSTIC * (v_per_dwelling / 24) * n_dwellings / (d_shower * t_shower));
      (shower_schedule, state) = generate_shower_schedule(nb_showers_hour, t_shower, state);
    end when;
    active_showers = shower_schedule[current_minute + 1];
    Q_ecs_RANDOM_min = active_showers * d_shower * 60;
    Puissance_ECS = rho * Cp * (Q_ecs_RANDOM_min / 3600) * (Tc_utile - T_eau_froide);
    P = rho * Cp * (Q_ecs_COSTIC_h / 3600) * (Tc_utile - T_eau_froide);
    der(E_ecs) = Puissance_ECS / 3600000;
  // E_ecs=0;
    annotation(
      uses(Modelica(version = "3.2.3")),
      Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Bitmap(origin = {11, 8}, extent = {{131, -86}, {-131, 86}}, imageSource = "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")}),
  Documentation(info = "<html><head></head><body><h1>DomesticHotWater</h1><div><br></div>This model generates realistic DHW draw-off profiles for residential buildings at two time scales: (i)&nbsp;<strong data-start=\"260\" data-end=\"270\">hourly</strong>&nbsp;demands based on regulatory/empirical profiles (COSTIC and RE2020), and (ii) a&nbsp;<strong data-start=\"350\" data-end=\"386\">minute-scale stochastic schedule</strong>&nbsp;of showers that recreates short, high-power peaks. It also computes the&nbsp;<strong data-start=\"459\" data-end=\"490\">instantaneous thermal power</strong>&nbsp;required to reach a target useful temperature given the cold-water temperature.<div><li data-start=\"189\" data-end=\"527\"><p data-start=\"191\" data-end=\"203\"><strong data-start=\"191\" data-end=\"203\">Outputs:</strong></p><ul data-start=\"206\" data-end=\"527\"><li data-start=\"206\" data-end=\"331\"><p data-start=\"208\" data-end=\"331\"><code data-start=\"208\" data-end=\"224\">Q_ecs_COSTIC_h</code>,&nbsp;<code data-start=\"226\" data-end=\"242\" data-is-only-node=\"\">Q_ecs_RE2020_h</code>&nbsp;—&nbsp;<strong data-start=\"245\" data-end=\"255\">hourly</strong>&nbsp;DHW volumes based on COSTIC and RE2020 profiles (with month/day weighting).</p></li><li data-start=\"334\" data-end=\"425\"><p data-start=\"336\" data-end=\"425\"><code data-start=\"336\" data-end=\"354\">Q_ecs_RANDOM_min</code>&nbsp;—&nbsp;<strong data-start=\"357\" data-end=\"373\" data-is-only-node=\"\">minute-level</strong>&nbsp;stochastic draw (active showers × per-shower flow).</p></li><li data-start=\"428\" data-end=\"527\"><p data-start=\"430\" data-end=\"527\"><code data-start=\"430\" data-end=\"445\">Puissance_ECS</code>&nbsp;—&nbsp;<strong data-start=\"448\" data-end=\"479\" data-is-only-node=\"\">instantaneous thermal power</strong>&nbsp;to raise cold water to the useful DHW setpoint.</p></li></ul></li><li data-start=\"529\" data-end=\"746\"><p data-start=\"531\" data-end=\"746\"><strong data-start=\"531\" data-end=\"555\">Key inputs &amp; params:</strong>&nbsp;cold water temperature, number of dwellings/occupants, liters per person per day, shower duration/flow, bath/shower ratio, month/day calendars, COSTIC/RE2020 hourly and monthly coefficients.</p></li><li data-start=\"748\" data-end=\"1168\"><p data-start=\"750\" data-end=\"765\"><strong data-start=\"750\" data-end=\"765\">Core logic:</strong></p><ul data-start=\"768\" data-end=\"1168\"><li data-start=\"768\" data-end=\"893\"><p data-start=\"770\" data-end=\"893\">Computes&nbsp;<strong data-start=\"779\" data-end=\"796\">hourly demand</strong>&nbsp;by scaling normalized COSTIC/RE2020 hourly vectors with monthly factors and daily shower volume.</p></li><li data-start=\"896\" data-end=\"1079\"><p data-start=\"898\" data-end=\"1079\">Every hour, estimates the&nbsp;<strong data-start=\"924\" data-end=\"945\">number of showers</strong>, draws&nbsp;<strong data-start=\"953\" data-end=\"975\">random start times</strong>&nbsp;using&nbsp;<strong data-start=\"982\" data-end=\"998\">Xorshift128+</strong>, builds a 60-minute schedule of&nbsp;<strong data-start=\"1031\" data-end=\"1053\">concurrent showers</strong>, and derives minute-flow.</p></li><li data-start=\"1082\" data-end=\"1168\"><p data-start=\"1084\" data-end=\"1168\">Converts minute-flow to&nbsp;<strong data-start=\"1108\" data-end=\"1125\">thermal power.</strong></p></li></ul></li></div></body></html>"));
  end DHW_generator;


