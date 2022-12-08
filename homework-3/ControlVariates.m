clear;clc
rng(3)
%========================采样========================%
size=1000;                      %设置样本大小
L=zeros(size,1);                %用于记录目标变量
X=zeros(size,1);                %用于记录Control
for i=1:size                    %进行采样
    [L(i),X(i)]=Sample();
end
IndL=(L>=10);                   %计算目标变量

%======================估计概率======================%
devL=IndL-mean(IndL);           %计算目标变量的偏差
devX=X-mean(X);                 %计算Control的片擦
b=sum(devL.*devX)/sum(devX.*devX);  %计算最优的系数
BarIndL=IndL-b.*(X);               %计算用于估计的变量
p=mean(BarIndL);                   %计算估计的概率
c=corrcoef(IndL,X);
vars=var(IndL)*(1-(c(1,2))^2);                 %计算估计的标准差


%======================输出结果======================%
fprintf('计算方法:\t\t\tControl Variates\n');
fprintf('采样总次数:\t\t\t%6.0f\n',size);
fprintf('系数b的取值：\t\t%6.3f\n概率的期望：\t\t\t%6.3f\n概率的方差：\t\t\t%6.3f\n',b,p,vars);




function [L,MeanX]=Sample()     %用于生成样本的函数
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
MeanX=mean(X);
end