function x=blobAnalysis(a)
%a=imread('stoproad.jpg');
x=a;
a(:,:,1) = medfilt2(a(:,:,1), [3 3]);
a(:,:,2) = medfilt2(a(:,:,2), [3 3]);
a(:,:,3) = medfilt2(a(:,:,3), [3 3]);
[r c d]=size(a);
check=1;
i1=0;j1=0;
i2=0;j2=0;
%for k=1:1;
    for i=1:r
        for j=1:c           
            if(a(i,j,1)>125&&a(i,j,2)<90&&a(i,j,3)<90)
                if(check)
                i1=i;j1=j;
                check=0;
                else
                    i2=i;j2=j;
                end
                           
            end
            
            
        end
    end
%end


i1=i1-2;
if(i1<1)
    i1=1;
end
i2=i2+2;
if(i2>r)
    i2=r;
end

if(c>500)
    
j1=j1-40;
else
    if(r<150)
        j1=j1-10;
    else
    j1=j1-30;
    end
end
if(j1<1)
    j1=1;
end
j2=j2+20;
if(j2>c)
    j2=c;
end
i2-i1;

yieldtag=imread('yieldtag1.jpg');
stptag=imread('stoptag1.jpg');
[r1 c1 d1]=size(stptag);
z=a(i1:i2,j1:j2,1:3);
%z=a(i1-10:i2+10,j1-130:j2+70,1:3);
% figure(1)
% subplot(3,1,1)
% imshow(a);
% subplot(3,1,2)
% imshow(z);
z=rgb2gray(z);
z=im2double(z);
z=im2bw(z,0.5);
%z=bilinear(z,100,100);
[row col]=size(z);
if(row~=0 && col~=0)
z=imresize(z, [18 18], 'nearest');
load vipwarningsigns_templates.mat;
for k=1:9
temp=template_recognition(:,:,k);
s(k)=corr2(temp,z);
end
mx=max(s);
ind=1;
for i=1:9
    if(s(i)==mx)
        ind=i;
    end
end
if(isnan(s)==0)
   if(i2-i1>20)
    if(mx>0.15)
        for l1=i1:i2
            a(l1,j1,1)=255;
            a(l1,j1,2)=255;
            a(l1,j1,3)=0;
            
            a(l1,j2,1)=255;
            a(l1,j2,2)=255;
            a(l1,j2,3)=0;
        end
        
        for l2=j1:j2
            a(i1,l2,1)=255;
            a(i1,l2,2)=255;
            a(i1,l2,3)=0;
            
            a(i2,l2,1)=255;
            a(i2,l2,2)=255;
            a(i2,l2,3)=0;
        end
        if(r<150)
            
       %if(ind==7||ind==8||ind==9)
        scalex=i2+r1-1;
        scaley=j1+c1-1;
       % size(a(i2:scalex,scaley:j1));
        a(i2:scalex,j1:scaley,:)=yieldtag;
      % end
        else
       %if(ind==1||ind==2||ind==3)
        scalex=i2+r1-1;
        scaley=j1-c1+1;
       % size(a(i2:scalex,scaley:j1));
        a(i2:scalex,scaley:j1,:)=stptag;
     %  end
        end


      
    end
   end
end
end
x=a;

imshow(x);
%figure(2),imshow(a);


