clear;clc;
%rng(2)
%========================采样========================%
size=1000;              %设置样本大小
L=zeros(size,1);        %用于记录采样结果
for i=1:size            %进行采样
   L(i)=Sample();
end
IndL=(L>=10);           %计算目标变量

%======================估计概率======================%
p=mean(IndL);           %计算估计的概率
var=var(IndL);          %计算估计的标准差

%======================输出结果======================%
fprintf('计算方法:\t\tCrude Monte Carlo\n');
fprintf('采样总次数：\t\t%6.0f\n概率的期望：\t\t%6.3f\n概率的标准差：\t%6.3f\n',size,p,var);


function [L]=Sample()   %用于生成样本的函数
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
%============计算L的值===========%
X=(rho*Z0+sqrt(1-rho^2).*Z)./sqrt((chi)/d);
IndX=(X>=sigma);
L=sum(Li.*IndX);
end



