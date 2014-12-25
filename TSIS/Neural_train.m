a= rand(1,1000)*10;
b=rand(1,1000)*10;
c=rand(1,1000)*10;
n=rand(1,1000)*0.05;

y=a*5+b.*c+7*c+n;

I=[a; b; c];
O=y;
R=[0 10; 0 10 ; 0 10];
S=[5 1];
net = newff([0 10;0 10 ;0 10],S,{'tansig','purelin'});
net=train(net,I,O);