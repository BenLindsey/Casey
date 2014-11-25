classdef Case
    properties
        Typicality
        Emotion
        AUs
        OriginalAUs
    end
    
    methods
        function this = Case(AUs, emotion)

            this.Typicality = 1;
            this.OriginalAUs = AUs;
            this.AUs = [];
            
            for i=1:length(AUs)
                if AUs(i) > 0
                    this.AUs = [this.AUs, i];
                end
            end
            
            this.Emotion = emotion; 
        end
    end
     


end

