clear;clc
rng(2)

%========================采样========================%
interval=-5:0.1:5;              %生成Strata
size=1000;                      %设置总样本大小
p=0;                            %通过累加每个Strata内的期望来计算概率   
weights=zeros(length(interval),1);
expected=zeros(length(interval),1);
vars=zeros(length(interval),1);
subsize=zeros(length(interval),1);
for i=1:(length(interval)-1)    %计算每个Strata的期望，每个Strata的样本数量取决于其概率
    [weights(i),expected(i),vars(i),subsize(i)]=Expected(interval(i),interval(i+1),size);
end
%======================估计概率======================%
p=sum(weights.*expected);
var=sum((weights).*vars);

%===========================输出结果===========================%
fprintf('计算方法:\t\t\tStratified Sampling\n');
fprintf('采样总次数：\t\t\t%6.0f\n概率的期望：\t\t\t%6.3f\n概率的方差：\t\t\t%6.3f\n',size,p,var);




function [weight,expected,vars,subsize]=Expected(lower,upper,size)  %用于计算Strata期望的函数
weight=normcdf(upper)-normcdf(lower);   %计算该Strata的概率
subsize=round(weight*size);             %根据概率设置样本大小
if subsize>0                %若子样本容量非零则采样
    L=zeros(subsize,1);
    for i=1:subsize         %进行采样
        Z0=rand*(upper-lower)+lower;
        L(i)=Sample(Z0);
    end
else                        %否则不采样
    L=0;
end
IndL=(L>=10);               %计算目标变量
expected=mean(IndL); %计算Strata的期望
vars=var(IndL);
end
function [L]=Sample(Z0)         %用于生成样本的函数
%==========参数设置=============%
m=100;
Li=ones(m,1);
sigma=ones(m,1)*1.7;
d=5;
rho=0.5;
%============生成样本===========%
%Z0=randn;
Z=zeros(m,1);
chi=chi2rnd(d);
for i=1:m
    Z(i)=randn;
end
%============计算L的值===========%
X=(rho*Z0+sqrt(1-rho^2).*Z)./sqrt((chi)/d);
MeanX=mean(X);
Ind=(X>=sigma);
L=sum(Li.*Ind);
end