classdef caseClus
    properties
        Typicality
        Emotion
        AUs
    end
    
    methods
        function this = caseClus(AUs, emotion)
            this.Typicality = 1;
            this.AUs=AUs;
            
            this.Emotion    = emotion; 
        end
    end
     


end

