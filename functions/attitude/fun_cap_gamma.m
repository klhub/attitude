function GAMMA = fun_cap_gamma(vec)
% Form the GAMMA matrix from a 3X1 vector
%
% Input : vec, a 3X1 vector

assert(isequal(size(vec), [3, 1]), 'Input vector must be 3x1.');

GAMMA   = [  fun_cross(vec)   vec   ;
            -vec'               0  ];

end