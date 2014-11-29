classdef CBR_flat
    properties
        Cases
    end
    
    methods
        function this = CBR_flat()
        end
        
        function similarcase = retrieveCase(this, newcase, similarFunc)
            similarity = zeros(1, length(this.Cases));
    
            parfor i = 1:length(this.Cases)
                similarity(i) = similarFunc(this.Cases(i), newcase, ones([6, 45, 2]));
            end
            
            [~,idx] = sort(similarity);

            similarcase = this.Cases(idx(end));
        end
        
        function this = retainCase(this, newcase)
            this.Cases = [this.Cases, newcase];
        end
    end
    
end

