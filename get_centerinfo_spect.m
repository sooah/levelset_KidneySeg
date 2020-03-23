function [x_centroid, y_centroid] = get_centerinfo_spect(spect)

x_bar = zeros(1,size(spect,3));
y_bar = zeros(1,size(spect,3));

for i = 1:size(spect,3)
    img = spect(:,:,i);
    test_max = max(max(img));
    img(test_max*0.6 > img) = 0;
    
    bw = img < 256;
    bw = imfill(bw,'holes');
    L = bwlabel(bw);
    
    s = regionprops(L,'PixelIdxList','PixelList');
    for k = 1:numel(s)
        idx = s(k).PixelIdxList;
        pixel_values = double(img(idx));
        sum_pixel_values = sum(pixel_values);
        x = s(k).PixelList(:,1);
        y = s(k).PixelList(:,2);
		if (sum_pixel_values ~= 0)
        	x_bar(1,i) = sum(x.*pixel_values) / sum_pixel_values;
        	y_bar(1,i) = sum(y.*pixel_values) / sum_pixel_values; 
        end			    
    end

    x_centroid = round(x_bar);
    y_centroid = round(y_bar);
    
    if (x_centroid(1,i) == 0) 
        if (y_centroid(1,i) == 0)
            x_centroid(1,i) = 0;
            y_centroid(1,i) = 0;
        end
    end
    
end
x_centroid = medfilt1(x_centroid);
y_centroid = medfilt1(y_centroid);
