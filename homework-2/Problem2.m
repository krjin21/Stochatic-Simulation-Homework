%% Initialization

clear;
clc;
sample_size=1000;
rng(1)

%% Plot the histogram of samples

prob=rand(1,sample_size);
val=zeros(1,sample_size);
for i=1:sample_size
    if prob(i)>=0.5
        val(i)=-log(2*(1-prob(i)))/2;
    else
        val(i)=log(2*prob(i))/2;
    end
end
histogram(val,100);
hold on;

%% Plot the density function of the distribution

x=-5:0.01:5;
f=zeros(1,length(x));
f(1:500)=exp(2*x(1:500));
f(501:1001)=exp(-2*x(501:1001));
f=f*0.07*sample_size;
plot(x,f,'linewidth',2)
hold off;


