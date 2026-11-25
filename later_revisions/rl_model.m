Ts = 0.05;
Tf = 17;
numObs = 5;
obsInfo = rlNumericSpec([5 1], ...
    'LowerLimit',[-inf -inf -inf -inf -inf]', ...
    'UpperLimit',[inf inf inf inf inf]') % body_acc, f_spring, sus_disp, f_damp, road)
actInfo1 = rlNumericSpec([1 1],'LowerLimit',0,'UpperLimit',125)
actInfo2 = rlNumericSpec([1 1],'LowerLimit',70,'UpperLimit',180)
mdl = "reinforcemen_model4";



obsInfo.Name = 'observations';
actInfo1.Name = 'servo1';
actInfo2.Name = 'servo2to5';

blks = mdl + ["/RL Agent1","/RL Agent2","/RL Agent3","/RL Agent4","/RL Agent5"];

env = rlSimulinkEnv(mdl,blks,{obsInfo,obsInfo,obsInfo,obsInfo,obsInfo},{actInfo1,actInfo2,actInfo2,actInfo2,actInfo2});
rng(0)
%%

    statePath = [
        featureInputLayer(numObs,'Normalization','none','Name','observation')
        fullyConnectedLayer(100,'Name','CriticStateFC1')
        reluLayer('Name', 'CriticRelu1')
        fullyConnectedLayer(100,'Name','CriticStateFC2')];
    actionPath = [
        featureInputLayer(1,'Normalization','none','Name','action')
        fullyConnectedLayer(100,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
    commonPath = [
        additionLayer(2,'Name','add')
        sigmoidLayer
        fullyConnectedLayer(50)
        sigmoidLayer
        fullyConnectedLayer(1,'Name','CriticOutput')];

    criticNetwork = layerGraph();
    criticNetwork = addLayers(criticNetwork,statePath);
    criticNetwork = addLayers(criticNetwork,actionPath);
    criticNetwork = addLayers(criticNetwork,commonPath);
    
    criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
    criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
    criticNetwork = dlnetwork(criticNetwork);
% figure
% plot(layerGraph(criticNetwork))
% plot(layerGraph(actorNetwork))


    actorNetwork1 = [
        featureInputLayer(numObs,'Normalization','none','Name','observation')
        fullyConnectedLayer(100,'Name','ActorFC1')
        tanhLayer
        fullyConnectedLayer(100,'Name','ActorFC2')
        tanhLayer
        fullyConnectedLayer(50,'Name','ActorFC3')
        tanhLayer('Name','ActorTanh')
        fullyConnectedLayer(1,'Name','ActorFC4')
        tanhLayer('Name','ActorTanh2')
        scalingLayer('Name','ActorScaling','Scale',62.5,'bias',62.5)];
    actorNetwork1 = dlnetwork(actorNetwork1);

    actorNetwork2 = [
        featureInputLayer(numObs,'Normalization','none','Name','observation')
        fullyConnectedLayer(100,'Name','ActorFC1')
        tanhLayer
        fullyConnectedLayer(100,'Name','ActorFC2')
        tanhLayer
        fullyConnectedLayer(50,'Name','ActorFC3')
        tanhLayer('Name','ActorTanh')
        fullyConnectedLayer(1,'Name','ActorFC4')
        tanhLayer('Name','ActorTanh2')
        scalingLayer('Name','ActorScaling','Scale',55,'bias',125)];
    actorNetwork2 = dlnetwork(actorNetwork2);

idx = 1;
    critic(idx) = rlQValueFunction(criticNetwork,obsInfo,actInfo1,'ObservationInputNames','observation','ActionInputNames','action',UseDevice="gpu");
    actor(idx) = rlContinuousDeterministicActor(actorNetwork1,obsInfo,actInfo1,UseDevice="gpu");
for idx = 2:5
    critic(idx) = rlQValueFunction(criticNetwork,obsInfo,actInfo2,'ObservationInputNames','observation','ActionInputNames','action',UseDevice="gpu");
    actor(idx) = rlContinuousDeterministicActor(actorNetwork2,obsInfo,actInfo2,UseDevice="gpu");
end

criticOpts = rlOptimizerOptions('LearnRate',1e-03,'GradientThreshold',1);
actorOpts = rlOptimizerOptions('LearnRate',1e-04,'GradientThreshold',1);



agentOpts = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'CriticOptimizerOptions',criticOpts,...
    'ActorOptimizerOptions',actorOpts,...
    'ExperienceBufferLength',1e6,...
    'ResetExperienceBufferBeforeTraining',true,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',64);
agentOpts.NoiseOptions.Variance = 0.6;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;


agentA = rlDDPGAgent(actor(1),critic(1),agentOpts);
agentB = rlDDPGAgent(actor(2),critic(2),agentOpts);
agentC = rlDDPGAgent(actor(3),critic(3),agentOpts);
agentD = rlDDPGAgent(actor(4),critic(4),agentOpts);
agentE = rlDDPGAgent(actor(5),critic(5),agentOpts);

maxepisodes = 10000;
maxsteps = ceil(Tf/Ts);

trainOpts = rlMultiAgentTrainingOptions(...
    "AgentGroups",{1,[2,3,4,5]},...
    "LearningStrategy",["decentralized","centralized"],...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',400,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',0,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-10);

doTraining = true;
if doTraining
    % Train the agent.
    trainingStats = train([agentA,agentB,agentC,agentD,agentE],env,trainOpts);
else
    % Load the pretrained agent for the example.
    % load('rl.mat','[agentA,agentB,agentC,agentD,agentE]')
end