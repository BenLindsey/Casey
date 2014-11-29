function [ predictions ] = testCBR( CBR, x2 )
    predictions = zeros(1, size(x2, 1));
    for i=1:size(x2, 1)
        newcase = Case(x2(i, :), 0);
        solvedcase = reuse(retrieve(CBR, newcase), newcase);
        CBR = retain(CBR, solvedcase);
        predictions(i) = solvedcase.Emotion;
    end 
end

