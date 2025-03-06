% Define Earth's radius in meters (SI units)
radius          = 6371000; % Earth radius in meters

% Load texture image (e.g., a simple equirectangular Earth map)
earthTexture    = imread('earth_texture.jpg'); % Replace with your file path

% Create a sphere to represent the Earth
[phi, theta]    = meshgrid(linspace(0, 2*pi, 100), linspace(0, pi, 50));
x               = radius * sin(theta) .* cos(phi);
y               = radius * sin(theta) .* sin(phi);
z               = radius * cos(theta);

% Normalize the spherical coordinates for texture mapping
u = phi / (2*pi);           % u-coordinate (longitude)
v = (theta - pi/2) / pi;    % v-coordinate (latitude)

% Plotting the Earth with texture mapping in 3D
figure(100);
surf(x, y, z, 'FaceColor', 'texturemap', 'CData', earthTexture);
% shading interp;
axis equal;
title('Earth Globe in J2000 Frame with Texture Mapping');
xlabel('X (meters)');
ylabel('Y (meters)');
zlabel('Z (meters)');

% Set the viewing angle
view(3);

% Optionally, add gridlines and labels for better visualization
grid on;
