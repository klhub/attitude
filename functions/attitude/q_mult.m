function [qua_A_to_C] = q_mult(qua_B_to_C, qua_A_to_B)
% [qua_A_to_C] = q_mult(qua_B_to_C, qua_A_to_B)
% Multiplies two attitude quaternions
%
% Input     : qua_A_to_B        4X1 scalar-last attitude unit quaternion from Frame A to Frame B
%             qua_B_to_C        4X1 scalar-last attitude unit quaternion from Frame B to Frame C
% Output    : qua_A_to_C        4X1 scalar-last attitude unit quaternion from Frame A to Frame C

assert(isequal(size(qua_A_to_B), [4, 1]), 'Input quaternion B must be 4x1.');
assert(isequal(size(qua_B_to_C), [4, 1]), 'Input quaternion A must be 4x1.');

qua_A_to_C = [ fun_cap_psi(qua_B_to_C) qua_B_to_C ] * qua_A_to_B ;

end