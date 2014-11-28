function [ similarity ] = similar_chebyshevC( caseA, caseB, weights )
    similarity = 0;

    for i = 1:length(caseA.OriginalAUs) % steps through each AU
        current = 0;
        
        if (caseA.OriginalAUs(i) && caseB.OriginalAUs(i))   % if both have the AU, 
            current = weights(caseA.Emotion, i, 2); 
        elseif (~caseA.OriginalAUs(i) && caseB.OriginalAUs(i))  % if they are different ??? should it be both neg? also maybe not use this here
            current = weights(caseA.Emotion, i, 1);
        end 
        
        if (current > similarity)
            similarity = current;   % keeps highest smilarity
        end
    end
end

