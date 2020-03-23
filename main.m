clear all; close all;


InputFolderPath =  'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04';
addpath("NIfTI_20140122");

d = dir(InputFolderPath);
isub = [d(:).isdir];
nameFoldsInput = {d(isub).name}';
nameFoldsInput(ismember(nameFoldsInput,{'.','..'})) = [];
folderCounts = length(nameFoldsInput);

tic
for n = 1:folderCounts
    subFolderNameInput = cast(nameFoldsInput(n), 'char');
    msize = 256;
    
    ctFile = sprintf('%s\\%s\\c.img', InputFolderPath, subFolderNameInput);
    ctV = open_image(ctFile,msize);
    
    spectFile = sprintf('%s\\%s\\s.img', InputFolderPath, subFolderNameInput);
    spectV = open_image(spectFile,msize);
    
    truthFile = sprintf('%s\\%s\\q.img', InputFolderPath, subFolderNameInput);
    truthV = open_image(truthFile,msize);
    
    ctV = permute(ctV,[1 3 2]);
    truthV = permute(truthV, [1 3 2]);
    spectV = permute(spectV, [1 3 2]);
    
    [ct_cut, ct_img] = scaling_image(ctV);
    
    spect_area_img = pre_spect_area(spectV);
    [right_area_spect, left_area_spect] = divide_spect(spect_area_img);
    left_area_spect(left_area_spect ~= 0 ) = 1;
    right_area_spect(right_area_spect ~= 0 ) = 1;

    [area_left] = get_areainfo_spect(left_area_spect);
    [area_right] = get_areainfo_spect(right_area_spect);
    
    [ct_re] = ct_cut(ct_img, area_left, area_right, left_area_spect, right_area_spect);
    
% % % % % % % % % % segmentation이 더 크게 됬을 경우 바깥 부분 제거
    se = strel('disk',5);
    spect_area = zeros(size(spect_area_img,1),size(spect_area_img,2),size(spect_area_img,3));
    spect_area(spect_area_img > 0) = 1;
    prior_cut2 = imdilate(spect_area,se);
    ct_cut2 = ct_cut.*prior_cut2;    
    
% % % % % % % % % % % % segmentation 한것 에서 내부 제거 하기 위해 spect영상이 사이즈가 크니까 
% % % % % % % % % % % % 사이즈 축소
    prior_cut = imerode(spect_area_img,se);
    prior_cut = imfill(prior_cut);
    ct_cut = ct_cut.*prior_cut;
    
    [right_center_spect, left_center_spect] = divide_spect(spect_area_img);
    left_center_spect(left_center_spect ~= 0) = 1;
    right_center_spect(right_center_spect ~= 0) = 1;
    [x_centroid_right, y_centroid_right] = get_centerinfo_spect(right_center_spect); 
    [x_centroid_left, y_centroid_left] = get_centerinfo_spect(left_center_spect);
    
    
    lambda = 0.0001; cut_start = 1; cut_final = size(ct_img,3); 
    seg = lvlset_sfm_coronal(ct_re,lambda, cut_start,cut_final, x_centroid_left, y_centroid_left, area_left, x_centroid_right, y_centroid_right, area_right);
    seg2 = medfilt3(seg);
    
% % % % % % % % % % % % % % ct cut 에서 제거된 부분은 너무 작음 -> 사이즈 약간 키워서 제거
    se3 = strel('disk',1);
    ct_cut_dilate = imdilate(ct_cut,se3);
    ct_cut_dilate = ct_cut2|ct_cut_dilate;

% % % % % % % % % % % % % % % 제거!
    ct_cut_dilate_re = ones(size(ct_cut_dilate,1),size(ct_cut_dilate,2),size(ct_cut_dilate,3));
    ct_cut_dilate_re(ct_cut_dilate == 1) = 0;
    seg2 = seg2.*ct_cut_dilate_re;
    
    truthV(truthV > 0) = 1;
    dice_btw_lsV_q(n,1) = get_dice(truthV,seg2)
    
    spect_truthV = truthV.*spectV;
    spect_seg2 = seg2.*spectV;
    
    count_spect_truthV(n,1) = sum(sum(sum(spect_truthV)));
    count_spect_seg2(n,1) = sum(sum(sum(spect_seg2)));
    
end
toc
