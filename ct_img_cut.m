function [ct_re] = ct_img_cut(ct_img, area_left, area_right, left_area_spect, right_area_spect)

ct_re = zeros(size(ct_img,1),size(ct_img,2),size(ct_img,3));
    for i = 1:size(area_left,2)
        ml = area_left(1,i);
        mr = area_right(1,i);
    
        if ml <= 100
            sel_l = 5;
        elseif (100 < ml) && (ml <= 250)
            sel_l = 8;
        elseif (250 < ml) && (ml <= 500)
            sel_l = 10;
        elseif (500 < ml) && (ml <= 1500)
            sel_l = 10;
        elseif (1500 < ml) && (ml < 2600)
            sel_l = 8;
        elseif 2600 <= ml
            sel_l = 5;
        end

        if mr <= 100
            sel_r = 5;
        elseif (100 < mr) && (mr <= 250)
            sel_r = 8;
        elseif (250 < mr) && (mr <= 500)
            sel_r = 10;
        elseif (500 < mr) && (mr <= 1500)
            sel_r = 10;
        elseif (1500 < mr) && (mr < 2600)
            sel_r = 8;
        elseif 2600 <= mr
            sel_r = 5;
        end
    
        SE_l = strel('disk',sel_l);
        SE_r = strel('disk',sel_r);

        if ml >= 2600
            dilate_l = imerode(left_area_spect(:,:,i),SE_l);
        elseif ml < 2000
            dilate_l = imdilate(left_area_spect(:,:,i), SE_l);
        else 
            dilate_l = left_area_spect(:,:,i);
        end

        if mr >= 2600
            dilate_r = imerode(right_area_spect(:,:,i),SE_r);
        elseif mr < 2000
            dilate_r = imdilate(right_area_spect(:,:,i), SE_r);
        else
            dilate_r = right_area_spect(:,:,i);  
        end

        prior_nm = dilate_l | dilate_r;
        prior_nm(:,:,i) = imfill(prior_nm,'hole');
        ct_re(:,:,i) = ct_img(:,:,i).*prior_nm(:,:,i);
        
    end