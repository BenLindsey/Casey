confusedMatrix = confusionmatrix();

reverseMsg = '';
for i=1:10,
    msg = sprintf('Running fold %d/10', i);
    fprintf([reverseMsg, msg]);
    reverseMsg = repmat(sprintf('\b'), 1, length(msg));
    
    % Remove 10% of x to form the 9fold data
    trainInput = x;
    trainInput(i:10:end,:) = [];
    
    trainOutput = y;
    trainOutput(i:10:end) = [];
        
    % Use the other 10% of x for test data
    testInput = x(i:10:end, :);
    testOutput = y(i:10:end);
    
    % Setup the CBR class with the training data.
    cbr = CBRinit(trainInput, trainOutput);

    % Update the confusion matrix with the test data for this fold.
    confusedMatrix.update(cbr, testInput, testOutput);
end

% Get the average statistics from the confusion matrix.
recallRates = zeros(1, 6);
precision   = zeros(1, 6);
f1Scores    = zeros(1, 6);
accuracy    = confusedMatrix.getAccuracy();
for class=1:6,
    recallRates(class) = confusedMatrix.getRecallRate(class);
    precision(class)   = confusedMatrix.getPrecision(class);
    f1Scores(class)    = confusedMatrix.getFScore(class, 1);
end

% Clear the progress text.
fprintf(reverseMsg);

% Print all statistics.
fprintf('Confusion matrix:\n');
disp(confusedMatrix.Matrix);

fprintf('Average recall rates: ');
disp(recallRates);

fprintf('Average precision:    ');
disp(precision);

fprintf('Average f1 scores:    ');
disp(f1Scores);

fprintf('Average accuracy:     ');
disp(accuracy);
