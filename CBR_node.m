classdef CBR_node < handle
    %CBR_NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AU
        Left
        Right
    end
    
    methods
        function [this] = CBR_node(AU) 
           this.AU = AU; 
        end
        
        function similarcase = retrieveCase(this, newcase, toVisit)
            if newcase.OriginalAUs(this.AU) == 0 
               toVisit = cat(2, {this.Left}, toVisit, {this.Right});
            else
               toVisit = cat(2, {this.Right}, toVisit, {this.Left});
            end
            
            similarcase = toVisit{1}.retrieveCase(newcase, toVisit(2:end));
        end
        
        function this = retainCase(this, newcase)
            if newcase.OriginalAUs(this.AU) == 0 
               this.Left = this.Left.retainCase(newcase);
            else
               this.Right = this.Right.retainCase(newcase);
            end
        end
    end
    
end

