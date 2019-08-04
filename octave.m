# Prevent Octave from thinking that this is a function file
1;

function draw_line(x1, y1, x2, y2, c = "black")
# usage: draw_line(x1, y1, x2, y2, c = "black")
#
# Draws a line from the coordinate x1/y1 to x2/y2
# with optional color.

    line([x1,x2],[y1,y2], "color", c);
endfunction

function draw_horizontal_line(x1, x2, y, c = "black")
# usage: draw_horizontal_line(x1, x2, y, c = "black")
#
# Draws a horizontal line at y at coordinates from x1 to x2
# with optional color.

    line([x1,x2],[y,y], "color", c);
endfunction

function draw_vertical_line(x, y1, y2, c = "black")
# usage: draw_vertical_line(x, y1, y2, c = "black")
#
# Draws a vertical line at coordinate x from y1 to y2
# with optional color.

    line([x,x],[y1,y2], "color", c);
endfunction

function y = fill_vector(cnt, val = 0)
# usage: y = fill_vector(cnt, val = 0)
#
# Fills a vector 'y' with 'cnt' elements of value 'val'.

    y = val(ones(1,cnt));
endfunction

function l = mse(y)
# usage: l = mse(y)
#
# Fills a vector 'l' with the sliding mean square error from
# vector 'y'.

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