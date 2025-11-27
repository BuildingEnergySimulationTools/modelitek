within Modelitek.Hvac.HeatPumps;

package HPData
extends Modelica.Icons.RecordsPackage;

record BaseHPData
    extends Modelica.Icons.Record;
    parameter Real COP_pivot;
    parameter Real Pabs_pivot;
    parameter Real userData_cop[5, 5]; // zeros = missing
    parameter Real userData_pabs[5, 5]; // zeros = missing
    parameter Real Taux;
    parameter Real Deq; // Convention says it must be 0.5 min
    parameter Real Dfou0;
    parameter Real LRcontmin; //Taux minimal de charge en fonctionnement continu. (= 1 si machine tout ou rien)
    parameter Real CcpLRcontmin; //Coefficient de correction de la performance pour un taux de charge égal à LRcontmin
    parameter Real Cnnav_cop[4];
    parameter Real Cnnam_cop[4];
    parameter Real Cnnav_pabs[4];
    parameter Real Cnnam_pabs[4];
    parameter Real t_amont_rec[5];
    parameter Real t_aval_rec[5];
  end BaseHPData;

  record AirWater_inf100kW extends BaseHPData(
      COP_pivot = 2.81,
      Pabs_pivot = 1000,
      userData_cop = zeros(5,5),
      userData_pabs = zeros(5,5),
      Taux = 0.02,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0,
  
      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.5, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec = {-15., -7., 2., 7., 20.},
      t_aval_rec  = {23.5, 32.5, 42.5, 51., 60.}
    );
  end AirWater_inf100kW;
  
  record AirWater_sup100kW extends BaseHPData(
      COP_pivot = 2.81,
      Pabs_pivot = 100000,
      userData_cop = zeros(5,5),
      userData_pabs = zeros(5,5),
      Taux = 0.02,
      Deq = 0.5,
      Dfou0 = 12,
      LRcontmin = 0.4,
      CcpLRcontmin = 1.0,
  
      Cnnav_cop = {0.8, 0.8, 1.1, 0.8}, // Stupid order is 1: 42.5-32.5, 2: 51-42.5, 3: 23.5-32.5, 4: 60-51
      Cnnam_cop = {0.6, 0.8, 1.25, 0.8}, // Stupid order is 1: -7-7, 2: 2-7, 3: 20-7, 4: -15--7
      Cnnav_pabs = {0.9, 0.915, 1.09, 0.91},
      Cnnam_pabs = {0.86, 0.95, 1.13, 0.92},
  
      t_amont_rec = {-15., -7., 2., 7., 20.},
      t_aval_rec  = {23.5, 32.5, 42.5, 51., 60.}
    );
  end AirWater_sup100kW;
end HPData;
