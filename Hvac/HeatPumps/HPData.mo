within Modelitek.Hvac.HeatPumps;

package HPData
extends Modelica.Icons.RecordsPackage;

record BaseHPData
    extends Modelica.Icons.Record;
    parameter Real COP_pivot;
    parameter Real Pabs_pivot_cop;
    parameter Real userData_cop[5, 5]; // zeros = missing
    parameter Real userData_pabs_cop[5, 5]; // zeros = missing
    parameter Real Cnnav_cop[4];
    parameter Real Cnnam_cop[4];
    parameter Real Cnnav_pabs_cop[4];
    parameter Real Cnnam_pabs_cop[4];
    parameter Real t_amont_rec_cop[5];
    parameter Real t_aval_rec_cop[5];
    parameter Real eer_pivot;
    parameter Real Pabs_pivot_eer;
    parameter Real userData_eer[5, 5];
    parameter Real userData_pabs_eer[5, 5];
    parameter Real Cnnav_eer[4];
    parameter Real Cnnam_eer[4];
    parameter Real Cnnav_pabs_eer[4];
    parameter Real Cnnam_pabs_eer[4];
    parameter Real t_amont_rec_eer[5];
    parameter Real t_aval_rec_eer[5];
    parameter Real Taux;
    parameter Real Deq; // Convention says it must be 0.5 min
    parameter Real Dfou0;
    parameter Real LRcontmin; //Taux minimal de charge en fonctionnement continu. (= 1 si machine tout ou rien)
    parameter Real CcpLRcontmin;     //Coefficient de correction de la performance pour un taux de charge égal à LRcontmin
  end BaseHPData;

  record AirWater_inf100kW extends BaseHPData(
      COP_pivot = 2.81,
      Pabs_pivot_cop = 3.5587,
      userData_cop = zeros(5,5),
      userData_pabs_cop = zeros(5,5),
  
      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.5, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs_cop = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs_cop = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec_cop = {-15., -7., 2., 7., 20.},
      t_aval_rec_cop  = {23.5, 32.5, 42.5, 51., 60.},
      
      eer_pivot = 2.7,
      Pabs_pivot_eer = 3.7037,
      userData_eer = zeros(5,5),
      userData_pabs_eer = zeros(5,5),
      
      Cnnav_eer = {1.15, 1.075, 1.225, 0.9},
      Cnnam_eer = {1.2, 1.4, 1.6, 0.8},
      Cnnav_pabs_eer = {1.11, 1.055, 1.165, 0.945},
      Cnnam_pabs_eer = {1.1, 1.2, 1.3, 0.9},
      
      t_amont_rec_eer = {5., 15., 25., 35., 45.},
      t_aval_rec_eer = {4., 9.5, 15., 20.5, 26},
      
      Taux = 0.02,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0
    );
  end AirWater_inf100kW;
  
  record AirWater_sup100kW extends BaseHPData(
      COP_pivot = 2.81,
      Pabs_pivot_cop = 35587,
      userData_cop = zeros(5,5),
      userData_pabs_cop = zeros(5,5),

      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.6, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs_cop = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs_cop = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec_cop = {-15., -7., 2., 7., 20.},
      t_aval_rec_cop  = {23.5, 32.5, 42.5, 51., 60.},
      
      eer_pivot = 2.7,
      Pabs_pivot_eer = 37037,
      userData_eer = zeros(5,5),
      userData_pabs_eer = zeros(5,5),
      
      Cnnav_eer = {1.15, 1.075, 1.225, 0.9},
      Cnnam_eer = {1.2, 1.4, 1.6, 0.8},
      Cnnav_pabs_eer = {1.11, 1.055, 1.165, 0.945},
      Cnnam_pabs_eer = {1.1, 1.2, 1.3, 0.9},
      
      t_amont_rec_eer = {5., 15., 25., 35., 45.},
      t_aval_rec_eer = {4., 9.5, 15., 20.5, 26},
      
      Taux = 0.02,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0
    );
    
  end AirWater_sup100kW;
  
    record AirWater_AquaSnap140P extends BaseHPData(
      COP_pivot = 4.08,
      Pabs_pivot_cop = 28186,
      userData_cop =     
    [0,0,0,0,0;
     0,0,0,4.08,0;
     0,0,0,3.38,0;
     0,0,0,2.94,0;
     0,0,0,2.51,0],
      userData_pabs_cop =     
    [0,0,0,0,0;
     0,0,0,28186,0;
     0,0,0,34023,0;
     0,0,0,39115,0;
     0,0,0,45816,0],

      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.6, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs_cop = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs_cop = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec_cop = {-15., -7., 2., 7., 20.},
      t_aval_rec_cop  = {23.5, 32.5, 42.5, 51., 60.},
      
      eer_pivot = 2.34,
      Pabs_pivot_eer = 44871,
      userData_eer =     
    [0,0,0,0,0;
     0,0,0,2.34,0;
     0,0,0,0,0;
     0,0,0,3.36,0;
     0,0,0,0,0],
      userData_pabs_eer =     
    [0,0,0,0,0;
     0,0,0,44871,0;
     0,0,0,0,0;
     0,0,0,31250,0;
     0,0,0,0,0],
      
      Cnnav_eer = {1.15, 1.075, 1.225, 0.9},
      Cnnam_eer = {1.2, 1.4, 1.6, 0.8},
      Cnnav_pabs_eer = {1.11, 1.055, 1.165, 0.945},
      Cnnam_pabs_eer = {1.1, 1.2, 1.3, 0.9},
      
      t_amont_rec_eer = {5., 15., 25., 35., 45.},
      t_aval_rec_eer = {4., 9.5, 15., 20.5, 26},
      
      Taux = 0.02,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0
    );
    
  end AirWater_AquaSnap140P;
  
    record AirWater_AquaSnap40P extends BaseHPData(
      COP_pivot = 3.97,
      Pabs_pivot_cop = 9570,
      userData_cop =     
    [0,0,0,0,0;
     0,0,0,3.97,0;
     0,0,0,3.31,0;
     0,0,0,2.88,0;
     0,0,0,0,0],
      userData_pabs_cop =     
    [0,0,0,0,0;
     0,0,0,9570,0;
     0,0,0,11480,0;
     0,0,0,13190,0;
     0,0,0,0,0],

      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.6, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs_cop = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs_cop = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec_cop = {-15., -7., 2., 7., 20.},
      t_aval_rec_cop  = {23.5, 32.5, 42.5, 51., 60.},
      
      eer_pivot = 2.47,
      Pabs_pivot_eer = 12960,
      userData_eer =     
    [0,0,0,0,0;
     0,0,0,2.47,0;
     0,0,0,0,0;
     0,0,0,3.75,0;
     0,0,0,0,0],
      userData_pabs_eer =     
    [0,0,0,0,0;
     0,0,0,12960,0;
     0,0,0,0,0;
     0,0,0,8530,0;
     0,0,0,0,0],
      
      Cnnav_eer = {1.15, 1.075, 1.225, 0.9},
      Cnnam_eer = {1.2, 1.4, 1.6, 0.8},
      Cnnav_pabs_eer = {1.11, 1.055, 1.165, 0.945},
      Cnnam_pabs_eer = {1.1, 1.2, 1.3, 0.9},
      
      t_amont_rec_eer = {5., 15., 25., 35., 45.},
      t_aval_rec_eer = {4., 9.5, 15., 20.5, 26},
      
      Taux = 0.0063,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0
    );
    
  end AirWater_AquaSnap40P;
  
end HPData;
