% TODOS:
%   * Adjust significance level to answer question 2. (3 or 30?)
%   * Check that getClassifications in the confusion matrix is correct.
%   * Is it correct to train each algorithm? The submitted structures were
%     trained on the entire data set.

treeIndex = 1;
netIndex = 2;
cbrIndex = 3;

if exist('classifications', 'var') ~= 1
classifications = cell(10, 1); % Classifications per fold.
fprintf('Completed folds:');
parfor fold=1:10,
    classifications{fold} = zeros(3, 6); % Algorithm, emotion.
    
    % Split into training and test sets.
    testIndexes = fold:10:size(x, 1);
    trainInputs = x;
    trainInputs(fold:10:end, :) = [];
    trainOutputs = y;
    trainOutputs(fold:10:end) = [];
    testInputs = x(fold:10:end, :);
    testOutputs = y(testIndexes); % Doesn't compile unless the index is extracted?
    
    % Train and test the decision tree.
    f = forest(trainInputs, trainOutputs);
    forestConfusion = confusionmatrix();
    forestConfusion.updateFromForest(f, testInputs, testOutputs);
    classifications{fold}(treeIndex, :) = forestConfusion.getClassifications();
    
    % Test the neural network with the best parameters.
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
    net.trainParam.show = NaN;
    net = train(net, tI, tO);
    netConfusion = confusionmatrix();
    netConfusion.updateFromNet(net, testInputs, testOutputs);
    classifications{fold}(netIndex, :) = netConfusion.getClassifications();
    
    % Test the case based reasoning.
    cbr = CBRinit(trainInputs, trainOutputs);
    cbrConfusion = confusionmatrix();
    cbrConfusion.update(cbr, testInputs, testOutputs);
    classifications{fold}(cbrIndex, :) = cbrConfusion.getClassifications();
    
    fprintf(' %d', fold);
end
else
    fprintf('Previous classifications found - skipping training and testing.\n');
end

classificationsMatrix = cell2mat(classifications);
treeClassifications = classificationsMatrix(treeIndex:3:end, :);
netClassifications = classificationsMatrix(netIndex:3:end, :);
cbrClassifications = classificationsMatrix(cbrIndex:3:end, :);

% Test for any significant differences between the algorithms.
results = zeros(3, 6);
classificationMeans = zeros(3, 6);
treeNetIndex = 1;
treeCbrIndex = 2;
netCbrIndex = 3;
alpha = 0.05 / 3;
testFcn = @ttest;
for emotion=1:6,
    results(treeNetIndex, emotion) = testFcn(treeClassifications(:, emotion), netClassifications(:, emotion), 'Alpha', alpha);
    results(treeCbrIndex, emotion) = testFcn(treeClassifications(:, emotion), cbrClassifications(:, emotion), 'Alpha', alpha);
    results(netCbrIndex, emotion) = testFcn(netClassifications(:, emotion), cbrClassifications(:, emotion), 'Alpha', alpha);
    
    classificationMeans(treeIndex, emotion) = mean(treeClassifications(:, emotion));
    classificationMeans(netIndex, emotion) = mean(netClassifications(:, emotion));
    classificationMeans(cbrIndex, emotion) = mean(cbrClassifications(:, emotion));
end

fprintf('Significance level = %f.\n', alpha);
%printmat(results, 'Results', 'Tree-Net Tree-CBR Net-CBR', 'Anger Disgust Fear Happiness Sadness Surprise');
disp(results);

fprintf('Classification means:\n');
disp(classificationMeans);
