classdef Case
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        typicality
        emotion
        AUs
    end
    
    methods

        function this = Case(input, output)

            this.typicality=0;
            this.AUs=input;
            this.emotion=output;
            
        end
        
        
%          function this = Case(input)
% 
%             this.typicality=0;
%             this.AUs=input;
%             
%          end
     

         
    end
    
end

