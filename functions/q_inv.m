function [qua_inv] = q_inv(qua)
% Output quaternion inverse
%
% Input     : qua               4X1 scalar-last attitude unit quaternion
% Output    : qua_inv           4X1 scalar-last attitude unit quaternion

assert(isequal(size(qua), [4, 1]), 'Input attitude quaternion must be 4x1.');

q_vec   = qua(1:3, 1);
q_sca   = qua(  4, 1);

qua_inv = [ -q_vec ; q_sca ] ;

end