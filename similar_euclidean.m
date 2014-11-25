function [ similarity ] = similar_euclidean( caseA, caseB )
    similarity = (45 - norm(caseA.OriginalAUs - caseB.OriginalAUs, 2)) / 45;
end

