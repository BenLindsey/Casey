function [ similarcase ] = retrieve( cbr, newcase )
    similarcase = cbr.retrieveCase(newcase, @similar_euclidean);
end

