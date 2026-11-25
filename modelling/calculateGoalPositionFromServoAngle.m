function goalPosition = calculateGoalPositionFromServoAngle(servoAngle)
    % 주어진 servo motor의 각도와 goal position 사이의 데이터 포인트
    servoAngleAt0 = 0; % servo motor가 0도 일 때
    goalPositionAt0 = 920; % goal position은 920
    servoAngleAt125 = 125; % servo motor가 125도 일 때
    goalPositionAt125 = 18; % goal position은 18

    % 선형 관계의 기울기와 절편 계산
    slope = (goalPositionAt125 - goalPositionAt0) / (servoAngleAt125 - servoAngleAt0);
    intercept = goalPositionAt0 - (slope * servoAngleAt0);

    % 입력된 servo motor의 각도에 따른 goal position 계산
    goalPosition = (slope * servoAngle) + intercept;
end