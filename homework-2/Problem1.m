%% Initialization
clear;
clc;

Theta_1=3.5;
Theta_2=2.5;
sample_size = 1000000000;
confidence=0.95;
rng(122)

%% Simulation
Failtimes=zeros(1,sample_size);
for i=1:sample_size
    Failtimes(i)=Simulation(Theta_1,Theta_2);
end
Expected_Failtime = mean(Failtimes);
ExpectUB = mean(Failtimes)-((std(Failtimes)*icdf('t',(1-confidence)/2,sample_size))/sqrt(sample_size));
ExpectLB = mean(Failtimes)-((std(Failtimes)*icdf('t',1-(1-confidence)/2,sample_size))/sqrt(sample_size));
fprintf('Expected Time of Failure: %6.3f \nConfidence Interval:[ %6.3f , %6.3f ]\n',Expected_Failtime,ExpectLB,ExpectUB);

Prob_Fail_in_Five=mean(Failtimes<=5);
ProbUB = mean(Failtimes<=5)-((std(Failtimes<=5)*icdf('t',(1-confidence)/2,sample_size))/sqrt(sample_size));
ProbLB = mean(Failtimes<=5)-((std(Failtimes<=5)*icdf('t',1-(1-confidence)/2,sample_size))/sqrt(sample_size));
fprintf('\nExpected Probability of Failure in Five Days: %6.3f \nConfidence Interval:[ %6.3f , %6.3f ]\n',Prob_Fail_in_Five,ProbLB,ProbUB);

%% Simulation Function

function [Clock]=Simulation(Theta_1,Theta_2)
State=2; % simulation clock
Clock=0; % current time
Tlast=0; % time of last event
Area=0; % area under the state curve
NextFailure = -log(rand)*Theta_1; % time of next failure event
NextRepair = 1e10; % time of next repair event
while State>0
    if NextFailure < NextRepair
        NextEvent = 1; % 1 represents failure
        Clock = NextFailure;
        NextFailure = 1e10;
    else
        NextEvent = 2; % 2 represents repair
        Clock = NextRepair;
        NextRepair = 1e10;
    end
    Area = Area + (Clock - Tlast)*State;
    Tlast = Clock;
    if NextEvent == 1           % failure event
        State = State - 1;
        if State == 1
        NextFailure = Clock-log(rand)*Theta_1;
        NextRepair = Clock-log(rand)*Theta_2;
        end
    else                        % repair event
        State = State + 1;
        if State == 1
        NextFailure = Clock-log(rand)*Theta_1;
        NextRepair = Clock-log(rand)*Theta_2;
        end
    end
end
end