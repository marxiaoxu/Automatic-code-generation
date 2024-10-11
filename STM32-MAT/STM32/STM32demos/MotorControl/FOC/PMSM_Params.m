Params.p = (2);      %Nb of pairs of poles
Params.L = (1.4e-3); %Phase inductance
Params.R = (0.6);    %Phase resistance
Params.J = (1.1e-5); %Rotor Inertia
Params.Lambda = (0.034182*1.0/Params.p);
Params.F = (1e-4);
Params.k = (0.05);
Params.h = (1/10000);
Params.T = (1/20000);
Params.V = (24);
Params.Encoder_Gain = (2*pi/800); %400pulses/rotation on Timer Ti1 and Ti2
Params.Theta_Zero = (30*pi/180); %Theta zero is pi/6 for 4 poles  2poles = pi/3 
Params.wmax = (2500/60*2*pi); %2500 rotation/mn max = 2500*2*pi rad/mn /60 = rad/s
Params.Imax = 4; % Params.V/Params.R; <- source is limited to 1A
save('Parameters','Params')