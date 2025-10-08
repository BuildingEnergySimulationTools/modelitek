within Modelitek.Controls.BaseClasses;

block Max "Calculate max over period T"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Modelica.Units.SI.Time T(start = 1) "Period";
  parameter Real x0 = 0 "Start value of integrator state";
  parameter Boolean yGreaterOrEqualZero = false "= true, if output y is guaranteed to be >= 0 for the exact solution" annotation(
    Evaluate = true,
    Dialog(tab = "Advanced"));
protected
  parameter Modelica.Units.SI.Time t0(fixed = false) "Start time of simulation";
  Real x "Integrator state";
  Real max_u "Integrator state";
  Real max_last "Last sampled max value";
initial equation
  t0 = time;
  x = x0;
  max_last = 0;
equation
  der(x) = if time >= t0 + T then 0 else x;
  when sample(t0 - T, T) then
    max_u = u;
    max_last = if not yGreaterOrEqualZero then ceil(max_u) else max(0.0, ceil(max_u));
    reinit(x, x0);
  end when;
  y = max_last;
  annotation(
    Documentation(info = "<html>
<p>
This block calculates the maximum value of the input signal u over the given period T:
</p>
<blockquote><pre>
max(T, 0, u(t))
</pre></blockquote>
<p>
Note: The output is updated after each period defined by T.
</p>

<p>
If parameter <strong>yGreaterOrEqualZero</strong> in the Advanced tab is <strong>true</strong> (default = <strong>false</strong>),
then the modeller provides the information that the maximum value of the input signal is guaranteed
to be &ge; 0 for the exact solution. However, due to inaccuracies in the numerical integration scheme,
the output might be slightly negative. If this parameter is set to true, then the output is
explicitly set to 0.0, if the maximum value results in a negative value.
</p>
</html>"),
    Icon(graphics = {Text(extent = {{-80, 60}, {80, 20}}, textString = "max"), Text(extent = {{-80, -20}, {80, -60}}, textString = "T=%T")}));
end Max;
