%%  MATLAB Code to Generate and Train DNN 
%   Note: MATLAB Communications toolbox is required for this code to work
%   These codes are to accompany the following manuscript:
%   Streamlined Magnetic Resonance Fingerprinting: Fast Whole-brain Coverage with Deep-learning Based Parameter Estimation
%   NeuroImage 2021
%   DOI: TBD
%   Please send your comments and questions to:
%   Mahdi Khajehim, mahdi.khajehim@mail.utoronto.ca, mahdi.khajehim@gmail.com
%   Spring 2021
%% Noise specification for DNN Training
SNR_Training=16:4:24;
Noise_Train_Repeats=1;
%% Normalizing the parameters for DNN training
T1_range=(T1_range0-min(T1_range0))/(max(T1_range0)-min(T1_range0));

T2_range=(T2_range0-min(T2_range0))/(max(T2_range0)-min(T2_range0));

B1_range=(B1_range0-min(B1_range0))/(max(B1_range0)-min(B1_range0));

%% Generation of the X Training Data

XTrain=xtrain_prep(SNR_Training,Noise_Train_Repeats,T1_range,T2_range,B1_range,Dictionary);

%% Generation of the Y Training Data

YTrain=ytrain_prep(SNR_Training,Noise_Train_Repeats,T1_range,T2_range,B1_range);

%% Deep neural network specifications

layer = sequenceInputLayer(200,'Name','seq1');

inputSize = 200;

layers = [ ...
    sequenceInputLayer(inputSize)
    fullyConnectedLayer(128,'WeightLearnRateFactor',0.1)
    reluLayer
    fullyConnectedLayer(64,'WeightLearnRateFactor',0.1)
    reluLayer
    fullyConnectedLayer(3,'WeightLearnRateFactor',0.1)
    regressionLayer];

options = trainingOptions('adam',...
    'MaxEpochs',100,...
    'MiniBatchSize' , 1024, ...
    'InitialLearnRate',0.001,...
    'Plots','training-progress');
%% Training the Deep Neural Network

net = trainNetwork(XTrain,YTrain,layers,options);