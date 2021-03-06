%% Optimisation script for soft fish model
clc;
clear all;
%% Parameters from most recent optimisation

load optimizedModel_Air_10cHz_10cbar_OVER0
modelStiffness           = pFinal(1);
modelDamping             = pFinal(2);
modelPressureCoefficient = pFinal(3);
modelPressureStiffness   = pFinal(4);
modelPressureLag         = pFinal(5);

%% Simulate fish with the pressure input from 'data'
% N.B sim command runs the 'VariableInitialisation' script.
out = sim('SoftFishCocontraction');

output.BendAngles      = out.angles.signals.values';
% output.Thrust          = out.thrust.signals.values';
% output.Sideforce       = out.sideforce.signals.values';
output.AbsoluteAngles  = [output.BendAngles(1,:)*0; cumsum(output.BendAngles,1)];
output.YDeflection     = cumsum((robotLength/modelElements)*sin(output.AbsoluteAngles),1);
output.XDeflection     = cumsum((robotLength/modelElements)*cos(output.AbsoluteAngles),1);
output.Time            = out.tout';

% resample onto new timebase
output.ResampledXDeflection = interp1(output.Time',output.XDeflection',data.Time)';
output.ResampledYDeflection = interp1(output.Time',output.YDeflection',data.Time)';
output.ResampledAbsoluteAngles = interp1(output.Time', output.AbsoluteAngles', data.Time)';
data.ResampledYDeflection = interp1(data.XDeflection(1,:)',data.YDeflection',output.ResampledXDeflection(:,1))';

% calculate sum of errors
Error      = ((data.SampledAbsAngle' - output.ResampledAbsoluteAngles).^2);%.^0.5;
RMSError   = sum(Error,'all');
%% Run Plotting script
run plotOutput