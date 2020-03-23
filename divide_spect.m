function [rightV, leftV] = divide_spect(image)

leftV = image;
leftV(1:size(image,1)/2,:,:) = 0;
rightV = image;
rightV(size(image,1)/2+1:end,:,:) = 0;

