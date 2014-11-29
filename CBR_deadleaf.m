classdef CBR_deadleaf < handle
    %CBR_DEADLEAF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AU
    end
    
    methods
        function [this] = CBR_deadleaf(AU) 
           this.AU = AU; 
        end
        
        function similarcase = retrieveCase(~, newcase, toVisit)
            similarcase = toVisit{1}.retrieveCase(newcase, toVisit(2:end));
        end
        
        function this = retainCase(this, newcase)
            this = CBR_leaf(this.AU, newcase);
        end
    end
    
end

