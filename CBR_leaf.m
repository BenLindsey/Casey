classdef CBR_leaf < handle
    %CBR_LEAF Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AU
        Case
    end
    
    methods
        function [this] = CBR_leaf(AU, Case) 
           this.AU = AU; 
           this.Case = Case;
        end
        
        function similarcase = retrieveCase(this, newcase, toVisit)
            count = this.AU;
            while count < 46 
                if this.Case.OriginalAUs(count) ~= newcase.OriginalAUs(count)
                    leaf = CBR_leaf(this.AU + 1, this.Case);
                    
                    toVisit = cat(2, toVisit, {leaf});
                    
                    toVisit{1}.retrieveCase(newcase, toVisit(2:end));
                    
                    return;
                end
                count = count + 1;
            end          
            
            similarcase = this.Case;
        end
        
        function this = retainCase(this, newcase)
            if isequal(newcase.AUs, this.Case.AUs)
               this.Case.Typicality = this.Case.Typicality + 1;
               return;
            end
            
            node = CBR_node(this.AU);

            if this.Case.OriginalAUs(this.AU) == 0 
               node.Left  = CBR_leaf(this.AU + 1, this.Case);
               node.Right = CBR_deadleaf(this.AU + 1);
            else
               node.Right = CBR_leaf(this.AU + 1, this.Case);
               node.Left  = CBR_deadleaf(this.AU + 1);
            end
            
            if newcase.OriginalAUs(this.AU) == 0 
               node.Left = node.Left.retainCase(newcase);    
            else
               node.Right = node.Right.retainCase(newcase); 
            end
            
            this = node;
        end
    end
    
end

