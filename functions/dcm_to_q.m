function [qua] = dcm_to_q(DCM)
% Form quaternion from DCM
%
% Input     : DCM               3X3 DCM
% Output    : qua               4X1 scalar-last attitude unit quaternion

assert(isequal(size(DCM), [3, 3]), 'Input DCM must be 3x3.');

I3      = eye(3) ;
q_sca   = 0.5 * sqrt( 1 + trace(DCM) ) ; % TODO if q_sca \approx 0 , use method from Sheppard 1978
q_vec   = (1/(4*q_sca)) * [ DCM(2,3) - DCM(3,2)   ;
                            DCM(3,1) - DCM(1,3)   ;
                            DCM(1,2) - DCM(2,1) ] ;

qua = [ q_vec ; q_sca ] ;

end