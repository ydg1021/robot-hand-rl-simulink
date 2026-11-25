time = out.tout;

goal_position = double(out.goal_position.Data);
present_position = double(out.present_position.Data);
present_load = double(out.present_load.Data);
present_velocity = double(out.present_velocity.Data);
servo = double(out.servo.Data);

diff_pos = abs(goal_position - present_position);

subplot(2,1,1)
plot(time,diff_pos);
subplot(2,1,2)
plot(time,pro_present_load);
% load
for n = 1:5
    for i = 1:length(present_load)
    
        if present_load(i,n)>=1024
            pro_present_load(i,n) = -(present_load(i,n) - 1024);
        else
            pro_present_load(i,n) = present_load(i,n);
        
        end
    end
end
pro_present_load = pro_present_load*0.0977;      

a= {(79,-61.441),(5,-6.0574),(1,-4.4942)};
b= [(9,-8.4022),(60,-47.4822),(7,-6.839)];
c= [(43,-32.6318),(47,-35.7582),(18,-15.4366)];
d= [(57,43.5742),(98,73.275),(27,24.0342)];
e= [(0,5.2758),(28,23.2526),(0,3.7126)];

x1 = [79, 9, 43, 57, 0];
y1 = [-61.441, -8.4022, -32.6318, 43.5742, 5.2758];

x2 = [5, 60, 47, 98, 28];
y2 = [-6.0574, -47.4822, -35.7582, 73.275, 23.2526];

x3 = [1, 7, 18, 27, 0];
y3 = [-4.4942, -6.839, -15.4366, 24.0342, 3.7126];

scatter(x1(1),y1(1))
hold on
scatter(x1(2),y1(2))
scatter(x1(2),y1(3))












