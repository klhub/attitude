% A simple simulation of a full rotation in 1.5 hours along the z-axis

clc; clear all; close all;

addpath('base_unit');
addpath('functions/attitude');
% addpath('models/sensors');
% addpath('sim_satellite');

sim_final   = 1.5 * C_HR ;
dt          = 1   * C_SEC ;

n           = sim_final/dt ; 

t_vec       = 0 : dt : n-1 ;
q_vec       = zeros(4, n) ;
q_vec(:,1)  = [0 0 0 1]' ;
omega_vec   = [ 0*ones(1,n)                          ;
                0*ones(1,n)                          ;
                360*C_DEG/(90*C_MIN)*dt*ones(1,n)   ];
euler123_vec      = zeros(3, n) ;
euler123_vec(:,1) = q_to_euler123(q_vec(:,1)) ;

for ii=2:n
    q_vec(:,ii)         = fun_cap_omega_bar( omega_vec(:,ii-1) , dt) * q_vec(:,ii-1) ;
    euler123_vec(:,ii)  = q_to_euler123( q_vec(:,ii) ) ;
end

figure(1)
subplot(411)
plot(t_vec/C_MIN , q_vec(1,:))
ylim([-1 1])
ylabel('q_1')
title('Attitude Quaternion')
subplot(412)
plot(t_vec/C_MIN , q_vec(2,:))
ylim([-1 1])
ylabel('q_2')
subplot(413)
plot(t_vec/C_MIN , q_vec(3,:))
ylim([-1 1])
ylabel('q_3')
subplot(414)
plot(t_vec/C_MIN , q_vec(4,:))
ylim([-1 1])
ylabel('q_4')
xlabel('Time, Min')

figure(2)
subplot(311)
plot( t_vec/C_MIN , euler123_vec(1,:)/C_DEG )
ylim([-180 180])
ylabel('roll, deg')
title('Euler123 Angles')
subplot(312)
plot( t_vec/C_MIN , euler123_vec(2,:)/C_DEG )
ylim([-180 180])
ylabel('pitch, deg')
subplot(313)
plot( t_vec/C_MIN , euler123_vec(3,:)/C_DEG )
ylim([-180 180])
ylabel('yaw, deg')
xlabel('Time, Min')
