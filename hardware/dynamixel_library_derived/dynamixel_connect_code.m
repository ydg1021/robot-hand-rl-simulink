% READWRITE Example file initializing the execution of read 
%   and write for 1 or more Dynamixel motors in Simulink
%
%   Part of the Dynamixel library for Matlab and Simulink
%   Author: Georgios Andrikopoulos (geoand@kth.se), 2022
%   Mechatronics & Embedded Control Systems Unit, KTH, Stockholm

clear
close all
clc
addpath(genpath('C:\Users\Yuk\Desktop\2024_03_SPIE\robotis\DynamixelSDK-master\DynamixelSDK-master\c'))
% Set sampling time for Simulink pace execution
Ts = 0.05;

% Set COM port
com_port = 'COM9';

% Set baudrate
baud_rate = 57600;

% Set protocol Version
protocol_version = 2;

% Initialize library and port number
[lib_name, port_num] = initDxl(com_port);

% Open port
openPortDxl(lib_name, port_num);

% Set Baudrate
setBaudDxl(lib_name, port_num, baud_rate);

% Find dynamixels
[motor_IDs, motor_models] = findDxl(lib_name, port_num, protocol_version);

% Check error
checkErrorDxl(lib_name, port_num, protocol_version)


%% End Session
clc 

% Disable torque
torqueDxl(lib_name, port_num, protocol_version, motor_IDs, motor_models, ...
    'Disable');

% Check error
checkErrorDxl(lib_name, port_num, protocol_version)

% Close port 
closePortDxl(lib_name,port_num);