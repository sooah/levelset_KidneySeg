% %%---------------------------------------------------------------------------
% %% MANUALSELECT
% %% This function takes an image I (RGB or grayscale).  It then allows the user
% %% to click points.  Each point the user clicks is appended to a piecewise
% %% linear curve.  The user should click the boundary of the mask that they
% %% would like to obtain.  To close the contour, the user should right-click.
% %%
% %% The result is a binary mask where '1' represents space enclosed by the
% %% contour and '0' is placed elswhere.
% %%
% %% This is handy for initizations such as those used for active contour
% %% image segmentation.
% %%
% %% Written By Shawn Lankton July 14, 2007
% %%---------------------------------------------------------------------------


function mask = manualSelect(I)

colormap(gray);
imshow(uint8(I), 'DisplayRange', [], 'InitialMagnification',600/max(size(I))*100 );

%%-- Display instructions to user
title('click points to make an initial contour, right click to close contour and finish');
disp('click points to make an initial contour,');
disp('right click to close contour and finish');

%%-- begin getting points
[y1 x1 b] = ginput(1);
xi = x1;
yi = y1;
if(b ~= 1) return; end

[ny nx c] = size(I);
mask = zeros(ny,nx);

while(1)
    x2 = x1;
    y2 = y1;
    [y1 x1 b] = ginput(1);
    
    if(b ~= 1)
        x1 = xi;
        y1 = yi;
    end

    %%--figure out the length of x & y component
    lx = x2-x1;     
    ly = y2-y1;

    %%--figure out line length = pythagorian length + fudge factor
    len = ceil((lx^2+ly^2)^(1/2))+1;  

    %%--make a linearly spaced vector (some values repeated)
    x = round(x1:(lx)/(len-1):x2); 
    y = round(y1:(ly)/(len-1):y2); %make another one for y

    %%--if it was a constant level the lines above mess up make a constant line
    if(length(x) == 0)                
        x = round(x1) * ones(1,len);
    end
    if(length(y) == 0)
        y = round(y1) * ones(1,len);
    end

    mask(sub2ind(size(mask),x, y)) = 1;
    idx = find(mask==1);

    %%-- draw the users line in the image (color or grayscale)
    if(c-1)
      Ir = I(:,:,1); Ig = I(:,:,2); Ib = I(:,:,3);
      Ir(idx) = 255;
      Ig(idx) = 255;
      Ib(idx) = 255;
      I(:,:,1) = Ir; I(:,:,2) = Ig; I(:,:,3) = Ib;
    else
      I(idx) = 255;
    end
    
    
    imshow(uint8(I),'DisplayRange', [], 'InitialMagnification', 600/max(size(I))*100);
    
    if(b ~= 1) break; end
end

mask = bwfill(mask, 'holes');
mask = ~mask;
