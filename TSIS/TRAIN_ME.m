function neural_network=TRAIN_ME()

%% Initialisation
sizee=100;
Classes=8;
net11 = patternnet(63);
Net_Input=[];
Net_Output=[];

cd('Training');
%% Training phase
for i=1:Classes
    folder_name=strcat('Data',num2str(i));
    D=dir(folder_name);
    n_images=length(D)-2;
    cd (folder_name);
    for j=1:n_images
        file=strcat(num2str(j),'.jpg');
        if i==3 || i==9
            file=strcat(num2str(j),'.ppm');
        end
        B=imread(file);
        
        
        B=double(imresize(B,[sizee sizee]));
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
        
        %Input=[MR MG MB vh hh InputR InputG InputB]';
        Output=zeros(1,Classes)';
        Output(i)=1; % The class Name
        Net_Input=[Net_Input Input];
        Net_Output=[Net_Output Output];
       
    end
    cd('..');
end
cd('..');
neural_network=train(net11,Net_Input,Net_Output);
end
