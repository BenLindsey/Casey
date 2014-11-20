function [ similarcase ] = retrieve( cbr, newcase )
    similarity = zeros(1, length(cbr));
    
    for i = 1:length(cbr)
        similarity(i) = cbr(i, :);
    end

    [~,idx] = sort(similarity);

    similarcase = cbr(idx(end));
end

