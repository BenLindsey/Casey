classdef CBR_cluster
    properties
        cases
        weights
    end
    
    methods
        
       function this = CBR_cluster()
            
            this.weights=zeros(6,45,2);  % 3rd dim: weigths -ve and +ve
                    
            this.cases={[],[],[],[],[],[]};
             
       end
               

        function this = retain(this,newcase)    
            addCase(this,newcase);
            updateIndexes(this);           
        end
        
        function this = addCase(this,newcase)
                weights=this.weights;              
                cases=this.cases;
                emot=newcase.Emotion;
                % update +ve weights of cluster

                weights( newcase.Emotion, newcase.AUs, 2) = weights(newcase.Emotion, newcase.AUs, 2) + 1; % adds +1 to all (row=emotion, col=+ve AU for sample) of weights (:,:,1)
                
                % update -ve weights of cluster
                
                AUneg=1:size(weights,2);  
       
                AUneg(newcase.AUs)=[];    %AU neg contains indexes of negative attributes
                
                weights( newcase.Emotion, AUneg, 1) = weights(newcase.Emotion, AUneg, 1) + 1; % adds +1 to all (row=emotion, col=-ve AU for sample) of weights (:,:,2)
                
            
                % for every new sample, it checks the same exact sample does not already exists 

               
               for (il=1:length( cases{emot} )) % steps through all cases classified as emotion of sample
                    
                        %  if sample case (<-end) have same AUs as case(il) (for emotion)
                       
                        if ( isequal (newcase.AUs, cases{newcase.Emotion}(il).AUs) )
                            
                            cases{newcase.Emotion}(il).Typicality = cases{newcase.Emotion}(il).Typicality + newcase.Typicality;   % increases sums typic. of cases -> into first case
                            
                            newcase=[];
                            
                            break;  %out of for

                        end        
               end
  
                
               if ~isempty(newcase)
                                       
               % appends case to {emotion} cell in cluster
                    cases{emot}=[cases{emot},newcase];
                             
               end    
               
            % updates calss properties
            
            this.cases=cases;
            this.weights=weights;
        end    
        
        
        function this = updateIndexes(this) % creates indexes of importance of cases
            
            cases=this.cases;
            weights=this.weights;

            for clus = 1:length(cases)   %for each cluster
                
                for ol = 2: length(cases{clus}) 
                    
                    for il=1:(ol-1)
                        
                        attribLogical = zeros(1,size(weights,2));
                        attribLogical( cases{clus}(ol).AUs ) = 1;
                        importanceOL = ( weights(clus,:,2) .* attribLogical ) + ( weights(clus,:,1) .* ~attribLogical );
                        
                        
                        attribLogical = zeros(1,size(weights,2));
                        attribLogical( cases{clus}(il).AUs ) = 1;
                        importanceIL = ( weights(clus,:,2) .* attribLogical ) + ( weights(clus,:,1) .* ~attribLogical );
                        
                        if importanceOL>importanceIL
                            
                            caseOL = cases{clus}(ol);
                            cases{clus}(ol)=[];
                            cases{clus}(il)=[cases{clus}(ol), cases{clus}(il)];
                            
                        end
                        
                    end
                    
                end                
            
            end
            
            this.weights=weights;
            this.cases=cases;      
           
            
        end 
        
        
                
        function similarcase = retrieve(this, newcase, similarFunc)
     
            weights=this.weights;
                    
            % normalises weights

            for clus = 1:length(this.cases)

                if ~isempty(this.cases{clus})
                    weights(clus,:,:) = weights(clus,:,:) / (size(weights,2) * length(this.cases{clus}) );
                end    

            end  
     
            similarity = zeros(1, length(this.cases));
            for clus = 1:length(this.cases)
                if ~isempty(this.cases{clus})
                    similarity(clus) = similarFunc(this.cases{clus}(1), newcase, weights);
                end    
            end
            
            minRange = max(similarity)- (max(similarity) - min(similarity)) /20;
            
            ranV= find (similarity>minRange);
            similClus  = zeros (1,length(ranV));
            similCase  = zeros (1,length( ranV));
            
            for clus = 1:length(ranV)
                

                for cas = 1:length(this.cases{ranV(clus)})
                    
                    similarity = similarFunc(this.cases{ranV(clus)}(cas), newcase, weights);
                    
                    if similarity > similClus(clus)
                        similClus(clus)=similarity;
                        similCase(clus)=cas;
                    end
                end
            end
            
       
            emot = (find(similClus == max (similClus)))
            % if emot more than 1????
            ranV(emot(1))
            similCase(emot(1))
            similarcase = this.cases{ranV(emot(1))}(similCase(emot(1)));
     
            
                    
                    

%             disp(similarity);
%             
%             [~,idx] = sort(similarity);
% 
%             similarcase = this.Cases(idx(end));

        end
        

    end
    
end

