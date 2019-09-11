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

function convert_tr_offline_csv(fn_in)
# usage: convert_tr_offline_csv(fn_in, fn_out)
#
# Convert output of TR offline csv in standard profile csv and save it.

    s = strsplit (fn_in, ".");
    fn_out = strcat(s{1}, "_ptb.", s{2});

    M = dlmread(fn_in, ";");

    r = columns(M);
    printf("Found matrix with columns %i\n", r);
 
    N(1,:) = [0:r-1];
    N(2,:) = M(2, :) * 10;   # Height 10 um in um
    N(3,:) = M(3, :) * -10;  # Height 10 um in um
 
    plot(N(1,:), N(2,:), N(3,:));
 
    dlmwrite (fn_out, N, ";");
endfunction

function convert_bf_csv(fn_in)
# usage: convert_bf_csv(fn_in)
#
# Convert output of beadfiller csv in standard profile csv and save it.

    s = strsplit (fn_in, ".");
    fn_out = strcat(s{1}, "_ptb.", s{2});
    
    m = dlmread(fn_in, ";");
    
    if (rows(m) > 1)
        error("Only vector as input is allowed!");
    endif
    
    turn_idx = 0;
    i=1;
    while (i <= columns(m)-2)
        if(m(i+2) < m(i))
            turn_idx = i;
            printf("Found turn point at i/m(i)/m(i+1) %i/%f/%f\n", turn_idx, m(turn_idx), m(turn_idx+1));
            break;
        endif;
        i = i+2;
    endwhile;
    
    m1 = m(1:turn_idx-1);
    m2 = m(turn_idx:end);
    
    printf("Found vector length m1/m2 %i/%i\n", columns(m1), columns(m2));
        
    x1 = round(m1(1:2:end) * 10);   # Position to index
    z1 = round(m1(2:2:end) * 1000); # Height mm to um
    
    printf("Vector length x1/z1 %i/%i\n", columns(x1), columns(z1));
        
    if (columns(x1) != columns(z1))
        error("Vector size of x1 and z1 do not match!");
    endif
    
    x2 = round(flip(m2(1:2:end)) * 10);   # Position to index
    z2 = round(flip(m2(2:2:end)) * 1000); # Height mm in um
    
    printf("Vector length x2/z2 %i/%i\n", columns(x2), columns(z2));
    
    if (columns(x2) != columns(z2))
        error("Vector size of x2 and z2 do not match!");
    endif
        
    if (columns(x1) >= columns(x2))
        xx1 = x1(1:columns(x2));
        zz1 = z1(1:columns(x2));
        xx2 = x2;
        zz2 = z2;
    else
        xx1 = x1;
        zz1 = z1;
        xx2 = x2(1:columns(x1));
        zz2 = z2(1:columns(x1));
    endif
        
    printf("Found point set at x1/z1 (%i/%i) (%i/%i) and x2/z2 (%i/%i) (%i/%i)\n",
           xx1(1), zz1(1), xx1(end), zz1(end), xx2(1), zz2(1), xx2(end), zz2(end));
    
    plot(xx1, zz1, xx2, zz2);
    
    M(1,:) = xx1;
    M(2,:) = zz1;
    M(3,:) = zz2;
    
    dlmwrite (fn_out, M, ";");
endfunction