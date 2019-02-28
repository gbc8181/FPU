%% main 
n_particles = 62; %% we have 64 particles but 62 can move
dt = 0.5;
t_max = 2000;

%Set alpha and beta
alpha = 0.0; %compute linear
beta = 0.3; %computte nonlinear

%change the initial mode to get different harmonics
init_mode = 1;

amplitude = 10 * sqrt(2.0 / (n_particles + 1));
lamb = 2 / init_mode;

tmp = linspace(0, 1, n_particles + 2);
% if you would like a "sin pull"
x_old = amplitude * 0.8 * sin(2.0 * pi * tmp / 1);

% pull it
%x_old = zeros(n_particles + 2,1); 
%x_old(12) = 1;
%x_old(11) = 0.7;
%x_old(10) = 0.3;
%x_old(13) = 0.7;
%x_old(14) = 0.3;

x = x_old;
x(1) = 0; x(end) = 0; x_old(1) = 0 ; x_old(end) = 0;

pos = linspace(0, n_particles + 2, n_particles + 2);

% initial state

figure('Name','Initial state');
title('Start position of particles');
axis([0, n_particles + 2, -amplitude * 1.1, amplitude * 1.1]);
plot(pos, x, 'o');

%% Computing
t = 0;
i = 1;
dtq = dt^2;
record = [];
while t < t_max
    %calculating new position of particles
    temp_x = x;
    x = (circshift(x, -1) + circshift(x, 1) - 2.0 * x) * dtq     ...
                + alpha * ( (circshift(x, -1) - x).^2 - (x - circshift(x, 1)).^2 ) * dtq  ...
                + beta * ( (circshift(x, -1) - x).^3 - (x - circshift(x, 1)).^3 ) * dtq ...
                + 2.0 * x - x_old;
    x_old = temp_x;                                                                       
    x(1) = 0;
    x(end) = 0;
    
    record(:,i) = x;
    i = i + 1;
    t = t + dt;
end
index_end = i-1;

%% video generate
gcf = figure;
video = VideoWriter('video.mp4');
%set(gcf, 'Renderer', 'painters');

set(gcf, 'Renderer', 'zbuffer'); % if works on windows 10, please activate it.

open(video);
for t = 1:index_end
    plot(record(:,t),'o');
    axis([0, n_particles + 2, -amplitude * 1.1, amplitude * 1.1]);
    F = getframe(gcf); %activate it when you want to record the movie
    writeVideo(video,F);
    %imgs(t) = im2frame(F.cdata); %activate it when you want to record the movie
end
close(video);
% once want to use moive, but it does not work for windows for some reason
% It seems to happen in windows 10 or matlab 2016+
% movie(imgs)


