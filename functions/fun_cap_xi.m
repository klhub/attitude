function XI = fun_cap_xi(qua)
% Form the XI matrix from a 4X1 scalar-last attitude quaternion
%
% Input     : qua, a 4X1 attitude quaternion
% Output    : 4X3 XI matrix

assert(isequal(size(qua), [4, 1]), 'Input vector must be 4x1.');

q_sca   = qua(4   ,1);
q_vec   = qua(1:3 ,1);
I3      = eye(3);

XI      = [  q_sca*I3 + fun_cross(q_vec)     ;
            -q_vec'                         ];

end