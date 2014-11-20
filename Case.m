classdef Case
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
    end
     


end

