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
# Returns a vector 'y' with 'cnt' elements of value 'val'.

    y = val(ones(1,cnt));
endfunction

function idx = idx_min(y)
# usage: idx = idx_min(y)
#
# Returns the index 'idx' within 'y' holding the minimum value.

    [v, i] = min(y);
    idx = i;
endfunction

function idx = idx_max(y)
# usage: idx = idx_max(y)
#
# Returns the index 'idx' within 'y' holding the maximum value.

    [v, i] = max(y);
    idx = i;
endfunction

function d = diff2(y, r = 0)
# usage: d = diff2(y, r = 0)
#
# Computes the differiantial equation of y with radius r.

    if (r == 0)
        d = [0, diff(y)];
        return;
    endif

    [row, col] = size(y);
    dd = zeros(1,col-2*r);
    dd = y(1+2*r:end) - y(1:end-2*r);
    d = [zeros(1,r), dd, zeros(1,r)];
endfunction

function l = mse(y)
# usage: l = mse(y)
#
# Returns a vector 'l' with the sliding mean square error from
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

function fn_list = get_files_from_dir(d, fp)
# usage: fn_list = get_files_from_dir(d, fp)
#
# Returns a file name list from a given directory d according file pattern fp.

    fn_list = glob(strcat(d, fp));
endfunction