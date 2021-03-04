function ExponentialModel()
S0=100;
I0=5;

R0 = 2.5;
tmax = 4;
t = 0:1/8:tmax;


%These are the data streams ( arrays of outputs)
I = I0*(R0).^t;
S = S0 - I0*(R0).^t;

% Plot

plot(t, [I; S]);
axis([0 tmax 0 100])
title('Exponential Model');
legend('I(t)','S(t)');
xlabel('Time, t');
ylabel('Population');
