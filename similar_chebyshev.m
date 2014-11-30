function [ similarity ] = similar_chebyshev( caseA, caseB, weights )
    similarity = 0;
    
    % Make sure we have the same number of AUs since we only take the
    % length of one side.
    assert(length(caseA.OriginalAUs) == length(caseB.OriginalAUs));

    for i = 1:length(caseA.OriginalAUs)
        current = 0;
        
        % If the AUs have the same value, then retrieve the relevant
        % weight, otherwise use 0.
        if (caseA.OriginalAUs(i) && caseB.OriginalAUs(i))
            current = weights(caseA.Emotion, i, 2);
        elseif (~caseA.OriginalAUs(i) && ~caseB.OriginalAUs(i))
            current = weights(caseA.Emotion, i, 1);
        end 
        
        % Update the maximum weight found.
        if (current > similarity)
            similarity = current;
        end
    end
end

