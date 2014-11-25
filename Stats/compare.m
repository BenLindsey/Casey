forestConfusion = confusionmatrix();
netConfusion = confusionmatrix();

for fold=1:10,
    % Split into training and test sets.
    trainInputs = x;
    trainInputs(fold:10:end, :) = [];
    trainOutputs = y;
    trainOutputs(fold:10:end) = [];
    
    testInputs = x(fold:10:end, :);
    testOutputs = y(fold:10:end);
    
    % Test the decision tree.
    f = forest(trainInputs, trainOutputs);
    forestConfusion.updateFromForest(f, testInputs, testOutputs);
    
    % Test the neural network.
    hiddenNeurons = 26;
    deltaInc = 1.4217;
    deltaDec = 0.5094;
    rng(1001, 'twister');
    net = feedforwardnet(hiddenNeurons, 'trainrp');
    [tI, tO] = ANNdata(trainInputs, trainOutputs);
    net = configure(net, tI, tO);
    net.trainParam.delt_inc = deltaInc;
    net.trainParam.delt_dec = deltaDec;
    valInd = fold:10:size(tI, 2);
    trainInd = (1:size(tI, 2));
    trainInd(valInd) = [];
    net.divideFcn = 'divideind';
    net.divideParam.trainInd = trainInd;
    net.divideParam.valInd = valInd;
    net.divideParam.testInd = [];
    net = train(net, tI, tO);
    netConfusion.updateFromNet(net, testInputs, testOutputs);
end

fprintf('Decision tree:\n');
disp(forestConfusion.Matrix);
disp(forestConfusion.getAccuracy());

fprintf('Neural network:\n');
disp(netConfusion.Matrix);
disp(netConfusion.getAccuracy());
