clc
clear
close all

%% load data

load('feature.mat');
load('label.mat');

%% Shuffling data

Size = size(feature,4);
Pr = randperm(Size);

feature = feature(:,:,:,Pr);
label = label(Pr);

i1 = round(0.7*Size);
i2 = round(0.8*Size);

Xtrain = feature(:,:,:,1:i1);
Ytrain = label(1:i1);

Xval = feature(:,:,:,i1+1:i2);
Yval = label(i1+1:i2);

Xtest = feature(:,:,:,i2+1:end);
Ytest = label(i2+1:end);

%% change format

Y = categorical(label);
Ytrain = categorical(Ytrain);
Yval = categorical(Yval);
Ytest = categorical(Ytest);

%% design network

layers = [ ...
    % input layer
    imageInputLayer([28 28 2])
    
    % first CNN layer
    convolution2dLayer(3,16)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    % Second CNN layer
    convolution2dLayer(3,32)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    % Fully Connected layer
    fullyConnectedLayer(8)
    softmaxLayer
    classificationLayer];

options = trainingOptions('rmsprop', ...
    'MaxEpochs',100,...
    'InitialLearnRate',1e-2, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'ValidationData',{Xval,Yval},...
    'ValidationFrequency',5, ...
    'ValidationPatience',4);

% analyzeNetwork(layers)

%% train network

net = trainNetwork(Xtrain,Ytrain,layers,options);

%% Evaluation

Y_ = predict(net,feature);
Y_tr = predict(net,Xtrain);
Y_vl = predict(net,Xval);
Y_ts = predict(net,Xtest);

[~,Y_]=max(Y_');
Y_ = categorical(Y_);

[~,Y_tr]=max(Y_tr');
Y_tr = categorical(Y_tr);

[~,Y_vl]=max(Y_vl');
Y_vl = categorical(Y_vl);

[~,Y_ts]=max(Y_ts');
Y_ts = categorical(Y_ts);

figure;plotconfusion(Y,Y_,'All');
figure;plotconfusion(Ytrain,Y_tr,'Train');
figure;plotconfusion(Yval,Y_vl,'Validation');
figure;plotconfusion(Ytest,Y_ts,'Test');

