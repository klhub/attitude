function mat_x = fun_cross(vec)
% Form a cross-product matrix from a 3X1 input vector
%
% Input : vec, a 3X1 vector

assert(isequal(size(vec), [3, 1]), 'Input vector must be 3x1.');

mat_x   = [      0   -vec(3)    vec(2)   ;
             vec(3)       0    -vec(1)   ;
            -vec(2)   vec(1)        0   ];

end
