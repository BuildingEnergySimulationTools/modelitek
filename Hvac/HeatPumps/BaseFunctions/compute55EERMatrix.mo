within Modelitek.Hvac.HeatPumps.BaseFunctions;

function compute55EERMatrix
  extends Modelica.Icons.Function;
  input Real Pivot;
  input Real Temp_aval[5];
  input Real Temp_amont[5];
  input Real Cnnav[:];
  input Real Cnnam[:];
  input Real userData[5, 5];
  output Real M_combi2d[6, 6];
protected
  parameter Real first_row[6] = cat(1, {0}, Temp_amont);
  parameter Real first_col[6] = cat(1, {0}, Temp_aval);
  parameter Real M[5, 5];
algorithm
// Initialize with user data
  M := userData;
  
// Insert pivot if missing
  if M[2, 4] == 0 then M[2, 4] := Pivot; end if;
  
// Fill pivot column, index 4 = pivot column
  if M[1, 4] == 0 then M[1, 4] := M[2, 4]*Cnnav[4]; end if;
  if M[3, 4] == 0 then M[3, 4] := M[2, 4]*Cnnav[2]; end if;
  if M[4, 4] == 0 then M[4, 4] := M[2, 4]*Cnnav[1]; end if;
  if M[5, 4] == 0 then M[5, 4] := M[2, 4]*Cnnav[3]; end if;
  
// 3. Fill rows based on M[i,4]
  for i in 1:5 loop
    if M[i, 2] == 0 then M[i, 2] := M[i, 4]*Cnnam[2]; end if;
    if M[i, 3] == 0 then M[i, 3] := M[i, 4]*Cnnam[1]; end if;
    if M[i, 5] == 0 then M[i, 5] := M[i, 4]*Cnnam[4]; end if;
    if M[i, 1] == 0 then M[i, 1] := M[i, 4]*Cnnam[3]; end if;
  end for;
  
// Add row and column for combitimetable
  M_combi2d[1, :] := first_row;
  M_combi2d[:, 1] := first_col;
  M_combi2d[2:6, 2:6] := M;
  
end compute55EERMatrix;
