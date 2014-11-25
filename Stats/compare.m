forestConfusion = confusionmatrix();

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
end

fprintf('Decision tree:\n');
disp(forestConfusion.Matrix);
disp(forestConfusion.getAccuracy());
