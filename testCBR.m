function [ predictions ] = testCBR( CBR, x2 )
    for i=1:length(x2)
        predictions(i) = reuse(retrieve(CBR, x2(i, :)), x2(i, :));
    end 
end

