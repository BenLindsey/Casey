% TODOS:
%   * Use parfor to calculate the classification errors.
%   * Adjust significance level to answer question 2.
%   * Check that ttest2 is the right function.
%   * Check that getClassifications in the confusion matrix is correct.

treeIndex = 1;
netIndex = 2;
cbrIndex = 3;

if exist('classifications', 'var') ~= 1
classifications = zeros(10, 3, 6); % Fold, algorithm, emotion.
for fold=1:10,
    fprintf('Fold %d:\n', fold);
    
    % Split into training and test sets.
    trainInputs = x;
    trainInputs(fold:10:end, :) = [];
    trainOutputs = y;
    trainOutputs(fold:10:end) = [];
    
    testInputs = x(fold:10:end, :);
    testOutputs = y(fold:10:end);
    
    % Train and test the decision tree.
    fprintf('\tDecision tree: Training ... ');
    f = forest(trainInputs, trainOutputs);
    fprintf('Testing ... ');
    forestConfusion = confusionmatrix();
    forestConfusion.updateFromForest(f, testInputs, testOutputs);
    classifications(fold, treeIndex, :) = forestConfusion.getClassifications();
    fprintf('Done\n');
    
    % Test the neural network with the best parameters.
    fprintf('\tNeural net: Training ... ');
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
    fprintf('Testing ... ');
    netConfusion = confusionmatrix();
    netConfusion.updateFromNet(net, testInputs, testOutputs);
    classifications(fold, netIndex, :) = netConfusion.getClassifications();
    fprintf('Done.\n');
    
    % Test the case based reasoning.
    fprintf('\tCBR: Training ... ');
    cbr = CBRinit(trainInputs, trainOutputs);
    fprintf('Testing ... ');
    cbrConfusion = confusionmatrix();
    cbrConfusion.update(cbr, testInputs, testOutputs);
    classifications(fold, cbrIndex, :) = cbrConfusion.getClassifications();
    fprintf('Done.\n');
end
else
    fprintf('Previous classifications found - skipping training and testing.\n');
end

% Test for any significant differences between the algorithms.
results = zeros(3, 6);
treeNetIndex = 1;
treeCbrIndex = 2;
NetCbrIndex = 3;
for emotion=1:6,
    results(treeNetIndex, emotion) = ttest2(classifications(:, treeIndex, emotion), classifications(:, netIndex, emotion));
    results(treeCbrIndex, emotion) = ttest2(classifications(:, treeIndex, emotion), classifications(:, cbrIndex, emotion));
    results(NetCbrIndex, emotion) = ttest2(classifications(:, netIndex, emotion), classifications(:, cbrIndex, emotion));
end

printmat(results, 'Results', 'Tree-Net Tree-CBR Net-CBR', 'Anger Disgust Fear Happiness Sadness Surprise');
