function iterations = iter_num(area)

areaz = size(area,2);

for k = 1:areaz
    A = area(:,k);
    if (5 < A < 100)
        iter_n = 30;
        iterations = iter_n;
               
    elseif (100 <= A <200)
        iter_n = 50;
        iterations = iter_n;
        
    elseif (200 <= A <300)
        iter_n = 80;
        iterations = iter_n;
        
    elseif (300 <= A <400)
        iter_n = 100;
        iterations = iter_n;
        
    elseif (400 <= A < 500)
        iter_n = 100;
        iterations = iter_n;
        
    elseif (500 <= A < 700)
        iter_n = 150;
        iterations(k) = iter_n;
        
    elseif (700 <= A < 900)
        iter_n = 200;
        iterations = iter_n;
        
    elseif (900 <= A <1000)
        iter_n = 300;
        iterations = iter_n;
        
    elseif (1000 <= A < 1200)
        iter_n = 400;
        iterations = iter_n;
    
    elseif (1200 <= A < 1500)
        iter_n = 500;
        iterations = iter_n;
        
    elseif (1500 <= A < 1800)
        iter_n = 600;
        iterations = iter_n;
       
    elseif (1800 <= A < 2000)
        iter_n = 800;
        iterations = iter_n;
        
    elseif (2000 <= A )
        iter_n = 1000;
        iterations = iter_n;
    end
end
        