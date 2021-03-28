function ExponentialModel()
S0=100;
I0=5;

R0 = 2.5;
tmax = 4;
t = (0:1/8:tmax);


%These are the data streams ( arrays of outputs)
I = I0*(R0).^t;
S = S0 - I0*(R0).^t;


%Adding Gaussian distributed noise where the mean (mu) is 0 and the stdev is 1

mu=0;
sigma=1;
noise = sigma *randn(1,length(t))+mu;

noiseyS =  noise + S;
noiseyI = noise + I;


expForm = fittype('a-b*exp(r*x)');
expFit = fit(t',noiseyI', expForm, 'StartPoint',[1,1,1]);

coeffs = coeffvalues(expFit);
r = coeffs(3);


plot(t, [I;noiseyI], t, expFit(t));
axis([0 tmax 0 100]);
title('Exponential Model');
legend('I(t)', 'I(t) with noise','Exponential fit of I');
xlabel('Time, t');
ylabel('Population');

%plot(t, [I;noiseyI; S;noiseyS]);    How to plot with original and noise

% plot(t, [I;noiseyI; S;noiseyS]);
% axis([0 tmax 0 100])
% title('Exponential Model');
% legend('I(t)', 'I(t) with noise','S(t','S(t)with noise');
% xlabel('Time, t');
% ylabel('Population');



