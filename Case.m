classdef Case < handle
    properties
        Typicality
        Emotion
        AUs
        OriginalAUs
    end
    
    methods
        function this = Case(varargin)
            if(length(varargin) == 2) 
                this.Emotion = varargin{2};
            else
                this.Emotion = -1;
            end
            
            this.Typicality = 1;
            this.AUs = find(varargin{1});
            this.OriginalAUs = varargin{1};
        end
    end
     


end

