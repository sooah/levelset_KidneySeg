function mask = get_size_left(I, area_left, left_x, left_y)


if area_left <= 400
    mask = get_ellipse(I,2,4,left_x, left_y,160);
    
elseif (400 < area_left) && (area_left <= 800)
    mask = get_ellipse(I,5,10,left_x,left_y,160);
    
elseif (800 < area_left) && (area_left <= 1600)
    mask = get_ellipse(I,10,15,left_x,left_y,160);
    
elseif (1600 < area_left) && (area_left <= 3000)
    mask = get_ellipse(I,15,15,left_x,left_y,160);
    
elseif 3000 < area_left
    mask = get_ellipse(I,20,20,left_x,left_y,160);
end

    