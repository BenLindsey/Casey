classdef forest
    %A forest is a collection of 6 trees, one for each emotion.
    properties
        Trees
    end
    
    methods
        %Can construct a forest from an existing cell array of trees
        %Or build a new cell array from training data
        function this = forest(varargin)       
            if(length(varargin) == 1) 
                this.Trees = varargin{1};
            elseif(length(varargin) == 2)
                attributes=1:45;
                
                for emotion=1:6 
                    binaryTargets = varargin{2} == emotion;
                    this.Trees{emotion} = decisionTreeLearning( varargin{1}, attributes, binaryTargets );
                end
            end
        end
        
        %Find the first TRUE path by searching the trees in order 1->6
        function x = getEmotionViaDfs(this, example)
            for emotion=1:6,
                if this.Trees{emotion}.dfs(example)
                    x = emotion;
                    return;
                end
            end
            
            x = -1;
        end
        
        %Find the shortest path of all 6 trees to a TRUE leaf.
        function x = getEmotionViaBfs(this, example)
            x = this.Trees{1}.bfs(example, 1:6, this.Trees);
        end
    end
    
end

