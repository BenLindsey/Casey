classdef CBR_flat
    properties
        Cases
    end
    
    methods
        function this = CBR_flat()
        end
        
        function similarcase = retrieve(this, newcase, similarFunc)
            similarity = zeros(1, length(this.Cases));
    
            for i = 1:length(this.Cases)
                similarity(i) = similarFunc(this.Cases(i, :), newcase);
            end

            [~,idx] = sort(similarity);

            similarcase = this.Cases(idx(end));
        end
        
        function this = retain(this, newcase)
            this.Cases = [this.Cases, newcase];
        end
    end
    
end

