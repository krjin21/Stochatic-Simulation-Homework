clear;clc

%% 实验
t0=tic;
size=100;
Selections=zeros(1,size);
sampleSize=zeros(1,size);
for i=1:size
    fprintf('第%3.0f次实验\n',i);
    [Selections(i),sampleSize(i)]=KNProcedure(100,0.05) ;
end
tC=toc(t0);

fprintf('计算方法:\t\tKN Method\n');
fprintf('正确率（PCS）：\t\t%6.3f\n',sum(Selections==10)/size);
fprintf('采样总次数:\t\t\t%6.0f\n',mean(sampleSize));

%% KN方法
function [I,r]=KNProcedure(n0,alpha)
    %==========参数设置==========%
    %n0=500;                    %初始采样次数
    %alpha=0.05;                %精度要求
    c=1;
    %==========初始化==========%
    I=[1,2,3,4,5,6,7,8,9,10];   %初始时I为全集
    delta=0.1;                  %无差异区间
    k=length(I);                %alternative数量
    eta=0.5*((2*alpha/(k-1))^(-2/(n0-1))-1);            %eta参数
    h2=2*c*eta*(n0-1);            %h参数
    initialSample=Sample([1,2,3,4,5,6,7,8,9,10],n0);    %进行初始采样
    Means=mean(initialSample);  %计算初始均值
    S=zeros(k,k);               %用于储存alternative的差的方差
    for i=1:k                   %逐个计算S矩阵
       for j=1:k
           tmp=initialSample(:,i)-initialSample(:,j);
           tmp=tmp-(Means(i)-Means(j));
           S(i,j)=sum(tmp.^2)/(n0-1);
       end
    end
    N=floor((h2*S)/(delta^2));
    if n0>max(max(N))
        I=find(Means==max(Means));
    end
    r=n0;                     %r为实时采样次数
    SampleData=Means;         %初始化的第一次采样

    %==========Screening==========%
    while length(I)>1
        Means=Means+(SampleData-Means)/r;   %更新均值
        W=max(0,(delta/(2*c*r))*((h2*S)/(delta^2)-r));    %更新W矩阵
        out=[];                             %用于记录筛选出去的alternatives
        j=1;                                %用于记录筛选出去的个数
        for i=1:length(I)                   %逐个判断是否筛出
            tmp=(-Means+Means(i))'+W(:,i);
            if sum(tmp>=0)<length(I)
               out(j)=i; 
               j=j+1;
            end
        end
        if length(out)==length(I)           %如果I中全部元素都要筛出，则选择均值最大的留下
            I=I(find(Means==max(Means)));
        else                                %否则筛出对应的元素
            I(out)=[];
            Means(out)=[];
            W(:,out)=[];
            S(:,out)=[];
            W(out,:)=[];
            S(out,:)=[];
            SampleData=Sample(I,1);         %再次采样
            r=r+1;
        end
    end
    r=r-1;   %最后多采样了一次，因此减去1
end

%% 抽样函数
function samples=Sample(req,samplesize)
    %req是需要采样的alternatives
    %samplesize是每个alternative的样本数量
    mu=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];   %alternative的期望
    sigma=[1,2,3,4,5,6,7,8,9,10];                   %alternative的方差
    sigma=sqrt(sigma);                              %计算标准差
    samples=zeros(samplesize,length(req));          %用于储存样本
    for j=1:length(req)
        index=req(j);
        samples(:,j)=normrnd(mu(index),sigma(index),[1,samplesize])'; %进行采样
    end
end

