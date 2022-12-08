%% Initialization

clear;
clc;
min=0;
max=5;
mode=3;
% Parameter Setting of auxiliary distribution
mu=(min+max)/2;
sigma=1.9;
constant=2;
sample_size=1000;
rng(1)

%% Plot density functions of the two distributions for checking the assumption.
high=2/(max-min);
subplot(1,2,1)
x=[min,mode,max];
f=[0,high,0];
plot(x,f)
hold on;

x=min:0.01:max;
y=constant*normpdf(x,mu,sigma);
plot(x,y)
hold off;
xlim([min,max])


%% Generate samples and Plot the histogram of samples


val=zeros(1,sample_size);
accept_times=0;

while accept_times<sample_size
    x=normrnd(mu,sigma,1);
    gx=normpdf(x,mu,sigma);
    if x>=min && x<mode
        fx=((x-min)/(mode-min))*high;
    elseif x>=mode && x<=max
        fx=((max-x)/(max-mode))*high;
    else
        fx=0;
    end
    U=rand;
    if U<= (fx/(constant*gx))
        accept_times=accept_times+1;
        val(accept_times)=x;
    end
end
subplot(1,2,2)
histogram(val,100);
hold on;

%% Plot the density function of the distribution

x=[min,mode,max];
f=[0,high,0];
f=f*0.07*sample_size;
plot(x,f,'linewidth',2)

