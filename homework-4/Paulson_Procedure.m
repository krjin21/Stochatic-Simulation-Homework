clear; clc

%% 实验
t0=tic;
size=100;
Selections=zeros(1,size);
sampleSize=zeros(1,size);
for i=1:size
    fprintf('第%3.0f次实验\n',i);
    [Selections(i),sampleSize(i)]=Paulson(100,0.05) ;
end
tC=toc(t0);
fprintf('计算方法:\t\tPaulson Method\n');
fprintf('正确率（PCS）：\t\t%6.3f\n',sum(Selections==10)/size);
fprintf('采样总次数:\t\t\t%6.0f\n',mean(sampleSize));


%% Paulson方法
function [I,r]=Paulson(n0,alpha)
    %===========参数设置============%
    %n0=100;
    %alpha=0.05;
    b=2;                        %bachsize的大小
    delta=0.1;                  %无差异区间
    lambda=delta/2;            %lambda参数

    %===========初始化============%
    I=[1,2,3,4,5,6,7,8,9,10];               %初始化的alternative
    k=length(I);                            %alternative数量
    initialSample=Sample(I,round(n0/b),b);  %初始化的采样
    if n0/b==1                              %计算均值
        Means=initialSample;
    else
        Means=mean(initialSample);
    end
        
    S=zeros(k,k);                           %用于储存alternative的差的方差
    for i=1:k                               %逐个计算方差矩阵
       for j=1:k
           tmp=initialSample(:,i)-initialSample(:,j);
           tmp=tmp-(Means(i)-Means(j));
           S(i,j)=sum(tmp.^2)/(n0/b-1);
       end
    end
    r=n0;                                   %初始的r等于n0
    SampleData=Means;                       %初始化的第一次采样
    %==========Screening==========%
    while length(I)>1
        Means=Means+(SampleData-Means)/r;   %更新均值
        A=max(0,((log((k-1)/alpha)/(delta-lambda)).*S)/r-lambda);   %更新A矩阵
        out=[];                             %用于记录筛选出去的alternatives
        j=1;                                %用于记录筛选出去的个数
        for i=1:length(I)                   %逐个判断是否筛出
            tmp=(-Means+Means(i))'+A(:,i);
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
            A(:,out)=[];
            S(:,out)=[];
            A(out,:)=[];
            S(out,:)=[];
            SampleData=Sample(I,1,b);       %再次采样
            r=r+b;                          %更新采样次数
        end
    end
    r=r-b;      %最后多采样了b次，因此减去b
end

%% 抽样函数
function samples=Sample(req,samplesize,b)
    %req是需要采样的alternatives
    %samplesize是每个alternative的样本数量
    %b是batchsize的大小
    mu=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];   %alternative的期望
    sigma=[1,2,3,4,5,6,7,8,9,10];                   %alternative的方差
    sigma=sqrt(sigma);                              %计算标准差
    samples=zeros(samplesize,length(req));          %用于储存样本
    for j=1:length(req)
        index=req(j);
        if b>1
            samples(:,j)=mean(normrnd(mu(index),sigma(index),[b,samplesize]))'; %进行采样
        else
            samples(:,j)=normrnd(mu(index),sigma(index),[1,samplesize])';
        end
    end
end

