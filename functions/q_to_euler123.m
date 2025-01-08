function [euler123] = q_to_euler123(qua)
% Form Euler axis and Euler angle from DCM
%
% Input     : qua               4X1 scalar-last attitude unit quaternion
% Output    : euler123          3X1 Euler 1-2-3 sequences


assert(isequal(size(qua), [4, 1]), 'Input attitude quaternion must be 4x1.');

DCM         = q_to_dcm(qua) ; 
euler123    = [ atan2( -DCM(3,2) , DCM(3,3) )   ;
                asin(   DCM(3,1) )              ;
                atan2( -DCM(2,1) , DCM(1,1) )  ];

end
