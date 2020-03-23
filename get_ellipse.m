% %%------------------------------------------------------------------------
% %% GET_ELLIPSE
% %% This function takes either:
% %% 1) An Image (RGB or grayscale) OR
% %% 2) An Image, and parameters for an ellipse
% %%   - a:  major radius
% %%   - b:  minor radius
% %%   - x0: x center
% %%   - y0: y center
% %%   - rho:angle of rotation
% %%------------------------------------------------------------------------

function [mask, a, b, x0, y0, rho]  = get_ellipse(I,a,b,x0,y0,rho)

  [ny nx] = size(I);
  
  if(nargin == 1)
    imshow(I,[]);

    %%-- Get major axis
    [xa ya] = ginput(2);
    %%-- Get minor axis
    [xi yi] = ginput(2);
    
    %%-- Dtermine centroid based on major axis selection
    x0 = mean(xa);
    y0 = mean(ya);
    
    %%-- determine a and b from user input
    a = sqrt(diff(xa)^2 + diff(ya)^2)/2;
    b = sqrt(diff(xi)^2 + diff(yi)^2)/2;
    
    %%-- determine rho based on major axis selection
    rho = atan(diff(xa)/diff(ya));
  end
  
  mask = zeros(ny,nx);
  theta = [-0.03:0.001:2*pi];

  % Parametric equation of the ellipse
  %----------------------------------------
  x = a*cos(theta);
  y = b*sin(theta);

  % Coordinate transform 
  %----------------------------------------
  Y = cos(rho)*x - sin(rho)*y;
  X = sin(rho)*x + cos(rho)*y;
  X = X + x0;
  Y = Y + y0;
  
  %%-- Draw the ellipse into the mask
  X = round(X); Y = round(Y);
  X(find(X<1))=1;   Y(find(Y<1))=1;
  X(find(X>nx))=nx; Y(find(Y>ny))=ny;
  
  mask(sub2ind(size(mask),Y,X))=1;
  mask = bwfill(mask, 'holes');
  