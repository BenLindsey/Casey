classdef node
    properties
        Left
        Right
        Attribute
    end
    
    methods
        function this = node(Attribute)
            this.Attribute = Attribute;
        end
        
        function x = bfs(this, example, emotions, toVisit)
            toVisit = toVisit(2:end); 

            if example(this.Attribute) 
                toVisit = cat(2, toVisit, {this.Right});
            else
                toVisit = cat(2, toVisit, {this.Left});
            end
            
            x = toVisit{1}.bfs(example, emotions([2:end,1]), toVisit);
        end     
        
        function x = dfs(this, example)
            if example(this.Attribute) == 1
                x = this.Right.dfs(example);
            else
                x = this.Left.dfs(example);
            end
        end
        
        function [X, Y, leafsFound] = draw(this, varargin)
            if(length(varargin) == 2)
                depth = varargin{1};
                leafsFound = varargin{2};    
            else
                depth = 0;
                leafsFound = 0;    
            end
            
            [Xl, Yl, leafsFound] = this.Left.draw(depth - 1, leafsFound);  
            [Xr, Yr, leafsFound] = this.Right.draw(depth - 1, leafsFound);
            X = mean([Xl, Xr]);  
            Y = depth;
            
            line([X Xl], [Y Yl]);
            line([X Xr], [Y Yr]);
            line(X, Y, 'marker', '^', 'markersize', 8)
            text(X, Y,num2str(this.Attribute),'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom','interpreter', 'none');
        end
        
        function print(this, varargin)  
            prefix = '';
            
            if(length(varargin) > 2)
                prefix = varargin{3};
                
                disp(strcat(prefix, num2str(this.Attribute)));  
                
                if strcmp(prefix(end-2:end), '├──') == 1
                    prefix = [prefix(1:end-3), '│',  blanks(2)]; 
                elseif strcmp(prefix(end-2:end), '└──') == 1
                    prefix = [prefix(1:end-3), blanks(3)];    
                end
            else
                disp(num2str(this.Attribute));  
            end
            
            this.Left.print(varargin{1}, varargin{2}, [prefix, '├──']);
            this.Right.print(varargin{1}, varargin{2}, [prefix, '└──']);
        end
    end
end

