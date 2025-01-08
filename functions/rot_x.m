function R = rot_x(theta)
% Passive or alias transformation matrix rotation on the x-axis
% Input : theta [rad]

ct  = cos(theta);
st  = sin(theta);

R   = [   1    0    0   ;
          0   ct   st   ;
          0  -st   ct  ];

end
