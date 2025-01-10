function OMEGA = fun_cap_omega(vec)
% Form the OMEGA matrix from a 3X1 vector
%
% Input     : vec, a 3X1 vector
% Output    : 4X4 OMEGA matrix

assert(isequal(size(vec), [3, 1]), 'Input vector must be 3x1.');

OMEGA   = [ -fun_cross(vec)   vec   ;
            -vec'               0  ];

end