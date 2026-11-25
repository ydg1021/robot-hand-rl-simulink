linearModel = fitlm(double(out.pos_diff.Data(:,1)),double(out.present_load.Data(:,1)));
linearModel2 = fitlm(double(out.pos_diff.Data(:,2)),double(out.present_load.Data(:,2)));
linearModel3 = fitlm(double(out.pos_diff.Data(:,3)),double(out.present_load.Data(:,3)));
linearModel4 = fitlm(double(out.pos_diff.Data(:,4)),double(out.present_load.Data(:,4)));
linearModel5 = fitlm(double(out.pos_diff.Data(:,5)),double(out.present_load.Data(:,5)));

coefficients1 = linearModel.Coefficients.Estimate;

% 기울기 (slope)
slope1 = coefficients1(2);

% 절편 (intercept)
intercept1 = coefficients1(1);

coefficients2 = linearModel2.Coefficients.Estimate;

% 기울기 (slope)
slope2 = coefficients2(2);

% 절편 (intercept)
intercept2 = coefficients2(1);

coefficients3 = linearModel3.Coefficients.Estimate;

% 기울기 (slope)
slope3 = coefficients3(2);

% 절편 (intercept)
intercept3 = coefficients3(1);

coefficients4 = linearModel4.Coefficients.Estimate;

% 기울기 (slope)
slope4 = coefficients4(2);

% 절편 (intercept)
intercept4 = coefficients4(1);

coefficients5 = linearModel5.Coefficients.Estimate;

% 기울기 (slope)
slope5 = coefficients5(2);

% 절편 (intercept)
intercept5 = coefficients5(1);

pred_load_1 = slope1*double(out.pos_diff.Data(:,1))+intercept1;
pred_load_2 = slope2*double(out.pos_diff.Data(:,2))+intercept2;
pred_load_3 = slope3*double(out.pos_diff.Data(:,3))+intercept3;
pred_load_4 = slope4*double(out.pos_diff.Data(:,4))+intercept4;
pred_load_5 = slope5*double(out.pos_diff.Data(:,5))+intercept5;
figure
subplot(5,1,1)
plot(pred_load_1)
hold on
plot(out.present_load.Data(:,1))
hold off
subplot(5,1,2)
plot(pred_load_2)
hold on
plot(out.present_load.Data(:,2))
hold off
subplot(5,1,3)
plot(pred_load_3)
hold on
plot(out.present_load.Data(:,3))
hold off
subplot(5,1,4)
plot(pred_load_4)
hold on
plot(out.present_load.Data(:,4))
hold off
subplot(5,1,5)
plot(pred_load_5)
hold on
plot(out.present_load.Data(:,5))
hold off