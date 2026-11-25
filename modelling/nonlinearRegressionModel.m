function goal = nonlinearRegressionModel(servo)
    % 학습된 모델 파라미터
    a = 756; % 예시 값
    b = 28.73; % 예시 값
    c = -0.1959; % 예시 값
   

    % 비선형 회귀 모델을 이용한 로드 값 계산
    goal = a / (1 + exp(-c*(servo-b)));
end