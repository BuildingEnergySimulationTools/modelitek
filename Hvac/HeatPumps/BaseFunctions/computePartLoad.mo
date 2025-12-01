within Modelitek.Hvac.HeatPumps.BaseFunctions;

function computePartLoad
  extends Modelica.Icons.Function;

  input Real P_fou;
  input Real LR "Load ratio P_fou / P_fou_pc";
  input Real LRcontmin;
  input Real COP_pc "COP_pc_combi.y";
  input Real P_fou_pc;
  input Real P_abs_pc "Pabs_combi.y";
  input Real P_comp_pc;
  input Real P_aux;
  input Real CcpLRcontmin;
  input Real Deq;
  input Real Dfou0;
  output Real P_comp "Compressor power at part load";
  output Real P_abs  "Total absorbed power at part load";
  output Real COP "Final COP at part load";

  protected Real LR_cycl;
  protected Real P_compma_low;
  protected Real COP_pc_net;
  protected Real COP_lr_net;
  
  protected Real P_fou_lrcontmin;
  protected Real COP_lr_contmin_net;
  protected Real P_abs_lrcontmin;
  protected Real P_comp_lrcontmin;  
  
algorithm
  
  COP_pc_net := P_fou_pc / (P_abs_pc - P_aux); // COP without auxiliaries
  
  if LR > LRcontmin and LR <= 1 then
    // High LR
    COP_lr_net := COP_pc_net*(1 + (CcpLRcontmin - 1)*(1-LR)/(1-LRcontmin));
    P_comp := P_fou / COP_lr_net;
    P_abs  := P_comp + P_aux;

  else
    // Low LR
    P_fou_lrcontmin := P_fou_pc * LRcontmin; // Given power at min continue LR
    COP_lr_contmin_net := COP_pc_net * CcpLRcontmin; // Penalty of COP @ min continue LR from COP_lr_net equation @ LR = LRcontmin
    P_comp_lrcontmin := P_fou_lrcontmin / COP_lr_contmin_net; // Compressor power at min continue LR
    P_comp := P_comp_lrcontmin * (1 - (LRcontmin - LR)/LRcontmin);
    LR_cycl := LR / LRcontmin;
    P_compma_low := P_comp_lrcontmin * (Deq*LR_cycl*(1-LR_cycl)) / Dfou0;
    P_abs := P_comp + P_compma_low + P_aux;
  end if;
  
  COP := P_fou / P_abs;

end computePartLoad;
