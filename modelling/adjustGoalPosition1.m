function adjusted_goal_position = adjustGoalPosition1(servo_angle, initial_goal_position, initial_present_position)
    % 비선형 회귀 모델 파라미터
    a = 951.8; b = 39.32; c = -0.1098;
    % 서보 모터 각도에 따른 goal position의 하한선 계산
    lower_bound = a / (1 + exp(-c*(servo_angle-b)))

    % 초기 목표 위치 조정
    if lower_bound <= initial_present_position
        adjusted_goal_position = max(lower_bound, initial_goal_position);
    else
        adjusted_goal_position = initial_goal_position;
    end
end