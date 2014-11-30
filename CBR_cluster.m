classdef CBR_cluster
    properties
        Cases
        Weights
        Seen
    end
    
    methods
        function this = CBR_cluster()
            this.Weights = zeros(6, 45, 2);  % 3rd dim: weigths -ve and +ve                   
            this.Cases = {[],[],[],[],[],[]};          
            this.Seen = {};
            for i = 1:6
                this.Seen{i} = containers.Map('KeyType','double', 'ValueType','any'); 
            end
        end
        
        function this = retainCase(this, newcase) 
            key = sum(newcase.AUs);
            
            if(~this.Seen{newcase.Emotion}.isKey(key))
                this.Seen{newcase.Emotion}(key) = {};
            end
            
            for CASE = this.Seen{newcase.Emotion}(key) % steps through all cases classified as emotion of sample
                %  if sample case (<-end) have same AUs as case(il) (for emotion)  
                if (isequal(newcase.AUs, CASE.AUs))
                    CASE.Typicality = CASE.Typicality + 1;   % increases sums typic. of cases -> into first case
                    return;
                end        
            end
            
            % update +ve weights of cluster
            % adds +1 to all (row=emotion, col=+ve AU for sample) of weights (:,:,1)
            this.Weights(newcase.Emotion, newcase.AUs, 2) = ...
                 this.Weights(newcase.Emotion, newcase.AUs, 2) + 1; 

            % update -ve weights of cluster
            AUneg = 1:45; 
            AUneg(newcase.AUs) = [];    %AU neg contains indexes of negative attributes

            this.Weights(newcase.Emotion, AUneg, 1) = ...
                this.Weights(newcase.Emotion, AUneg, 1) + 1; % adds +1 to all (row=emotion, col=-ve AU for sample) of weights (:,:,2)

            this.Cases{newcase.Emotion} = [this.Cases{newcase.Emotion}, newcase];
            this.Seen{newcase.Emotion}(key) = [this.Seen{newcase.Emotion}(key), newcase];
        end    
          
        function bestCase = retrieveCase(this, newcase, similarFunc)
            weights = this.Weights;
                    
            % normalises weights
            for clus = 1:length(this.Cases)
                if ~isempty(this.Cases{clus})
                    weights(clus,:,:) = weights(clus,:,:) / length(this.Cases{clus});
                end    
            end  
            
            empty = true;
            similarity = zeros(1, length(this.Cases));
            for clus = 1:length(this.Cases)
                if ~isempty(this.Cases{clus})
                    % First case in cluster should be best match due to
                    % indexing (sorting) above?
                    similarity(clus) = sqrt(sum(( weights(clus,:,2) .* newcase.OriginalAUs ).^2) ...
                        + sum(( weights(clus,:,1) .* ~newcase.OriginalAUs ).^2));
                    
                    empty = false;
                end    
            end
            
            % Check training works ok
            if empty
                fprintf('\nERROR: No cases in cbr system - have you trained the cbr?\n');
            end
            
            % We've retrieved the similarity of the new case with the best
            % case from each cluster, now only take the top few (k-nearest
            % neighbour)
            
            minRange = max(similarity) - (max(similarity) - min(similarity)) / 2;
            
            [ordered_similarity, clusters] = sort(similarity, 'descend');
            bestClusters = clusters(ordered_similarity >= minRange);
            
            lastCluster = bestClusters(end);
            
            bestSimilarity = 0;
            bestCase = struct('Typicality', 0); % Allows > Typicality check
            
            % Loop through all cases in each of our chosen clusters and
            % find the REAL best case (one with highest similarity)
            for CLUSTER = bestClusters 
                for CASE = this.Cases{CLUSTER}
                    similarity = similarFunc(CASE, newcase, weights);
                    if similarity > bestSimilarity
                        bestSimilarity = similarity;
                        bestCase = CASE;
                        
                        if CLUSTER == lastCluster 
                            return % Pointless to keep searching the final cluster,
                                   % Can't be beaten once found one better
                                   % than all clusters seen so far.
                        end
                    elseif similarity == bestSimilarity ...
                            && CASE.Typicality > bestCase.Typicality
                        disp('hello ello ello');
                        bestCase = CASE;
                    end
                end
            end         
        end
        
    end
    
end

