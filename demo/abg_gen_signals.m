clear all; close all; clc;

addpath('../base_unit');
addpath('../functions/attitude');

N           = 5000;
x           = linspace(0, pi, N);
truth_pos   =  1000*sin(x);
truth_vel   =  1000*cos(x);
truth_acc   = -1000*sin(x);

noise_pos   =   0.01 * randn(1,5000);
noise_vel   =  22.5  * randn(1,5000);
noise_acc   = 377    * randn(1,5000);
mea_pos_tru = truth_pos + noise_pos ; 
mea_vel_tru = truth_vel + noise_vel ; 
mea_acc_tru = truth_acc + noise_acc ; 

mean(mea_vel_tru - truth_vel)
mean(mea_acc_tru - truth_acc)
std (mea_vel_tru - truth_vel)
std (mea_acc_tru - truth_acc)

mea_vel_fd          = zeros(size(mea_pos_tru));
mea_acc_fd          = zeros(size(mea_pos_tru));
mea_vel_fd(1,2:end) = diff(mea_pos_tru) / mean(diff(x)); 
mea_vel_fd(1,1)     = mea_vel_fd(1,2);
mea_acc_fd(1,2:end) = diff(mea_vel_fd ) / mean(diff(x)); 
mea_acc_fd(1,1)     = mea_acc_fd(1,2);

mean(mea_vel_fd - truth_vel)
mean(mea_acc_fd - truth_acc)
std (mea_vel_fd - truth_vel)
std (mea_acc_fd - truth_acc)

%%
figure;

subplot(3,1,1);
plot(x, truth_pos, 'b', 'LineWidth', 1.5);
grid on
ylabel('Position');
title('Analytical Signal: Position');

subplot(3,1,2);
plot(x, truth_vel, 'r', 'LineWidth', 1.5);
grid on
ylabel('Velocity');
title('Analytical Signal: Velocity');

subplot(3,1,3);
plot(x, truth_acc, 'g', 'LineWidth', 1.5);
grid on
ylabel('Acceleration');
xlabel('x');
title('Analytical Signal: Acceleration');

sgtitle('Truth Position, Velocity, and Acceleration of sin(x)');

%%
figure;

subplot(3,1,1);
plot(x, mea_pos_tru, 'b', 'LineWidth', 1.5);
grid on
ylabel('Position');

subplot(3,1,2);
plot(x, mea_vel_tru, 'r', 'LineWidth', 1.5);
grid on
ylabel('Velocity');

subplot(3,1,3);
plot(x, mea_acc_tru, 'g', 'LineWidth', 1.5);
grid on
ylabel('Acceleration');
xlabel('x');

sgtitle('Truth Measured Position, Velocity, and Acceleration of sin(x)');

%%
figure;

subplot(3,1,1);
plot(x, mea_pos_tru, 'b', 'LineWidth', 1.5);
grid on
ylabel('Position');

subplot(3,1,2);
plot(x, mea_vel_fd , 'r', 'LineWidth', 1.5);
grid on
ylabel('Velocity');

subplot(3,1,3);
plot(x, mea_acc_fd , 'g', 'LineWidth', 1.5);
grid on
ylabel('Acceleration');
xlabel('x');

sgtitle('Truth Measured Position, Finite-Difference Velocity, and Acceleration of sin(x)');
