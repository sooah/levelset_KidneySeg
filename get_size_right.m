function mask = get_size_right(I, area_right, right_x, right_y)


if area_right <= 400
    mask = get_ellipse(I,2,4,right_x, right_y,120);
    
elseif (400 < area_right) && (area_right <= 800)
    mask = get_ellipse(I,5,10,right_x,right_y,120);
    
elseif (800 < area_right) && (area_right <= 1600)
    mask = get_ellipse(I,10,15,right_x,right_y,120);
    
elseif (1600 < area_right) && (area_right <= 3000)
    mask = get_ellipse(I,15,15,right_x,right_y,120);
    
elseif (3000 < area_right)
    mask = get_ellipse(I,20,20,right_x,right_y,120);
end

    