classdef leaf
    properties
        Value
        X
        Y
    end
    
    methods
        function this = leaf(Value)
            this.Value = Value;
        end
        
        function x = bfs(this, example, emotions, toVisit)
            toVisit = toVisit(2:end); 
            if this.Value == 1
                x = emotions(1);
            elseif ~isempty(toVisit)
                x = toVisit{1}.bfs(example, emotions(2:end), toVisit);
            else
                x = emotions(1);
            end
        end
        
        function x = dfs(this, ~)
            x = this.Value;
        end
        
        function [X, depth, leafsFound] = draw(this, depth, leafsFound)
            X = leafsFound;
            leafsFound = leafsFound + 1;

            ft = {'r' 'g'};
            line(X, depth, 'color', ft{this.Value + 1}, 'marker', '.', 'markersize', 8)
            text(X, depth, num2str(this.Value) ,'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'interpreter', 'none'); 
        end
        
        function print(this, tLabel, fLabel, prefix)     
            ft = {fLabel tLabel};
            disp(strcat(prefix, ft{this.Value + 1}));
        end
    end    
end

