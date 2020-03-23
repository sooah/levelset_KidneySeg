function [area] = get_areainfo_spect(spect_img)

area = zeros(1,size(spect_img,3));

outputsize_prior = size(spect_img,3);

for k = 1:outputsize_prior
    I = spect_img(:,:,k);
    BW = I > 0;
    s = regionprops(BW,I,'Area');
    numobj = numel(s);
    for i = 1:numobj
        if area(1,k) < s(i).Area
            area(1,k) = s(i).Area;
        else
            area(1,k) = area(1,k);
        end
    end
end

area = medfilt1(area);