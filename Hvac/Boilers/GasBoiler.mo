within Modelitek.Hvac.Boilers;

model GasBoiler

  parameter Modelitek.Hvac.Boilers.BoilerData.BoilerData cfg;

  Modelica.Blocks.Interfaces.RealInput Q_req "W" annotation(
    Placement(transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_out annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(transformation(origin = {-122, -78}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_out "W" annotation(
    Placement(transformation(origin = {120, 6}, extent = {{-20, -20}, {20, 20}}), 
    iconTransformation(origin = {120, 18}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_losses "W";
  Modelica.Blocks.Interfaces.RealOutput Q_rec "W";
  Modelica.Blocks.Interfaces.RealOutput eta;
  Modelica.Blocks.Interfaces.RealOutput W_aux "W";
  Modelica.Blocks.Interfaces.RealOutput P_th_nom_ch "W";
  Modelica.Blocks.Interfaces.RealOutput charge "-";
  
  Modelica.Blocks.Interfaces.RealOutput P_gas "W (PCI)";
  Modelica.Blocks.Interfaces.RealOutput P_in  "W (Total input power)";

  parameter Real PCSI = 1.11 "natural gaz, (GPL:1.09, FOD: 1.07)";

protected
  Real R_nom_ref;
  Real R_int_ref;
  Real Q_po_30;
  Real P_th_int_ch;
  
  Real R_nom_corr;
  Real R_int_corr;

  Real Q_loss_nom;
  Real Q_loss_int;

  Real Q_stab;
  Real DT;

  Real W_aux_nom;
  Real W_aux_int;
  Real W_veille;


algorithm
  // kW → W pour P_nom et P_int
  // 1013 / 1014
  R_nom_ref := (cfg.coeffs.c1 + cfg.coeffs.c2*log(cfg.P_nom)) / 100 / PCSI;
  R_int_ref := (cfg.coeffs.c3 - cfg.coeffs.c4*log(cfg.P_nom)) / 100 / PCSI; //erreur dans RE ?
//  R_int_ref := (cfg.coeffs.c3 - cfg.coeffs.c4*log(cfg.P_int)) / 100 / PCSI;

  // 1015  — Q_po_30 doit être en W
  Q_po_30 := 1000 * cfg.coeffs.c5 * (cfg.P_nom^cfg.coeffs.c6) * cfg.P_nom;

  // 1016 – 1018 (déjà en W)
  W_aux_nom := cfg.coeffs.c7 + cfg.coeffs.c8*(cfg.P_nom^cfg.coeffs.n);
  W_aux_int := cfg.coeffs.c9 + cfg.coeffs.c10*(cfg.P_int^cfg.coeffs.n);
  W_veille := cfg.W_veille_default;

  // 1019–1020 //%
  R_nom_corr := min((R_nom_ref + cfg.therm.alpha_nom *
                 (cfg.therm.T_ref_nom - T_out)), 0.990);
  
  R_int_corr := min((R_int_ref + cfg.therm.alpha_int *
                 (cfg.therm.T_ref_int - T_out)), 0.990);

  // 1021 — en W
  DT := max(T_out - T_amb, 0); // for numerical stabilisation
  Q_stab := Q_po_30 * (DT / 30)^1.25;
  if Q_stab < 0 then Q_stab := 0; end if;

  // P_nom et P_int sont en kW → convertir en W ici
  // 1041
  P_th_nom_ch := (cfg.P_nom * 1000) * R_nom_corr / R_nom_ref;

  // 1040
  Q_out := min(Q_req, P_th_nom_ch);

  if P_th_nom_ch > 0 then
    charge := Q_out / P_th_nom_ch;
  else
    charge := 0;
  end if;

  // 1027 / 1029 — tout en W
  P_th_int_ch := 1000 * (R_int_corr / R_int_ref) * cfg.P_int;
  Q_loss_int := (1/R_int_corr - 1) * P_th_int_ch;
  Q_loss_nom := (1/R_nom_corr - 1) * P_th_nom_ch;

  Q_losses := Q_loss_int + (Q_loss_nom - Q_loss_int)*charge + Q_stab;
  Q_rec := cfg.p_rec * Q_losses;

  eta := if Q_out + Q_losses > 0 then Q_out / (Q_out + Q_losses) else 0;
  
  // === Consommation gaz (PCI) ===
  if Q_out + Q_losses > 0 then
    P_gas := Q_out + Q_losses;   // PCI
  else
    P_gas := 0;
  end if;
  
  if charge <= 0 then
    W_aux := W_veille;
  elseif charge <= 0.3 then
    W_aux := W_aux_int;
  else
    W_aux := W_aux_nom;
  end if;
  
  P_in := P_gas + W_aux;

    annotation (Icon, Documentation(info = "<html><head></head><body><h4>GasBoiler model</h4>
<p>
This model represents a natural-gas boiler using a simplified performance-based approach derived from manufacturer data and empirical correlations. 
It computes the delivered heat output, thermal losses, gas consumption (PCI basis), auxiliary electricity use, and boiler efficiency under varying operating conditions.
</p>

<h4>Main functionalities</h4>
<ul>
  <li>Limits the boiler thermal output by the nominal corrected thermal power.</li>
  <li>Computes thermal losses as a function of corrected nominal and intermediate efficiencies.</li>
  <li>Includes standby losses through a stabilization term based on the temperature difference between outdoor air and boiler output.</li>
  <li>Determines auxiliary electrical power depending on boiler load (nominal, intermediate, or standby).</li>
  <li>Calculates gas input power (PCI) and total input power (gas + auxiliaries).</li>
</ul>

<h4>Inputs</h4>
<ul>
  <li><code>Q_req</code>: Requested heating power (W)</li>
  <li><code>T_out</code>: Boiler outlet temperature (°C)</li>
  <li><code>T_amb</code>: Ambient temperature (°C)</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>Q_out</code>: Delivered thermal power (W)</li>
  <li><code>Q_losses</code>: Total boiler thermal losses (W)</li>
  <li><code>Q_rec</code>: Recoverable part of heat losses (W)</li>
  <li><code>eta</code>: Instantaneous efficiency (-)</li>
  <li><code>W_aux</code>: Auxiliary electrical consumption (W)</li>
  <li><code>P_gas</code>: Gas input power (PCI basis, W)</li>
  <li><code>P_in</code>: Total input power (gas + auxiliary, W)</li>
  <li><code>charge</code>: Boiler load ratio (-)</li>
</ul>

<h4>Configuration</h4>
<p>
The model relies on a <code>BoilerData</code> structure containing coefficients, nominal and intermediate powers, thermal correction parameters, and standby electric consumption.
The correlations follow the reference performance equations implemented internally (coefficients <code>c1</code> to <code>c10</code>, <code>n</code>, <code>p_rec</code>, etc.).
</p>

<h4>Important Notes</h4>
<ul>
  <li><b>This model does not account for domestic hot water (DHW) production.</b> It only represents space heating performance.</li>
  <li>Gas consumption is expressed on a Lower Heating Value (LHV / PCI) basis.</li>
  <li>A correction factor <code>PCSI</code> adjusts for different fuels (natural gas, GPL, FOD).</li></ul>
</body></html>"));

end GasBoiler;
