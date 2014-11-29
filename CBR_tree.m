classdef CBR_tree
    %CBR_TREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Root
    end
    
    methods
        function [this] = CBR_tree()
           this.Root = CBR_deadleaf(1); 
        end
        
        function similarcase = retrieveCase(this, newcase, ~)
            toVisit = {};
            current = this.Root;
            
            while ~current.isLeaf()
                toVisit = current.updateToVisit(newcase, toVisit); 
                
                current = toVisit{1};
                toVisit = toVisit(2:end);
            end
            
            similarcase = current.Case;
        end
        
        function this = retainCase(this, newcase)
            this.Root = this.Root.retainCase(newcase);
        end
    end
    
end

