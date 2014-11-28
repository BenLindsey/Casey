function [ similarity ] = similar_euclideanC( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs) 
        if (caseA.OriginalAUs(i) && caseB.OriginalAUs(i))
            similarity = similarity + weights(caseA.Emotion, i, 2)^2; 
        elseif (~caseA.OriginalAUs(i) && ~caseB.OriginalAUs(i))  %should be if they are both -ve
            similarity = similarity + weights(caseA.Emotion, i, 1)^2;
        end 
    end
    
    similarity = sqrt(similarity);
end

