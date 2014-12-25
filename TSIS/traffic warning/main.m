function main
readerobj = mmreader('stoprd.avi');
vidFrames = read(readerobj);
%get number of frames
numFrames = get(readerobj, 'numberOfFrames');
%figure(1)
implay(vidFrames)
for k = 1 : numFrames-1
mov(k).cdata = vidFrames(:,:,:,k);
mov(k).colormap = [];
mov(k).cdata=blobAnalysis(mov(k).cdata);
% imshow(mov(k).cdata) ;
% waitforbuttonpress ;
vidFrames(:,:,:,k)=mov(k).cdata;
imwrite(mov(k).cdata, strcat('output\frame-',imagename));
end
%implay(vidFrames);