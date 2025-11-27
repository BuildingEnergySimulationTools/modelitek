within Modelitek.Hvac.HeatPumps.PAC_air_eau;

function computePartLoad
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

  // Compute calibration term
  protected Real CCP_lr_contmin_net;
  protected Real P_fou_lrcontmin;
  protected Real P_comp_lrcontmin;
  protected Real LR_cycl;
  protected Real P_compma_low;
  protected Real COP_lr_net;
  protected Real COP_lr_contmin_net;
  
  
algorithm
  CCP_lr_contmin_net :=
      LRcontmin * P_comp_pc * CcpLRcontmin /
      (LRcontmin*P_abs_pc - CcpLRcontmin*P_aux);


  if LR > LRcontmin and LR <= 1 then
    // High LR branch
    COP_lr_net := COP_pc*(1 + (CcpLRcontmin - 1)*(1-LR)/(1-LRcontmin));
    P_comp := P_fou / COP_lr_net;
    P_abs  := P_comp + P_aux;

  else
    // Low LR branch
    P_fou_lrcontmin := P_fou_pc * LRcontmin;
    COP_lr_contmin_net := COP_pc * CcpLRcontmin;

    P_comp_lrcontmin := P_fou_lrcontmin / COP_lr_contmin_net;

    P_comp := P_comp_lrcontmin * (1 - (LRcontmin - LR)/LRcontmin);

    LR_cycl := LR / LRcontmin;
    P_compma_low := P_comp_lrcontmin * (Deq*LR_cycl*(1-LR_cycl)) / Dfou0;

    P_abs := P_comp + P_compma_low + P_aux;
  end if;
  
  COP := P_fou / P_abs;

end computePartLoad;
