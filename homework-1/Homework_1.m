clear all;
clc;
%% （b）
Simulation(true,false,1.8);

%% (c)

Simulation(true,true,1.8);
%% (d)

Lamdas=0.01:0.01:2;
rng(3);
AverSTs=zeros(1,length(Lamdas));
for i=1:length(Lamdas)
    AverSTs(i)=Simulation(false,true,Lamdas(i));
    disp(i)
end
plot(Lamdas,AverSTs);
hold on;
xlim([0,2.2]);


rng(3);
AverST2s=zeros(1,length(Lamdas));
for i=1:length(Lamdas)
    AverST2s(i)=Simulation(false,false,Lamdas(i));
    disp(i)
end
plot(Lamdas,AverST2s);
legend('Normal','Exponential');

function [AverageSojournTime]=Simulation(figure,normal,Lamda)
%% Parameter Setting

Mu1=1;
Mu2=2;
SimLength=10000;

%% Warm up

Arrivalwarmup=[];
time=0;
i=1;
while time<3000
    Arrivalwarmup(i)=-log(rand(1))/Lamda;
    time=time+Arrivalwarmup(i);
    i=i+1;
end

WarmUpNumber=length(Arrivalwarmup)-1;
TotalNumber=SimLength+WarmUpNumber;


%% Generate data of customer arrival and service time

ArrivalsInterval=[Arrivalwarmup(1:WarmUpNumber),-log(rand(1,SimLength))/Lamda];
Service1=-log(rand(1,TotalNumber))/Mu1;
if normal==true
    Service2=abs(normrnd(0.5,0.15,1,TotalNumber));
else
    Service2=-log(rand(1,TotalNumber))/Mu2;
end
%% Cauclute Waitting and Sojour time

Arrival1=zeros(1,TotalNumber);
Arrival2=zeros(1,TotalNumber);
for i=2:TotalNumber
    Arrival1(i)=Arrival1(i-1)+ArrivalsInterval(i-1);
end

SystemTime1=zeros(1,TotalNumber);
Waitting1=zeros(1,TotalNumber);
for i=1:TotalNumber
   A2order=sort(Arrival2,'descend');
   Waitting1(i)=max(A2order(2)-Arrival1(i),0);
   SystemTime1(i)=Waitting1(i)+Service1(i);
   Arrival2(i)=Arrival1(i)+SystemTime1(i);
end

order=[];
for i=1:TotalNumber
    order(i)=sum(Arrival2<=Arrival2(i));
end
index=[];
for i=1:TotalNumber
    index(i)=find(order==i);
end

Waitting2=zeros(1,TotalNumber);
SystemTime2=zeros(1,TotalNumber);
Leave=zeros(1,TotalNumber);
for i=1:TotalNumber
    Waitting2(index(i))=max(max(Leave)-Arrival2(index(i)),0);
    SystemTime2(index(i))=Waitting2(index(i))+Service2(index(i));
    Leave(index(i))=Arrival2(index(i))+SystemTime2(index(i));
end

AllSojournTime=Leave-Arrival1;
SojournTime=AllSojournTime(length(AllSojournTime)-(SimLength-1):length(AllSojournTime));
AverageSojournTime=mean(SojournTime);

%% Output the reslut

fprintf('Average sojourn time is %6.3f \n',mean(SojournTime));
if figure==true
    hist(SojournTime,50)
end
end

