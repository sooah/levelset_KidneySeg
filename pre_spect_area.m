function prior_nm = pre_spect_area(spect)

nm = spect(:,:,:);
xSize = size(spect,1);
ySize = size(spect,2);
outputsizeZ = size(spect,3);
prior_nm = zeros(xSize, ySize, outputsizeZ);

actual_min = min(min(min(nm(:))));
actual_max = max(max(max(nm(:))));
desired_min = 0.0;
desired_max = 1.0;

mx = round(size(nm,1)/2);
nm(mx-10:mx+10,:,:) = 0;


for i = 1:outputsizeZ
    norm_img = (nm(:,:,i) - actual_min)*((desired_max - desired_min)/(actual_max - actual_min)) + desired_min;
    prior_nm(:,:,i) = norm_img;
end


mm = multithresh(prior_nm,10);

if (mm(1,4) > 0.4) && (mm(1,3) > 0.25)
    mem = mm(1,3);
    
elseif (mm(1,3) < 0.2)
    mem = mm(1,4);
    
elseif (mm(1,4) > 0.4) && (mm(1,3) < 0.25)
    mem = (mm(1,3)+2*mm(1,4))/3;

elseif (mm(1,4) < 0.4) && (mm(1,3) < 0.25)
    mem = (mm(1,3)+2*mm(1,4))/3;
        
else
    mem = (mm(1,4)+mm(1,3))/2;
end

prior_nm(mem > prior_nm) = 0;

% se = strel('disk',8);
% prior_nm = imdilate(prior_nm,se);


se = strel('disk',3);
prior_nm = imdilate(prior_nm,se);   
prior_nm = imclose(prior_nm,se);
prior_nm = imdilate(prior_nm,se);
prior_nm = imclose(prior_nm,se);
prior_nm = imopen(prior_nm,se);

s = size(prior_nm);
[v,ii] = max(reshape(prior_nm,[],s(3)));
[i1, j1] = ind2sub(s(1:2),ii);
out = [v;i1;j1;1:s(3)]';

[maxout,idx] = max(out(:,1));

% mid_x = out(idx,2);
mid_y = out(idx,3);

embox = zeros(s(1),s(2),s(3));
q1 = floor(s(2)/4);
if mid_y < q1
    embox(:,1:3*q1,:) = 1;
elseif (q1 <= mid_y) && (3*q1 > mid_y)
    if 3*mid_y < 2*q1
        embox(:,1:3*q1,:) = 1;
    elseif mid_y < 2*q1
        embox(:,round(q1/2):3*q1+round(q1/2),:) = 1;
    else
        if s(2) < 100
            embox(:,:,:) = 1;
        else
            embox(:,q1:end,:)=1;
        end
    end
elseif mid_y >= q1*3
    embox(:,q1:end,:) = 1;
end


prior_nm = prior_nm.*embox;

se = strel('disk',5);

prior_nm = imopen(prior_nm,se);
prior_nm = imclose(prior_nm,se);
prior_nm = imdilate(prior_nm,se);
prior_nm = medfilt3(prior_nm);
