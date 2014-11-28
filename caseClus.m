classdef caseClus
    properties
        Typicality
        Emotion
        AUs
        OriginalAUs
    end
    
    methods
        function this = caseClus(AUs, emotion)
            this.Typicality = 1;
            this.AUs=AUs;
            
            this.Emotion    = emotion; 
            
            this.OriginalAUs=zeros(1,45);
            this.OriginalAUs(AUs)=1;
        end
    end
     


end

