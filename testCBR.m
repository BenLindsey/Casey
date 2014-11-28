function [ predictions ] = testCBR( CBR, x2 )
    predictions = zeros(1, length(x2));
    for i=1:length(x2)
        newcase = Case(x2(i, :), 0);
        % NOTE: We don't currently call the retrieve/retain functions
        % defined in seperate files, only the ones from the class - matlab
        % doesn't seem to like the other versions, it thinks they should be
        % class methods due to the cbr argument.
        solvedcase = reuse(retrieve(CBR, newcase, @similar_euclidean), newcase);
        CBR = retain(CBR, solvedcase);
        predictions(i) = solvedcase.Emotion;
    end 
end

