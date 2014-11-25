function [ similarity ] = similar_manhattan( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs)
        if (caseA.OriginalAUs && caseB.OriginalAUs)
            similarity = similarity + weights(caseA.emotion, i, 1);
        elseif (~caseA.originalAUs(i) && caseB.OriginalAUs(i))
            similarity = similarity + weights(caseA.emotion, i, 0);
        end 
    end
end

