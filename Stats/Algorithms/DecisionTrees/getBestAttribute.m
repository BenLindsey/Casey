function bestAttribute = getBestAttribute(examples, attributes, binaryTargets)

    bestInfoGain = -1;
    for i=1:length(attributes),
        currentInfoGain = informationGain(examples, binaryTargets, attributes(i));
 %       fprintf('Info gain for attribute column %d: %d\n', i, currentInfoGain);
        if currentInfoGain > bestInfoGain
            bestInfoGain = currentInfoGain;
            bestAttribute = attributes(i);
        end
    end
end

function informationGain = informationGain(examples, binaryTargets, attribute)

    [examplesEntropy, noExamples] = entropy(examples, binaryTargets, attribute, 2);
    
    [entropyFalse, noFalse] = entropy(examples, binaryTargets, attribute, 1);
    [entropyTrue, noTrue] = entropy(examples, binaryTargets, attribute, 0);
    
    informationGain = examplesEntropy - (noFalse * entropyFalse / noExamples ...
      + noTrue * entropyTrue / noExamples);
    
end

function [ entropy, noExamples ] = entropy(examples, binaryTargets, attribute, attributeValue)

    noExamples = 0;
    noPosExamples = 0;
    for i=1:length(binaryTargets),
        if examples(i, attribute) ~= attributeValue
           noExamples = noExamples + 1;
           noPosExamples = noPosExamples + binaryTargets(i);
        end
    end
    
    if noExamples == 0
        % A high entropy gives a low information gain, which should be
        % correct for no examples since it means the corresponding
        % attribute doesn't really tell us anything.
        entropy = 1;
    else
    
        propPositive = noPosExamples / noExamples;
        propNegative = 1 - propPositive;

        if propPositive == 0 || propNegative == 0
            entropy = 0;
        else
            entropy = -propPositive * log2(propPositive) - propNegative * log2(propNegative);
        end
    end
end