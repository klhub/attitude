function [DCM] = q_to_dcm(qua)
% Form Euler axis and Euler angle from DCM
%
% Input     : qua               4X1 scalar-last attitude unit quaternion
% Output    : DCM               3X3 DCM

assert(isequal(size(qua), [4, 1]), 'Input quaternion must be 4x1.');

DCM = fun_cap_xi(qua)' * fun_cap_psi(qua) ;

end