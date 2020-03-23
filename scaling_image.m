function [img_cut, img_scaled] = scaling_image(img)

sizeZ = size(img,3);
c = 40;
w = 400;

img_cut = zeros(size(img,1), size(img,2), size(img,3));

for i = 1:sizeZ
    I = img(:,:,i);
    img_scaled(:,:,i) = 511.*((double(I)-(c-0.5))/(w-1)+0.5);
    img_scaled(:,:,i) = int16(min(max(img_scaled(:,:,i),0),511));
    

end
% aa = img_scaled(:,:,100);
% imagesc(aa); axis image; colormap gray;

img_cut(img_scaled > 400) = 1;
img_cut(img_scaled < 210) = 1;   

img_scaled(img_scaled > 400) = 0;
img_scaled(img_scaled < 210) = 0;


