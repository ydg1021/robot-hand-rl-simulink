




x = out.servo_in.Data(1:123,1);
y = out.goal_position.Data(1:123,1);

x = servo4_new4.servo_in.Data;
y = -(double(servo4_new4.goal_position.Data(:,4))-1023);


ft = fittype('a / (1 + exp(-c*(x-b)))', ...
    'independent', 'x', ...
    'dependent', 'y');
opts = fitoptions('Method', 'NonlinearLeastSquares');
opts.StartPoint = [916, 66, 0.01]; % 시작점은 데이터를 기반으로 적절히 추정
[model, gof] = fit(x, y, ft, opts);

disp(model);

for i = 1:71
plt(i) = nonlinearRegressionModel(x(i));
end
plot(plt)
diff = y-plt';
plot(diff)

coefficients6 = mdl.Coefficients.Estimate;

% 기울기 (slope)
slope6 = coefficients6(2);

% 절편 (intercept)
intercept6 = coefficients6(1);
predict(mdl,10)
%mdl = fitrlinear()
