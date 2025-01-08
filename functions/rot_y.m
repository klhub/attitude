function R = rot_y(theta)
% Passive or alias transformation matrix rotation on the y-axis
% Input : theta [rad]

ct  = cos(theta);
st  = sin(theta);

R   = [  ct    0  -st   ;
          0    1    0   ;
         st    0   ct  ];

end
