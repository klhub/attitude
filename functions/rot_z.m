function R = rot_z(theta)
% Passive or alias transformation matrix rotation on the z-axis
% Input : theta [rad]

ct  = cos(theta);
st  = sin(theta);

R   = [  ct   st    0   ;
        -st   ct    0   ;
          0    0    1  ];

end
