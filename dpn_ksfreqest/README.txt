DOCUMENTATION

== SOURCE CODE

# dnf_arkal.m
This is the implementation of the Kalman Smoother for AR(2) Process.  The output is the time varying AR coefficients and residuals.

# dnf_arkal_coef2freq.m
Converts AR coefficients into pole magnitude and pole phase.

# dnf_arkal_coef2poleinfo.m
Converts AR coefficients into pole magnitude and oscillation frequency.

# dnf_arkal_instfreq.m
Takes the code from dnf_arkal.m and embeds code for directly returning the instantantaneous frequency estimate.

# dnf_arkal_poleangle.m
From the time-varying AR coefficients, compute the pole angle.

# dnf_arkal_specgram.m
Frame the time-varying AR coefficients, compute time-varying SPECGRAM



