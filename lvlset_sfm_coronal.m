function seg_img = lvlset_sfm_coronal(ct_img,lambda,cut_start,cut_final,x_centroid_left,y_centroid_left,area_left,x_centroid_right,y_centroid_right,area_right)

seg = zeros(size(ct_img,1),size(ct_img,2),size(ct_img,3));
mask_left = zeros(size(ct_img,1),size(ct_img,2));
mask_right = zeros(size(ct_img,1),size(ct_img,2));

for k = cut_start : cut_final
    I = ct_img(:,:,k);
    
    if (area_left(1,k) ~= 0 && area_right(1,k) == 0) % 내 기준 왼쪽만 존재 (끝쪽)
        left_x = x_centroid_left(1,k);
        left_y = y_centroid_left(1,k);
        mask_left = get_size_left(I,area_left(1,k),left_x,left_y);
        iterations_left = iter_num(area_left(1,k));
        seg(:,:,k) = sfm_chanvese(I,mask_left,iterations_left,lambda);
        
    elseif (area_left(1,k) == 0 && area_right(1,k) ~= 0) % 내 기준 오른쪽만 존재 (시작)
        right_x = x_centroid_right(1,k);
        right_y = y_centroid_right(1,k);
        mask_right = get_size_right(I,area_right(1,k),right_x,right_y);
        iterations_right = iter_num(area_right(1,k));
        seg(:,:,k) = sfm_chanvese(I,mask_right,iterations_right,lambda);
        
    elseif (area_left(1,k) ~= 0 && area_right(1,k) ~= 0) % 두개 다 존재할때
        left_x = x_centroid_left(1,k);
        left_y = y_centroid_left(1,k);
        mask_left = get_size_left(I,area_left(1,k),left_x,left_y);
        iterations_left = iter_num(area_left(1,k));
        [seg_left] = sfm_chanvese(I,mask_left,iterations_left,lambda);
        
        right_x = x_centroid_right(1,k);
        right_y = y_centroid_right(1,k);
        mask_right = get_size_right(I,area_right(1,k),right_x,right_y);
        iterations_right = iter_num(area_right(1,k));
        [seg_right] = sfm_chanvese(I,mask_right,iterations_right,lambda);
        
        seg(:,:,k) = [seg_left]|[seg_right];
    
    end
end

seg_img(:,:,:) = seg(:,:,:);
       