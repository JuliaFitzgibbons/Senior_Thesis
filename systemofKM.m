function [odefunct] = systemofKM (t , y)
global beta gamma
odefunct = zeros (3 ,1) ;
% Susceptible
odefunct(1,1) = -(beta*y(1)*y(2));
%Infectious
odefunct(2,1) = y(2)*(beta*y(1)-gamma);
%Recovered
odefunct(3,1) = gamma * y(2);

