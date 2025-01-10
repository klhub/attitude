function [e_axis, e_angle] = q_to_euler_axis_angle(qua)
% Form Euler axis and Euler angle from DCM
%
% Input     : qua               4X1 scalar-last attitude unit quaternion
% Output    : e_axis            3X1 unit vector
%             e_angle   rad     sampling interval in seconds


assert(isequal(size(qua), [4, 1]), 'Input attitude quaternion must be 4x1.');

q_vec   = qua(1:3, 1) ;
q_sca   = qua(  4, 1) ;

e_angle = 2 * acos(q_sca) ;
e_axis  = q_vec / sin(e_angle/2) ;

end
