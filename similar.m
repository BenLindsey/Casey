function [ similarity ] = similar( caseA, caseB )
    similarity = (45 - length(setxor(caseA, caseB)))/45;
end

