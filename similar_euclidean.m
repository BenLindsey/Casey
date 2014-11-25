function [ similarity ] = similar_euclidean( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs)
        if (caseA.OriginalAUs && caseB.OriginalAUs)
            similarity = similarity + weights(caseA.emotion, i, 1)^2;
        elseif (~caseA.originalAUs(i) && caseB.OriginalAUs(i))
            similarity = similarity + weights(caseA.emotion, i, 0)^2;
        end 
    end
    
    similarity = sqrt(similarity);
end

