function [ similarity ] = similar_manhattan( caseA, caseB )
    similarity = (45 - norm(caseA.OriginalAUs - caseB.OriginalAUs, 3)) / 45;
end

