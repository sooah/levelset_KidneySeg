clear all;  close all;


% InputFolderPath =  'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04';
% 
% addpath("NIfTI_20140122");
% 
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\spm12\\spm12');
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\iso2mesh');
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\HKS');
% 
% d = dir(InputFolderPath);
% isub = [d(:).isdir];
% nameFoldsInput = {d(isub).name}';
% nameFoldsInput(ismember(nameFoldsInput,{'.','..'})) = [];
% folderCounts = length(nameFoldsInput);
% 
% global ctV;
% num = 0;
% tic
% for n=1:folderCounts
%     num = num +1;
%     subFolderNameInput = cast(nameFoldsInput(n), 'char');
%     msize = 256;
%     
%     ctFile = sprintf('%s\\%s\\c.img', InputFolderPath, subFolderNameInput);
%     ctV = open_image(ctFile,msize);
%     
%     spectFile = sprintf('%s\\%s\\s.img', InputFolderPath, subFolderNameInput);
%     spectV = open_image(spectFile,msize);
%     
%     truthFile = sprintf('%s\\%s\\q.img', InputFolderPath, subFolderNameInput);
%     truthV = open_image(truthFile,msize);
%     
%     % make coronal
%     ctV = permute(ctV,[1 3 2]);
%     truthV = permute(truthV, [1 3 2]);
%     spectV = permute(spectV, [1 3 2]); 
%     
%     
%     % ct preprocessing
%     [ct_cut, ct_img] = scaling_image(ctV);
%     
%     % spect preprocessing
%     spect_area_img = pre_spect_area(spectV);
%    
%     %  divide spect for area
%     [right_area_spect, left_area_spect] = divide_spect(spect_area_img);
%     left_area_spect(left_area_spect ~= 0 ) = 1;
%     right_area_spect(right_area_spect ~= 0 ) = 1;
%    
%     % % get size from spect left image
%     [area_left] = get_areainfo_spect(left_area_spect);
%     
%     % % get size from spect right image
%     [area_right] = get_areainfo_spect(right_area_spect);
%     
%     ct_re = zeros(size(ct_cut,1),size(ct_cut,2),size(ct_cut,3));
%     % % % % % % area size에 따라서 ct_cut 해줄 사이즈를 다르게 잡아줌! 
%     for i = 1:size(area_left,2)
%         ml = area_left(1,i);
%         mr = area_right(1,i);
% 
%         if ml <= 100
%             sel_l = 5;
%         elseif (100 < ml) && (ml <= 250)
%             sel_l = 10;
%         elseif (250 < ml) && (ml <= 500)
%             sel_l = 15;
%         elseif 500 < ml
%             sel_l = 20;
%         end
% 
%         if mr <= 100
%             sel_r = 5;
%         elseif (100 < mr) && (mr <= 250)
%             sel_r = 10;
%         elseif (250 < mr) && (mr <= 500)
%             sel_r = 15;
%         elseif 500 < mr
%             sel_r = 20;
%         end
% 
%         SE_l = strel('disk',sel_l);
%         SE_r = strel('disk',sel_r);
% 
%         dilate_l = imdilate(left_area_spect(:,:,i), SE_l);
%         dilate_r = imdilate(right_area_spect(:,:,i), SE_r);
% 
%         prior_nm = dilate_l + dilate_r;
%         ss = strel('disk',5);
%         prior_nm = imopen(prior_nm,ss);
%         prior_nm(:,:,i) = imfill(prior_nm,'hole');
%         ct_re(:,:,i) = ct_img(:,:,i).*prior_nm(:,:,i);
%     end
% 
%     se = strel('disk',5);
%     prior_cut = imerode(spect_area_img,se);
%     prior_cut = imfill(prior_cut);
%     ct_cut = ct_cut.*prior_cut;
%     
%     
%     % divide spect for center
%     [right_center_spect, left_center_spect] = divide_spect(spect_area_img);
%            
%     % get x,y location & size from spect left image
%     [x_centroid_right, y_centroid_right] = get_centerinfo_spect(right_center_spect);
%     
%     % get x,y location & size from spect right image
%     [x_centroid_left, y_centroid_left] = get_centerinfo_spect(left_center_spect);
% 
%     % segmentation
%     lambda = 0.0001; cut_start = 1; cut_final = size(ct_img,3);
%     seg = lvlset_sfm_coronal(ct_re,lambda, cut_start,cut_final, x_centroid_left, y_centroid_left, area_left, x_centroid_right, y_centroid_right, area_right);
%     seg2 = medfilt3(seg);
% 
%     se2 = strel('disk',2);
%     se3 = strel('disk',3);
%     ct_cut_dilate = imdilate(ct_cut,se2);
%     ct_cut_dilate = imopen(ct_cut_dilate,se3);
%     ct_cut_dilate = imclose(ct_cut_dilate,se3);
%     ct_cut_dilate_re = ones(size(ct_cut_dilate,1),size(ct_cut_dilate,2),size(ct_cut_dilate,3));
%     ct_cut_dilate_re(ct_cut_dilate == 1) = 0;
%     seg2 = seg2.*ct_cut_dilate_re;
% 
% 
% % % % % % %     change for axial
% %     ct_re = permute(ct_re,[1 3 2]);
% %     seg = permute(seg, [1 3 2]);
% %     truthV = permute(truthV, [1 3 2]);
% %     spect_area_img = permute(spect_area_img, [1 3 2]);
% %     spectV = permute(spectV, [1 3 2]);
%     
%     
%    
%     
%     
% %     destPath = "C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\patient(180727)\\debug";
% %     
% %     fileName = sprintf("%s\\%s_ct_cut", destPath , subFolderNameInput );
% %     ana = make_ana(ct_re(:, :, :), [1.7258 1.7258 1.7258], [0 0 0], 4, 'CT');
% %     save_untouch_nii(ana, fileName)
% %     
% %     fileName = sprintf("%s\\%s_seg", destPath , subFolderNameInput );
% %     ana = make_ana(seg(:, :, :), [1.7258 1.7258 1.7258], [0 0 0], 4, 'CT');
% %     save_untouch_nii(ana, fileName)
% %     
% %     fileName = sprintf("%s\\%s_ref", destPath , subFolderNameInput );
% %     ana = make_ana(truthV(:, :, :), [1.7258 1.7258 1.7258], [0 0 0], 4);
% %     save_untouch_nii(ana, fileName)
% %     
% %     fileName = sprintf("%s\\%s_spect_cut", destPath , subFolderNameInput );
% %     ana = make_ana(spect_area_img(:, :, :), [1.7258 1.7258 1.7258], [0 0 0], 16);
% %     save_untouch_nii(ana, fileName)
%     
%   
% % % %  Get Dice Coeff      
% 
%     dice_btw_lsV_q2(n,1) = get_dice(truthV,seg2);
%     count_truthV_spect(n,1) = sum(sum(sum(truthV)));
%     count_seg_spect2(n,1) = sum(sum(sum(seg2)));
%     
% end
% toc
% 
% 
% 


%% prc
% 
% file save
addpath("NIfTI_20140122");
% for smoothing
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\spm12\\spm12');
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\iso2mesh');
% addpath('C:\\Users\\soual\\OneDrive\\문서\\MATLAB\\project(180807)\\HKS');

% 
% % % 
% % % %1
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_11889607';
% % % % % %2
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_14448360';
% % % % % %3
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_20674380';
% % % % %4
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_23973598';
% % % % % %5
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_25223910';
% % % % % %6
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_25412051';
% % % % % %7
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_26264666';
% % % % % % %8
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_26760708';
% % % % % % %9
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_27036770';
% % % % % % %10
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_27384208';
% % % % % % %11
path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_27536009';
% % % % % % % %12
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_27978230';
% % % % % % % %  13
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_28257215';
% % % % % % % % % % % 17
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_28361051';
% % % % % % % % % % % 18
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\01_28396730';
% % % % % % % % % % % 20
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_10103564';
% % % % % % % % % % % 22
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_11997832';
% % % % % % % % % 23
% path  = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_12483196';
% % % % % % % % % % 27
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_16492611';
% % % % % % % % % % % % % %30
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_19602570';
% % % % % % % % % % % 40
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_26659916';


% % % % % % % % % % 42
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_27034527';
% % % % % % % % % % % % % 45
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_27669954';
% % % % % % % % % % 46
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_27843093';
% % % % % % % % % % 48
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_28151191';
% % % % % % % % % % 49
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\02_28432984';
% % % % % % % % % % % % % 58
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\04_22794646';
% % % % % % % % % % % % % 59
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\04_25658701';
% % % % % % % % % % % 63
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\05_25066472';
% % % % % % % % % % % 65
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\05_27243390';
% % % % % % % % % 70
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\06_27226333';

% % % % % % % % % % 71
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\06_27226333';

% % % % % % % % % 75
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\07_28034777';
% % % % % % % % % % 76
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\07_28795964';
% % % % % % % % % % 77
% path = 'C:\\Users\\soual\\OneDrive - 서강대학교\\2018_intern\\04\\08_26514866';

msize = 256;
% % % % % % % % % % 
% % % % % % % % % % % % spect image load
spectFile = sprintf('%s\\s.img', path);
spectV = open_image(spectFile,msize);
% % % % % % % % % % 
% % % % % % % % % % % % ct image load
ctFile = sprintf('%s\\c.img', path);
ctV = open_image(ctFile,msize);
% % % % % % % % % 
% % % % % % % % % % % % ground truth image load
truthFile = sprintf('%s\\q.img', path);
truthV = open_image(truthFile,msize);
% % % % % % % % % % 
% % % % % % % % % % % make coronal 
ctV = permute(ctV,[1 3 2]);
truthV = permute(truthV, [1 3 2]);
spectV = permute(spectV, [1 3 2]);

[ct_cut, ct_img] = scaling_image(ctV);

spect_area_img = pre_spect_area(spectV);
 
[right_area_spect, left_area_spect] = divide_spect(spect_area_img);
left_area_spect(left_area_spect ~= 0 ) = 1;
right_area_spect(right_area_spect ~= 0 ) = 1;
% % % %  
% aa = left_area_spect(:,:,90);
% bb = right_area_spect(:,:,90);
% subplot(1,2,1); imagesc(aa); axis image; colormap gray;
% subplot(1,2,2); imagesc(bb); axis image; colormap gray;


% % % % % % % % % % % % % % % % % % get size from spect left image
[area_left] = get_areainfo_spect(left_area_spect);
% % % % % % % % % % 
% % % % % % % % % % % % % % % % % get size from spect right image
[area_right] = get_areainfo_spect(right_area_spect);
% % % % % 
% % % % % % % % % % % area size에 따라서 ct_cut 해줄 사이즈를 다르게 잡아줌! 
[ct_re] = ct_img_cut(ct_img, area_left, area_right, left_area_spect, right_area_spect);

se = strel('disk',5);
spect_area = zeros(size(spect_area_img,1),size(spect_area_img,2),size(spect_area_img,3));
spect_area(spect_area_img > 0) = 1;
prior_cut2 = imdilate(spect_area,se);
ct_cut2 = ct_cut.*prior_cut2;

prior_cut = imerode(spect_area_img,se);
prior_cut = imfill(prior_cut);
ct_cut = ct_cut.*prior_cut;


% % % % % % divide spect for center
[right_center_spect, left_center_spect] = divide_spect(spect_area_img);
left_center_spect(left_center_spect ~= 0) = 1;
right_center_spect(right_center_spect ~= 0) = 1;
% % % % % % % % % % % get x,y location from spect right image 
[x_centroid_right, y_centroid_right] = get_centerinfo_spect(right_center_spect);
% % % % % % % % % % % % % % % % get x,y location from spect left image 
[x_centroid_left, y_centroid_left] = get_centerinfo_spect(left_center_spect);

% % % % % % % % segmentation
lambda = 0.0001; cut_start = 1; cut_final = size(ct_img,3); 
seg = lvlset_sfm_coronal(ct_re,lambda, cut_start,cut_final, x_centroid_left, y_centroid_left, area_left, x_centroid_right, y_centroid_right, area_right);
seg2 = medfilt3(seg);


% se2 = strel('disk',2);
se3 = strel('disk',1);
ct_cut_dilate = imdilate(ct_cut,se3);
% ct_cut_dilate = imopen(ct_cut_dilate,se3);
% ct_cut_dilate = imclose(ct_cut_dilate,se3);

ct_cut_dilate = ct_cut2|ct_cut_dilate;

ct_cut_dilate_re = ones(size(ct_cut_dilate,1),size(ct_cut_dilate,2),size(ct_cut_dilate,3));
ct_cut_dilate_re(ct_cut_dilate == 1) = 0;


% % % % % 
seg2 = seg2.*ct_cut_dilate_re;
% 

% seg_p = permute(seg2, [1 3 2]);

% destPath = 'C:\\Users\\soual\\Documents\\MATLAB\\seg';
% fileName = sprintf("%s\\seg", destPath );
% ana = make_ana(seg_p(:, :, :), [1.7258 1.7258 1.7258], [0 0 0], 4, 'CT');
% save_untouch_nii(ana, fileName)
% 
% smoothing_seg(destPath)
% 
% smoothFile = sprintf('%s\\seg_p.img', destPath);
% smoothV = open_image(smoothFile,msize);
% smoothV = permute(smoothV, [1 3 2]);

i1 = ctV(:,:,90);
i2 = ct_img(:,:,90);
i3 = spect_area_img(:,:,90);
aaa = spectV(:,:,90);
i4 = truthV(:,:,90);
i5 = seg(:,:,90);
i6 = ct_re(:,:,90);
aa = seg2(:,:,90);


figure(1);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(90),y_centroid_right(90),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(90),y_centroid_left(90),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';

i1 = ctV(:,:,100);
i2 = ct_img(:,:,100);
i3 = spect_area_img(:,:,100);
aaa = spectV(:,:,100);
i4 = truthV(:,:,100);
i5 = seg(:,:,100);
i6 = ct_re(:,:,100);
aa = seg2(:,:,100);

figure(2);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(100),y_centroid_right(100),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(100),y_centroid_left(100),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';

i1 = ctV(:,:,110);
i2 = ct_img(:,:,110);
i3 = spect_area_img(:,:,110);
aaa = spectV(:,:,110);
i4 = truthV(:,:,110);
i5 = seg(:,:,110);
i6 = ct_re(:,:,110);
aa = seg2(:,:,110);

figure(3);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(110),y_centroid_right(110),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(110),y_centroid_left(110),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';

i1 = ctV(:,:,120);
i2 = ct_img(:,:,120);
i3 = spect_area_img(:,:,120);
aaa = spectV(:,:,120);
i4 = truthV(:,:,120);
i5 = seg(:,:,120);
i6 = ct_re(:,:,120);
aa = seg2(:,:,120);

figure(4);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(120),y_centroid_right(120),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(120),y_centroid_left(120),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';
% 
i1 = ctV(:,:,130);
i2 = ct_img(:,:,130);
i3 = spect_area_img(:,:,130);
aaa = spectV(:,:,130);
i4 = truthV(:,:,130);
i5 = seg(:,:,130);
i6 = ct_re(:,:,130);
aa = seg2(:,:,130);
% 
figure(5);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(130),y_centroid_right(130),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(130),y_centroid_left(130),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';

i1 = ctV(:,:,140);
i2 = ct_img(:,:,140);
i3 = spect_area_img(:,:,140);
aaa = spectV(:,:,140);
i4 = truthV(:,:,140);
i5 = seg(:,:,140);
i6 = ct_re(:,:,140);
aa = seg2(:,:,140);
% 
figure(6);
subplot(2,4,1); imagesc(i1); axis image; colormap gray; title 'ct origin';
subplot(2,4,2); imagesc(i2); axis image; colormap gray; title 'ct process';
subplot(2,4,3); imagesc(i3); axis image; colormap gray; title 'SPECT process';
subplot(2,4,4); imagesc(i4); axis image; colormap gray; title 'truth';
subplot(2,4,5); imagesc(i5); axis image; colormap gray; title 'seg';
subplot(2,4,6); imagesc(i6); axis image; colormap gray; title 'ct cut';
subplot(2,4,7); imagesc(aaa); axis image; colormap gray; title 'spect';
hold on
subplot(2,4,7); plot(x_centroid_right(140),y_centroid_right(140),'r*'); 
hold on
subplot(2,4,7); plot(x_centroid_left(140),y_centroid_left(140),'r*');
subplot(2,4,8); imagesc(aa); axis image; colormap gray; title 'seg median';
% % 
% % % Get Dice Coeff     
truthV(truthV>0) = 1;
dice_btw_lsV_q = get_dice(truthV,seg2)

spect_truthV = truthV.*spectV;
spect_seg2 = seg2.*spectV;

count_spect_truthV(n,1) = sum(sum(sum(spect_truthV)))
count_spect_seg2(n,1) = sum(sum(sum(spect_seg2)))
% % 
% % dice_btW_spV_q = get_dice(truthV,spect_area_img)
% % % % 