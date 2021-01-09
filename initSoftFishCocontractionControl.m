% Variable initialisation for model optimisation
% The setting of initailization function is in the model properties
% callbacks InitFcn
clc;
close all;
clear all;
%% Control Setpoints (arbitrary)

Setpoint1 = 0.7; % first value
SwitchTime1 = 15; % first step time in seconds
Setpoint2 = 1.4; % second value
SwitchTime2 = 25; % second step time
Setpoint3 = 0.5; % final value
NoiseLevel = 0.05; % noise - generated as a uniform random number

%% Robot parameters
% Unit: MKS
robotMass     = 2*42e-3; % total mass of robot (assumed evenly distributed along the length)
robotLength   = 112e-3*1.25;  % length of robot (only silicone chambers, not fin, in the air; one segment of fin in the water)
robotPressure = 1e5;    % input pressure

% Visual properties
robotChamberColor  = [252, 252, 250]/255;
%robotChamberHeight = 1.5e-2;
robotChamberHeight = 2e-2;
robotChamberWidth  = 3e-2;
robotFinColor = [77, 77, 75]/255;
robotFinHeight = 7e-2; 
robotFinWidth  = 0.52*1e-3; %0.52mm

% Parameters for hydrodynamic model according to Lighthill
rho = 1e3; % fluid density [kg/m^3]
gamma = 0.148; % correction factor (check Azuma book page 169)
A33 = 0.25 * rho * pi * robotFinHeight * gamma;

%% Model Parameters

modelElements = 5; % number of segments to discretise model into (i.e. 3 segments = 2 hinges)
% note that this is fixed in the current implementation, we can change to a
% flexible implementation in the future.

robotBlockLength = robotLength/modelElements;
robotBlockRevoluteRadius = 0.5 * robotBlockLength;
finYoungsModul = 1240 * 1e6; % 1240 MPa
I = robotFinWidth^3*robotFinHeight/12;
robotFinStiffness = finYoungsModul * I / (2*robotBlockLength);

%% Input optimized data
freq = 1; 
overlap = 0;  % in percentage[%]
              % negative: dead time 
              % positive: overlap
if overlap >= 0
    overlap_str = ['OVER' num2str(100*overlap)];
else
    overlap_str = ['DEAD' num2str(100*abs(overlap))];
end
pressure = 1;
% TrainingDataName = ['TrainingData\20200825\TrainingData_Air_' num2str(10*freq) 'cHz_' num2str(10*pressure) 'cbar_' overlap_str];
% load(TrainingDataName)

OptimizedModel = ['optimizedModel_Air_10cHz_10cbar_OVER0'];
load(OptimizedModel);

%% Simulation Parameteres

tEnd = max(data.Time); % simulation duration in seconds (matched to data duration)
seriesPressure = pressure * 1e5 * ones(length(data.Time),1); % change unit from bar to Pa
inputPressure = [data.Time' seriesPressure];

seriesFrequency = 1 * ones(length(data.Time), 1);
inputFrequency = [data.Time' seriesFrequency];

inputPressureLeft = [data.Time' data.PressureLeft'];
inputPressureLeftNormalized = inputPressureLeft / pressure;
inputPressureRight = [data.Time' data.PressureRight'];
inputPressureRightNormalized = inputPressureRight / pressure;

%% No code executes, only variable set up.