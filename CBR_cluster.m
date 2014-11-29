classdef CBR_cluster
    properties
        Cases
        Weights
    end
    
    methods
        
        function this = CBR_cluster()
            this.Weights = zeros(6, 45, 2);  % 3rd dim: weigths -ve and +ve                   
            this.Cases = {[],[],[],[],[],[]};             
        end
               

        function this = retainCase(this, newcase)    
            this = addCase(this, newcase);
            this = updateIndexes(this);           
        end
        
        function this = addCase(this, newcase)
            weights = this.Weights;              
            cases   = this.Cases;
            emot    = newcase.Emotion;

            % update +ve weights of cluster
            weights(newcase.Emotion, newcase.AUs, 2) = weights(newcase.Emotion, newcase.AUs, 2) + 1; % adds +1 to all (row=emotion, col=+ve AU for sample) of weights (:,:,1)

            % update -ve weights of cluster
            AUneg = 1 : size(weights, 2); 

            AUneg(newcase.AUs) = [];    %AU neg contains indexes of negative attributes

            weights( newcase.Emotion, AUneg, 1) = weights(newcase.Emotion, AUneg, 1) + 1; % adds +1 to all (row=emotion, col=-ve AU for sample) of weights (:,:,2)
     
            % for every new sample, it checks the same exact sample does not already exists 

            for il = 1 : length( cases{emot} ) % steps through all cases classified as emotion of sample

                %  if sample case (<-end) have same AUs as case(il) (for emotion)  
                if ( isequal (newcase.AUs, cases{newcase.Emotion}(il).AUs) )

                    cases{newcase.Emotion}(il).Typicality = cases{newcase.Emotion}(il).Typicality + newcase.Typicality;   % increases sums typic. of cases -> into first case

                    newcase = [];

                    break;  %out of for

                end        
            end


            if ~isempty(newcase)

                % appends case to {emotion} cell in cluster
                cases{emot} = [cases{emot}, newcase];

            end    

            % updates class properties
            this.Cases   = cases;
            this.Weights = weights;
        end    
        
        
        function this = updateIndexes(this) % creates indexes of importance of cases

            for clus = 1 : length(this.Cases)   % for each cluster                        
                importance = arrayfun(@(x) (sum( this.Weights(clus,:,2) .* x.OriginalAUs ) ...
                    + sum( this.Weights(clus,:,1) .* ~x.OriginalAUs )), this.Cases{clus});
                
                [~, idx] = sort(importance, 'descend');
                    
                this.Cases{clus} = this.Cases{clus}(idx);
            end      
            
        end 
               
        function similarcase = retrieveCase(this, newcase, similarFunc)
     
            weights = this.Weights;
                    
            % normalises weights

            for clus = 1:length(this.Cases)

                if ~isempty(this.Cases{clus})
                    weights(clus,:,:) = weights(clus,:,:) / (size(weights,2) * length(this.Cases{clus}) );
                end    

            end  
            
            empty = true;
            similarity = zeros(1, length(this.Cases));
            for clus = 1:length(this.Cases)
                if ~isempty(this.Cases{clus})
                    % First case in cluster should be best match due to
                    % indexing (sorting) above?
                    similarity(clus) = similarFunc(this.Cases{clus}(1), newcase, weights);
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
            
            minRange = max(similarity)- (max(similarity) - min(similarity)) / 20; % why 20?
            
            % ranV holds the index of clusters with the top similarities
            % (based on importance)
            ranV = find (similarity > minRange);
            
            % similClus hold the best similarity for each cluster
            similClus = zeros (1,length(ranV));
            
            % similCase holds the index of the case with the best similarity
            % for each cluster
            similCase = zeros (1,length(ranV));
            
            % Loop through all cases in each of our chosen clusters and
            % find the REAL best case (one with highest similarity)
            for clus = 1:length(ranV)                

                for cas = 1:length(this.Cases{ranV(clus)})
                    
                    similarity = similarFunc(this.Cases{ranV(clus)}(cas), newcase, weights);
                    
                    if similarity > similClus(clus)
                        similClus(clus) = similarity;
                        similCase(clus) = cas;
                    end
                end
            end         
            
            % Get the index of the cluster with the highest similarity -
            % this is our chosen emotion
            emot = find(similClus == max(similClus));
            
%             disp(emot);
%             disp(similCase);
%             disp(similClus);
%             disp(this.Cases);
            
            % if emot more than 1???? (i.e two emotions have the same best
            % similarity) - currently pick the first one
            similarcase = this.Cases{ranV(emot(1))}(similCase(emot(1)));
        end
        
    end
    
end

