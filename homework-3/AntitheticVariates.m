clear;clc;
rng(10)
%========================采样========================%
size=1000;                  %设置样本大小
L1=zeros(size,1);           %用于记录目标变量 
L2=zeros(size,1);           %用于记录Antithetic变量
for i=1:size                %进行样本
    [L1(i),L2(i)]=Sample();
end
IndL1=single(L1>=10);             %计算目标变量
IndL2=single(L2<=-10);            %计算Antithetic变量
coef=corrcoef(IndL1,IndL2);       %计算相关系数

%======================估计概率======================%
Z=(IndL1+IndL2)./2;         %计算用于估计的变量
p=mean(Z);                  %计算估计的概率
var=var(Z);                 %计算估计的标准差

%======================输出结果======================%
fprintf('计算方法:\t\t\tAntithetic Variates\n');
fprintf('采样总次数:\t\t\t%6.0f\n',size);
fprintf('相关系数：\t\t\t%6.3f\n概率的期望：\t\t\t%6.3f\n概率的方差：\t\t\t%6.3f\n',coef(1,2),p,var);



 function [L1,L2]=Sample()  %用于生成样本的函数
%==========参数设置=============%
m=100;
Li=ones(m,1);
sigma=ones(m,1)*1.7;
d=5;
rho=0.5;
%============生成样本===========%
Z0=randn;
Z=zeros(m,1);
chi=chi2rnd(d);
for i=1:m
    Z(i)=randn;
end
%============计算L1和L2的值===========%
X=(rho*Z0+sqrt(1-rho^2).*Z)./sqrt((chi)/d);
IndX1=(X>=sigma);
IndX2=-(X<=-sigma);
L1=sum(Li.*IndX1);
L2=sum(Li.*IndX2);
 end