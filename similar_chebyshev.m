function [ similarity ] = similar_chebyshev( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs)
        if (caseA.OriginalAUs && caseB.OriginalAUs)
            current = weights(caseA.emotion, i, 1);
        elseif (~caseA.originalAUs(i) && caseB.OriginalAUs(i))
            current = weights(caseA.emotion, i, 0);
        end 
        
        if (current > similarity)
            similarity = current;
        end
    end
end

