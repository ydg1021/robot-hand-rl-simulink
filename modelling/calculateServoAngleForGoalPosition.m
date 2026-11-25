function servoAngle = calculateServoAngleForGoalPosition(currentPresentPosition, goalPosition)
    % 주어진 servo motor의 각도와 goal position 사이의 선형 관계를 기반으로 한 계수
    servoAngleAt0 = 0;
    goalPositionAt0 = 920;
    servoAngleAt125 = 125;
    goalPositionAt125 = 18;

    % 선형 관계 계수 계산 (기울기와 절편)
    slope = (goalPositionAt125 - goalPositionAt0) / (servoAngleAt125 - servoAngleAt0);
    intercept = goalPositionAt0 - slope * servoAngleAt0;

    % 현재 present position과 goal position 사이의 차이 계산
    positionDifference = goalPosition - currentPresentPosition;

    % 목표 goal position을 달성하기 위해 필요한 goal position 계산
    targetGoalPosition = currentPresentPosition + positionDifference;

    % 목표 goal position에 도달하기 위한 servo motor의 각도 계산
    servoAngle = (targetGoalPosition - intercept) / slope;

    % 결과 반환
    if servoAngle < 0
        servoAngle = 0;
    elseif servoAngle > 125
        servoAngle = 125;
    end
end