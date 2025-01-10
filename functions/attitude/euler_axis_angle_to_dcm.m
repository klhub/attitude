function DCM = euler_axis_angle_to_dcm(e_axis, e_angle)
% Form DCM from Euler axis and Euler angle
%
% Input     : e_axis            3X1 unit vector
%             e_angle   rad     sampling interval in seconds
% Output    : DCM               3X3 DCM

assert(isequal(size(e_axis), [3, 1]), 'Input Euler axis must be 3x1.');

ct      = cos(e_angle);
st      = sin(e_angle);
I3      = eye(3);
DCM     = ct*I3 + (1-ct)*e_axis*e_axis' - st*fun_cross(e_axis);

end
