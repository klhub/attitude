function [qua_normalize] = q_normalize(qua)
% Normalize input quaternion
%
% Input     : qua               4X1 scalar-last attitude unit quaternion
% Output    : qua_norm          4X1 scalar-last attitude unit quaternion

assert(isequal(size(qua), [4, 1]), 'Input attitude quaternion must be 4x1.');

qua_normalize   = qua / norm(qua) ;

end