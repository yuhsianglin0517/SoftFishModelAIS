%% Plotting script for ouput of optimisation.
close all
figure('Units','normalized','Position',[0 0.05 1 0.9]); 

plotVars.tmin      = 0;
plotVars.tmax      = tEnd;
plotVars.ymin      = -1;
plotVars.ymax      = 1;
plotVars.fontSize  = 14;
plotVars.lineWidth = 2;
%plotVars.rows      = 5; 
plotVars.rows      = 3;  % exclude thrust and side force
plotVars.colums    = 1;

%% Pressure and Tip Deflection (input)

subplot(plotVars.rows,plotVars.colums,1)
hold on

L1 = plot(data.Time,data.PressureRight,'LineWidth',plotVars.lineWidth);
L1 = plot(data.Time,-data.PressureLeft,'LineWidth',plotVars.lineWidth);

ylabel('Pressure (Pa)');
legend('Left Chamber','Right Chamber','Location','East')
xlabel ('Time (s)'); 
title('Pressure (input data)')
set(gca,'fontsize',plotVars.fontSize)
grid on; grid minor;
% xlim([plotVars.tmin plotVars.tmax]) 

%% Bending Angle

subplot(plotVars.rows,plotVars.colums,2)
hold on

%L1 = plot(data.Time,1e3*data.ResampledYDeflection(:,4),'LineWidth',plotVars.lineWidth);
L1 = plot(data.Time,data.SampledAbsAngle(:,4),'LineWidth',plotVars.lineWidth);
%L1 = plot(output.Time,1e3*output.YDeflection(4,:),'LineWidth',plotVars.lineWidth-1);
L1 = plot(data.Time,output.ResampledAbsoluteAngles(4,:),'LineWidth',plotVars.lineWidth-1);

legend('Experimental/Input Data','Model Prediction','Location','East')
%ylabel('Deflection (mm)');
ylabel('Bending Angle (rad)')
xlabel ('Time (s)'); 
%title('Tip deflection, prediction vs. experiment')
title('Bending Angle, prediciont vs. experiment');
set(gca,'fontsize',plotVars.fontSize)
grid on; grid minor;
% xlim([plotVars.tmin plotVars.tmax]) 

%% Error between experiment and input data

subplot(plotVars.rows,plotVars.colums,3)
hold on
L1 = plot(data.Time,Error(1,:),'LineWidth',plotVars.lineWidth);
L1 = plot(data.Time,Error(2,:),'LineWidth',plotVars.lineWidth);
L1 = plot(data.Time,Error(3,:),'LineWidth',plotVars.lineWidth);
L1 = plot(data.Time,Error(4,:),'LineWidth',plotVars.lineWidth);

%ylabel('RMS Error (rad)');
ylabel('Error (rad)');
xlabel ('time (s)'); 
legend('Joint 1','Joint 2','Joint 3', 'Joint 4', 'Location','East')
title('Error between experiment and input data (bend angles)')
set(gca,'fontsize',plotVars.fontSize)
grid on; grid minor;
%xlim([plotVars.tmin plotVars.tmax]) 

%% Show figure

shg
tightfig
