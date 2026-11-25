% Dynamixel 모터와 통신하기 위한 시리얼 포트 설정
portNum = 'COM7'; % 사용하는 시리얼 포트에 맞게 설정
baudRate = 57600; % Dynamixel 모터의 보드레이트에 맞게 설정
serialPort = serial(portNum, 'BaudRate', baudRate);

% 시리얼 포트 열기
fopen(serialPort);

% Dynamixel 명령어와 주소 정의
DXL_ID = 3; % 모터 ID
ADDR_MX_TORQUE_ENABLE = 24; % 토크 활성화 주소
ADDR_MX_GOAL_POSITION = 30; % 목표 위치 주소
ADDR_MX_PRESENT_POSITION = 37; % 현재 위치 주소

% 토크 활성화
writeByte(serialPort, DXL_ID, ADDR_MX_TORQUE_ENABLE, 1);

% 목표 위치 설정
goalPosition = 512; % 0 ~ 1023 범위 내에서 설정
writeWord(serialPort, DXL_ID, ADDR_MX_GOAL_POSITION, goalPosition);

% 잠시 기다린 후 현재 위치 읽기
pause(2); % 2초 대기
presentPosition = readWord(serialPort, DXL_ID, ADDR_MX_PRESENT_POSITION);

% 결과 출력
fprintf('현재 위치: %d\n', presentPosition);

% 통신 종료
fclose(serialPort);
delete(serialPort);
fclose(instrfind);
clear serialPort;

