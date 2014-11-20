classdef Case
    properties
        Typicality
        Emotion
        AUs
    end
    
    methods
        function this = Case(AUs, emotion)
            this.Typicality = 0;
            this.AUs = [];
            
            for i=1:length(AUs)
                if AUs(i) > 0
                    this.AUs = [AUs, i];
                end
            end
            
            this.Emotion    = emotion; 
        end
    end
     


end

