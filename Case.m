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
            this.AUs = getAU(AUs);
            this.OriginalAUs = AUs;
            this.Emotion = emotion; 
        end
    end
     


end

