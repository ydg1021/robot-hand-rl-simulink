s1_max=max(out.simout.data(:,1));
s1_min=min(out.simout.data(:,1));

s2_max=max(out.simout.data(:,2));
s2_min=min(out.simout.data(:,2));

s3_max=max(out.simout.data(:,3));
s3_min=min(out.simout.data(:,3));

s4_max=max(out.simout.data(:,4));
s4_min=min(out.simout.data(:,4));

s5_max=max(out.simout.data(:,5));
s5_min=min(out.simout.data(:,5));


% Given sensor range and desired output range
sensor_min1 = 510;
sensor_max1 = 560;

sensor_min2 = 442;%464
sensor_max2 = 549;%527

sensor_min3 = 373;%373 373 379
sensor_max3 = 458;%436 443 439

sensor_min4 = 434;%428
sensor_max4 = 548;%538

sensor_min5 = 370;%370
sensor_max5 = 498;%484sensor_min1 = 498;
% sensor_max1 = 565;
% 
% sensor_min2 = 459;%464
% sensor_max2 = 542;%527
% 
% sensor_min3 = 373;%373 373 379
% sensor_max3 = 443;%436 443 439
% 
% sensor_min4 = 433;%428
% sensor_max4 = 531;%538
% 
% sensor_min5 = 386;%370
% sensor_max5 = 470;%484

output_min1 = 0;
output_max1 = 886.6;

output_min2 = 68.2;
output_max2 = 682;%682

output_min3 = 85.25;
output_max3 = 682;%409.2

output_min4 = 988.9;
output_max4 = 409.2;%409.2


output_min5 = 988.9;
output_max5 = 306.9;%409.2

% Calculate Gain and Bias for scaling
gain1 = (output_max1 - output_min1) / (sensor_max1 - sensor_min1)
bias1 = output_min1 - (gain1 * sensor_min1)

gain2 = (output_max2 - output_min2) / (sensor_max2 - sensor_min2)
bias2 = output_min2 - (gain2 * sensor_min2)

gain3 = (output_max3 - output_min3) / (sensor_max3 - sensor_min3)
bias3 = output_min3 - (gain3 * sensor_min3)

gain4 = (output_max4 - output_min4) / (sensor_max4 - sensor_min4)
bias4 = output_min4 - (gain4 * sensor_min4)
gain4 = -gain4


gain5 = (output_max5 - output_min5) / (sensor_max5 - sensor_min5)
bias5 = output_min5 - (gain5 * sensor_min5)
gain5 = -gain5

%%
figure(1)
plot(out.goal_position)
figure(2)
plot(out.present_position)
figure(3)
plot(out.present_velocity)

figure(4)
plot(out.present_load)


