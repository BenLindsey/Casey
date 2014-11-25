function [ similarity ] = similar_chebyshev( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs)
        current = 0;
        
        if (caseA.OriginalAUs(i) && caseB.OriginalAUs(i))
            current = weights(caseA.Emotion, i, 2);
        elseif (~caseA.OriginalAUs(i) && caseB.OriginalAUs(i))
            current = weights(caseA.Emotion, i, 1);
        end 
        
        if (current > similarity)
            similarity = current;
        end
    end
end

