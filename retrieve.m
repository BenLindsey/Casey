function [ similarcase ] = retrieve( cbr, newcase )
    similarcase = cbr.retrieve(newcase, @similar);
end

