function out= NN_test(Image,neural_network)
%Image=imread(Image);
sizee=100;
B=double(imresize(Image,[sizee sizee]));
Image=B;
B_dash = 0.49*B(:,:,1) + 0.29*B(:,:,2)+0.22*B(:,:,3);
MR=double((mean2(B(:,:,1)))/256);
MG=double((mean2(B(:,:,2)))/256);
MB=double((mean2(B(:,:,3)))/256);
T=double(mean2(B_dash));
vh=[];
hh=[];
for ii=1:sizee
    sum=0;
    sum2=0;
    for jj=1:sizee
        if B_dash(ii,jj) > T
            sum=sum+B_dash(ii,jj);
        end
        if B_dash(jj,ii) > T
            sum2=sum2+B_dash(jj,ii);
        end
    end
    sum=sum/sizee;
    sum2=sum2/sizee;
    vh=[vh sum];
    hh=[hh sum2];
end

 R=Image(:,:,1);
 InputR=blockproc(R, [5 5], @(x) mean(x.data(:))); % Stores Average
 InputR=InputR(:);
 InputR=InputR';
 
 G=Image(:,:,2);
 InputG=blockproc(G, [5 5], @(x) mean(x.data(:))); % Stores Average
 InputG=InputG(:);
 InputG=InputG';
 
 B=Image(:,:,3);
 InputB=blockproc(B, [5 5], @(x) mean(x.data(:))); % Stores Average
 InputB=InputB(:);
 InputB=InputB';

Input=[InputR InputG InputB]';
%Input=[MR MG MB vh hh]';
%Input=[MR MG MB vh hh]';
value=sim(neural_network,Input);
maximum=max(value);
num=size(value,1);

index=0;
value
for i=1:num
    if (value(i)==maximum)
        index=i;
        break;
    end
end
out=-1;
if(index==1)
    out='Take a Left turn';
end
if(index==2)
    out='Take a Right Turn';
end
if(index==3)
    out='STOP!!';
end
if(index==4)
    out='Take a Left Turn';
end
if(index==5)
    out='YIELD (Give way to other Drivers)!!';
end
if(index==6)
    out='NO LEFT TURN';
end
if(index==7)
    out='NO RIGHT TURN';
end
if(index==8)
    out='NO U TURN';
end
end

