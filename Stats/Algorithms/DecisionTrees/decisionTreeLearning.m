function [ root ] = decisionTreeLearning( examples, attributes, binaryTargets )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if range(binaryTargets) == 0
        root = leaf(binaryTargets(1));
    elseif isempty(attributes) 
        root = leaf(mode(double(binaryTargets)));
    else
        bestAttribute = getBestAttribute(examples, attributes, binaryTargets);
        root = node(bestAttribute);
        for i=0:1;
            idx=find(examples(:,bestAttribute)==i);
            
            examplesi      = examples(idx,:);
            binarytargetsi = binaryTargets(idx);
            attributesi = attributes(attributes ~= bestAttribute);
            
%             if isempty(examplesi)
%                 root = leaf(i);
%                 return;
            % If the attribute is never equal to i.
            if isempty(examplesi)
                % Set the root to the right sub tree.
                if i == 0
                    % Try again, but this time ensure that a different
                    % attribute is used.
                    root = decisionTreeLearning(examples, attributesi, binaryTargets);
                % Set the root the already calculated left sub tree.
                else
                    root = root.Left;
                end
                return;
            else

                if i == 0
                    root.Left  = decisionTreeLearning(examplesi, attributesi,  binarytargetsi);
                else
                    root.Right = decisionTreeLearning(examplesi, attributesi,  binarytargetsi);
                end
            end
        end
    end
end
