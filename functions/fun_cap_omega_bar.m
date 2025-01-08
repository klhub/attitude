function OMEGA_bar = fun_cap_omega_bar(omega, dt)
% Form the OMEGA_bar matrix from a 3X1 vector
%
% Input     : omega     rad/s   3X1 body angular rate
%             dt        s       sampling interval in seconds
% Output    : 4X4 OMEGA_bar matrix 

assert(isequal(size(omega), [3, 1]), 'Input vector must be 3x1.');

psi         = fun_psi(omega, dt) ;
omega_norm  = norm(omega);
I3          = eye(3);

OMEGA_bar   = [  cos(omega_norm*dt/2)*I3 - fun_cross(psi)   psi                    ;
                -psi'                                       cos(omega_norm*dt/2)  ];

end
