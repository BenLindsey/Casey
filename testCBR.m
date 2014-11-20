function [ predictions ] = testCBR( CBR, x2 )
    for i=1:length(x2)
        newcase = Case(x2(i, :), 0);
        predictions(i) = reuse(retrieve(CBR, newcase), newcase);
        CBR = retain(CBR, predictions(i));
    end 
end

