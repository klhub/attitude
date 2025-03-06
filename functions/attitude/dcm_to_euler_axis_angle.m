function [e_axis, e_angle] = dcm_to_euler_axis_angle(DCM)
% Form Euler axis and Euler angle from DCM
%
% Input     : DCM               3X3 DCM
% Output    : e_axis            3X1 unit vector
%             e_angle   rad     sampling interval in seconds


assert(isequal(size(DCM), [3, 3]), 'Input DCM must be 3x3.');

e_angle = acos( 0.5 * (trace(DCM)-1) );
e_axis  = 1/(2*sin(e_angle)) * [ DCM(2,3) - DCM(3,2)   ;
                                 DCM(3,1) - DCM(1,3)   ;
                                 DCM(1,2) - DCM(2,1) ] ;

end
