function [ similarity ] = similar( caseA, caseB )
    similarity = (45 - length(setxor(caseA.AUs, caseB.AUs)))/45;
end

