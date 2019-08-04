1;

function draw_line(x1, y1, x2, y2, c = "black")
    line([x1,x2],[y1,y2], "color", c);
endfunction

function draw_horizontal_line(x1, x2, y, c = "black")
    line([x1,x2],[y,y], "color", c);
endfunction

function draw_vertical_line(x1, y1, y2, c = "black")
    line([x1,x1],[y1,y2], "color", c);
endfunction

function y = fill_vector(cnt, val = 0)
    y = val(ones(1,cnt));
endfunction

function l = mse(y)
    s = numel(y);
    l = fill_vector(s);
    
    for i = 2:s-1
        for j = 2:i 
            l(i) += ( y(j) - mean(y(1:j)) )^2; 
         endfor; 
         for j = i+1:s-1
            l(i) += ( y(j) - mean(y(j:s)) )^2;
        endfor
    endfor
endfunction