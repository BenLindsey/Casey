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
               

        function this = retain(this, newcase)    
            addCase(this, newcase);
            updateIndexes(this);           
        end
        
        function this = addCase(this, newcase)
            weights = this.Weights;              
            cases   = this.Cases;
            emot    = newcase.Emotion;

            % update +ve weights of cluster
            weights( newcase.Emotion, newcase.AUs, 2) = weights(newcase.Emotion, newcase.AUs, 2) + 1; % adds +1 to all (row=emotion, col=+ve AU for sample) of weights (:,:,1)

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
            
            cases   = this.Cases;
            weights = this.Weights;

            for clus = 1 : length(cases)   % for each cluster
                
                for ol = 2 : length(cases{clus}) 
                    
                    attribLogical = zeros(1,size(weights,2));
                    attribLogical( cases{clus}(ol).AUs ) = 1;
                    % attribLogical is a mask for current ol attributes
                    importanceOL = ( weights(clus,:,2) .* attribLogical ) + ( weights(clus,:,1) .* ~attribLogical );
                    
                    for il = 1 : (ol-1)                     
                        
                        attribLogical = zeros(1,size(weights,2));
                        attribLogical( cases{clus}(il).AUs ) = 1;
                        importanceIL = ( weights(clus,:,2) .* attribLogical ) + ( weights(clus,:,1) .* ~attribLogical );
                        
                        % (insertion) sort cluster by importance?
                        % TODO: use in built sort, need comparator of
                        % importance
                        if importanceOL > importanceIL
                            
                            cases{clus}(il) = [cases{clus}(ol), cases{clus}(il)];
                            cases{clus}(ol) = [];
                            
                        end
                        
                    end
                    
                end                
            
            end
            
            this.Weights = weights;
            this.Cases   = cases;       
            
        end 
               
        function similarcase = retrieve(this, newcase, similarFunc)
     
            weights = this.Weights;
                    
            % normalises weights

            for clus = 1:length(this.Cases)

                if ~isempty(this.Cases{clus})
                    weights(clus,:,:) = weights(clus,:,:) / (size(weights,2) * length(this.Cases{clus}) );
                end    

            end  
     
            similarity = zeros(1, length(this.Cases));
            for clus = 1:length(this.Cases)
                if ~isempty(this.Cases{clus})
                    % First case in cluster should be best match due to
                    % indexing (sorting) above?
                    similarity(clus) = similarFunc(this.Cases{clus}(1), newcase, weights);
                end    
            end
            
            % We've retrieved the similarity of the new case with the best
            % case from each cluster, now only take the top few
            
            minRange = max(similarity)- (max(similarity) - min(similarity)) / 20; % why 20?
            
            % ranV holds the index of clusters with the top similarities
            % (based on importance)
            ranV = find (similarity > minRange);
            
            % similClus hold the best similarity for each cluster
            similClus = zeros (1,length(ranV));
            
            %similCase holds the index of the case with the best similarity
            %for each cluster
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
            disp(similClus)
            emot = find(similClus == max(similClus))
            
            % if emot more than 1???? (i.e two emotions have the same best
            % similarity) - currently pick the first one
            similarcase = this.Cases{emot(1)}(similCase(emot(1)));

%             disp(similarity);
%             
%             [~,idx] = sort(similarity);
% 
%             similarcase = this.Cases(idx(end));

        end
        
    end
    
end

