within Modelitek.Hvac.HeatPumps.PAC_air_eau;

model ControlePacOnOff

parameter Real Waux;
parameter Real dT_pince=5;
Real Debit_ECS_int;
Real Debit_Tampon_ch;
Real Debit_Tampon_clim;
Real P_ECS "Puissance fournie dans le cas de l'eau chaude sanitaire";
Real P_ch "Puissance fournie dans le cas de chauffage" ;
Real P_clim " Puissance fournie dans le cas de la climatisation";
Real P_comp_ECS ;
Real P_comp_ch;
Real P_comp_clim;
Real P_elec;
Real rho =1000;
Real Cp=4186;
Real indicateur;
  Modelica.Blocks.Interfaces.RealInput COP_ECS annotation(
    Placement(visible = true, transformation(origin = {-115, 73}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-107, 93}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput COP_ch annotation(
    Placement(visible = true, transformation(origin = {-116, 10}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-107, 43}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pabs_ECS annotation(
    Placement(visible = true, transformation(origin = {-116, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-107, 73}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pabs_ch annotation(
    Placement(visible = true, transformation(origin = {-116, -18}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-107, 21}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput EER annotation(
    Placement(visible = true, transformation(origin = {-116, -46}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-108, -18}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Pabs_EER annotation(
    Placement(visible = true, transformation(origin = {-115, -75}, extent = {{-15, -15}, {15, 15}}, rotation = 0), iconTransformation(origin = {-108, -42}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_ballon_ECS annotation(
    Placement(visible = true, transformation(origin = {118, 48}, extent = {{-18, -18}, {18, 18}}, rotation = 180), iconTransformation(origin = {108, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput T_ballon_Tampon annotation(
    Placement(visible = true, transformation(origin = {118, 12}, extent = {{-18, -18}, {18, 18}}, rotation = 180), iconTransformation(origin = {108, 4.44089e-16}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput T_vers_ballon_ECS annotation(
    Placement(visible = true, transformation(origin = {110, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_vers_ballon_Tampon annotation(
    Placement(visible = true, transformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Debit_ECS annotation(
    Placement(visible = true, transformation(origin = {110, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Debit_Tampon annotation(
    Placement(visible = true, transformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_fou annotation(
    Placement(visible = true, transformation(origin = {110, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput Mode_ch_clim annotation(
    Placement(visible = true, transformation(origin = {-44, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-20, 116}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput phi_rejet annotation(
    Placement(visible = true, transformation(origin = {-2, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
//Calcul de la puissance du compresseur
  P_comp_ECS = Pabs_ECS - Waux;
  P_comp_ch = Pabs_ch - Waux;
  P_comp_clim = Pabs_EER - Waux;
// Calcul de la puissance fournie dans chaque cas
  P_ECS = COP_ECS * P_comp_ECS;
  P_ch = COP_ch * P_comp_ch;
  P_clim = EER * P_comp_clim;
//Calcul du débit correspondant
  if T_ballon_ECS >= 60 then
    Debit_ECS_int = 0;
  else
    Debit_ECS_int = P_ECS / (rho * Cp * dT_pince);
  end if;
  if T_ballon_Tampon >= 45 then
    Debit_Tampon_ch = 0;
  else
    Debit_Tampon_ch = P_ch / (rho * Cp * dT_pince);
  end if;
  if T_ballon_Tampon <= 7 then
    Debit_Tampon_clim = 0;
  else
    Debit_Tampon_clim = abs(P_clim) / (rho * Cp * dT_pince);
  end if;
  if Mode_ch_clim == 1 then
    T_vers_ballon_Tampon = 45;
    T_vers_ballon_ECS = 60;
    if T_ballon_ECS >= 60 and T_ballon_Tampon < 44 then
      Debit_ECS = 0;
      Debit_Tampon = Debit_Tampon_ch * 3.6e+6;
      P_fou = P_ch;
      P_elec = P_comp_ch;
      indicateur = 1;
    elseif T_ballon_ECS >= 60 and T_ballon_Tampon >= 45 then
      Debit_ECS = 0;
      Debit_Tampon = 0;
      P_fou = 0;
      P_elec = 0;
      indicateur = 2;
    else
      indicateur = 3;
      Debit_ECS = Debit_ECS_int * 3.6e+6;
      Debit_Tampon = 0;
      P_fou = P_ECS;
      P_elec=P_comp_ECS;
    end if;
  else
    indicateur = 4;
    T_vers_ballon_Tampon = 7;
    T_vers_ballon_ECS = 60;
    if T_ballon_ECS >= 60 and T_ballon_Tampon > 7 then
      Debit_ECS = 0;
      Debit_Tampon = Debit_Tampon_clim * 3.6e+6;
      P_fou = P_clim;
      P_elec = P_comp_clim;
    elseif T_ballon_ECS >= 60 and T_ballon_Tampon <= 7 then
      Debit_ECS = 0;
      Debit_Tampon = 0;
      P_fou = 0;
      P_elec = 0;
    else
      Debit_ECS = Debit_ECS_int * 3.6e+6;
      Debit_Tampon = 0;
      P_fou = P_ECS;
      P_elec = P_comp_ECS;
    end if;
  end if;
  
  phi_rejet= -(P_fou-P_elec);
  annotation(
    Icon(graphics = {Rectangle(lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {26, 9}, lineThickness = 1, extent = {{-68, 57}, {68, -57}}), Rectangle(origin = {25, -67}, lineThickness = 1, extent = {{-11, 19}, {11, -19}}), Rectangle(origin = {25, -67}, lineThickness = 1, extent = {{-11, 19}, {11, -19}}), Rectangle(origin = {-74, 8}, lineThickness = 1, extent = {{-10, 4}, {10, -4}}), Rectangle(origin = {-74, -1}, lineThickness = 1, extent = {{-18, 51}, {18, -51}}), Rectangle(origin = {48, 52}, lineThickness = 1, extent = {{-26, 4}, {26, -4}}), Rectangle(origin = {48, 38}, lineThickness = 1, extent = {{-26, 4}, {26, -4}}), Rectangle(origin = {48, 22}, lineThickness = 1, extent = {{-26, 4}, {26, -4}}), Ellipse(origin = {-9, 53}, lineThickness = 0.75, extent = {{-3, 3}, {3, -3}}), Ellipse(origin = {-9, 37}, lineThickness = 0.75, extent = {{-3, 3}, {3, -3}}), Ellipse(origin = {-9, 21}, lineThickness = 0.75, extent = {{-3, 3}, {3, -3}}), Rectangle(origin = {63, -12}, fillColor = {3, 3, 255}, fillPattern = FillPattern.Solid, extent = {{-5, 20}, {5, -20}}), Rectangle(origin = {7, -12}, fillColor = {255, 35, 15}, fillPattern = FillPattern.Solid, extent = {{-5, 20}, {5, -20}}), Line(origin = {32.5, 6}, points = {{-20.5, 0}, {25.5, 0}, {19.5, 0}}), Line(origin = {34.2588, -29.6152}, points = {{-22.5, 0}, {23.5, 0}, {19.5, 0}}), Ellipse(origin = {35, -30}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-9, 8}, {9, -8}}), Polygon(origin = {28, 6}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{-2, 4}, {-2, -4}, {8, 0}, {8, 0}, {-2, 4}}), Polygon(origin = {38, 10}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, points = {{8, -8}, {-2, -4}, {8, 0}, {8, 0}, {8, -8}}), Line(origin = {54.2045, -16.2286}, points = {{-15.2428, -7.03549}, {-27.2428, -15.0355}, {-15.2428, -21.0355}, {-15.2428, -7.03549}})}),
  Documentation(info = "<html><head></head><body>Ce modèle permet le controle de la PAC On\Off notamment sur le calcul des températures et des débits en départ vers les ballons aval en prenant en compte son mode de fonctionnement en chuaffage ou en refroidissement.<div><br></div><div>Le mode de fonctionnement est une entrée booléenne du modèle qui indiquera si on est en saison de chauffage ou en siason de refroidissement.&nbsp;</div><div><br></div><div><b><u><font size=\"4\">Paramètres</font></u></b></div><div><b><u><font size=\"4\"><br></font></u></b></div><div><ul><li>Waux : Puissance des auxilières.</li></ul></div></body></html>"));
end ControlePacOnOff;
