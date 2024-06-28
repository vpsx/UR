clc;
clear;

% Sample code to plot the force
plot_zforce(50)

function plot_zforce(W)
% Retrieve the data from the .csv
data_title = strcat("weight_",num2str(W),"g.csv");
data = readmatrix(data_title);
time = data(:,1) - data(1,1);
zforce = -data(:,70); % You may have to negate the force depending on the direction of the force

% The data sample freq at default is 100Hz!
avg_starting_force = mean(zforce(1:50));

% This is the column idx if you did not change the file outputs that will 
% read the z-force. The force at the tip (or TCP "Tool Center Point" is the
% end effector of the robot)
% To calibrate the force, make sure that you start your data collection
% without any external forces and end your data collection by removing the
% load!
zforce = zforce - avg_starting_force;

% Uncomment this function to remove noise from the data, the last arg has
% to be an odd number. The higher the number, the less noise. However,
% check that you are removing critical values of the data or it is not
% overfiltering the data.
zforce = sgolayfilt(zforce,1,153);

plot_title = strcat("Weight: ",num2str(W),"g"," Expected peak force:",num2str(W./1000 * 9.81),"N");

% Plot the output force
plot(time, zforce)
xlabel("Time (s)")
ylabel("Force (N)")
title(plot_title)
end
