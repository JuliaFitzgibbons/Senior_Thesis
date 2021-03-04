function SIRModel()
%Initial Conditions and time span
global beta gamma

S0=100;
I0=5;
R0=0;
tmax = 30;
beta = 0.01;
gamma = 0.03;


[t,y] = ode45('systemofKM',[0 tmax],[S0; I0; R0]);


%Figure details
plot(t, y);
title('SIR Model');
legend('S(t)','I(t)','R(t)');
xlabel('time, t');
ylabel('Population');
