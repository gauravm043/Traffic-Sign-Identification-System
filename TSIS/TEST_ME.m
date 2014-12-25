function TEST_ME(file,neural_network)
tStart=tic;

%img=file;
img = imread(file);  %r1,r5,y1
Input=img;
%figure,imshow(img);
Original=img;
[height,width,band]=size(img);
img=rgb2hsv(img);
img = img(:,:,2);
%figure,imshow(img);

%% Testing new
% % img=rgb2hsv(Input);
% % H=img(:,:,1);
% % imin=min(min(H));
% % imax=max(max(H));
% % H=255*H;
% % for i=1:height
% %     for j=1:width
% %         if(H(i,j)>=0 && H(i,j)<=imin)
% %             H(i,j)=255*(imin-H(i,j))/imin;
% %         end
% %         if (H(i,j)>imin && H(i,j)<imax)
% %             H(i,j)=0;
% %         end
% %         if (H(i,j)>imax)
% %             H(i,j)=255*(H(i,j)-imax)/imax;
% %         end
% %     end
% % end
% % 
% % S=img(:,:,2);
% % S=255*S;
% % imin=min(min(S));
% % for i=1:height
% %     for j=1:width
% %         if(S(i,j)>=imin)
% %           S(i,j)=1;
% %         end
% %     end
% % end
% % img(:,:,1)=H;
% % img(:,:,2)=S;
% % figure,imshow(H);
% % figure,imshow(S);
% % figure,imshow(img);
% % return;
%% Old Version
max_sat=max(max(img));
for i=1:height
    for j=1:width
        if(img(i,j)<max_sat-0.1)
            Input(i,j,1)=0;
            Input(i,j,2)=0;
            Input(i,j,3)=0;
        end
    end
end
%figure,imshow(Input);

img=rgb2hsv(Input);
img=img(:,:,1);
%figure,imshow(img);

Red=Input;
Yellow=Input;

max_hue=max(max(img));
for i=1:height
    for j=1:width
        if(img(i,j)<max_hue-0.1)
            Red(i,j,1)=0;
            Red(i,j,2)=0;
            Red(i,j,3)=0;
        end
    end
end
%figure,imshow(Red);

%% Checking whether a Red sign has been identified
a=find(Red(:,:,1)>=50);
count=size(a,1);
is_red=0;
if ( count>=100 )
    is_red=1;
end


%% Checking whether a Blue sign has been identified
a=find(Red(:,:,3)>=50);
count=size(a,1);
is_blue=0;
if ( count>=100 )
    is_blue=1;
end

is_yellow=0;
if is_blue==0 && is_red==0
    min_hue=min(min(img));

    for i=1:height
        for j=1:width
            if(img(i,j)<min_hue+0.15)
                Yellow(i,j,1)=0;
                Yellow(i,j,2)=0;
                Yellow(i,j,3)=0;
            end
        end
    end
    %figure,imshow(Yellow);
    is_yellow=0;
    %% Checking whether a Yellow sign has been identified
    a1=find(Yellow(:,:,1)>=10);
    count=size(a1,1);
    a2=find(Yellow(:,:,2)>=10);
    count=count+size(a2,1);
    a3=find(Yellow(:,:,3)>=10);
    count=count+size(a3,1);
    if count>1000
        is_yellow=1;
    end
end


if is_red==1 
    Checker=Red;
end
if is_yellow==1
    Checker=Yellow;
end
if is_blue==1
    Checker=Red;
end

if is_red==1 || is_yellow==1 || is_blue==1
    M=height;
    N=width;
    min_row=100000000;
    min_col=100000000;
    max_col=-1;
    max_row=-1;
    for i=1:M
        for j=1:N
            if  (is_red==1 || is_yellow==1) && Checker(i,j,1)>100
                min_row=min(min_row,i);
                max_row=max(max_row,i);
                min_col=min(min_col,j);
                max_col=max(max_col,j);
            end
            if  (is_blue==1) && Checker(i,j,3)>50
                min_row=min(min_row,i);
                max_row=max(max_row,i);
                min_col=min(min_col,j);
                max_col=max(max_col,j);
            end
        end
    end
    
    min_col=max(min_col-5,1);
    min_row=max(min_row-5,1);
    max_col=min(max_col+5,N);
    max_row=min(max_row+5,M);
    temp=uint8(zeros((max_row-min_row+1),(max_col-min_col+1),3));
    s=1;
    for m=min_row:max_row
        t=1;
        for n=min_col:max_col
            temp(s,t,1)=Original(m,n,1);
            temp(s,t,2)=Original(m,n,2);
            temp(s,t,3)=Original(m,n,3);
            t=t+1;
        end
        s=s+1;
    end
   %figure,imshow(temp);
end
%imwrite(temp,'1.jpg');




%% Inserting Rectangle
shapeInserter = vision.ShapeInserter('Shape','Polygons','BorderColor','Custom', 'CustomBorderColor', uint8([0 255 0]));
polygon = int32([min_col min_row max_col min_row max_col max_row min_col max_row]); % 4 points in cyclic order 
J = step(shapeInserter, Original, polygon);
figure,imshow(J);


Message=NN_test(temp,neural_network);
h = msgbox(Message);

tElapsed=toc(tStart)
end