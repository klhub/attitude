function psi = fun_psi(omega, dt)
% Form a psi vectpr from a 3X1 input vector
%
% Input     : omega     rad/s   3X1 body angular rate
%             dt        s       sampling interval in seconds
% Output    : 3X1 psi vector

assert(isequal(size(omega), [3, 1]), 'Input body angular rate must be 3x1.');

omega_norm  = norm(omega);

psi         = sin(omega_norm*dt/2) * omega / omega_norm;

end
