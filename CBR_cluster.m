classdef CBR_cluster
    properties
        cases
        weights
    end
    
    methods
        
       function this = CBR_cluster()
            
            this.weights=zeros(6,45,2);  % 3rd dim: weigths +ve and -ve
                    
            this.cases={[],[],[],[],[],[]};
             
       end
               
            
               

        
%         function similarcase = retrieve(this, newcase, similarFunc)
%             similarity = zeros(1, length(this.Cases));
%     
%             for i = 1:length(this.Cases)
%                 similarity(i) = similarFunc(this.Cases(i), newcase);
%             end
% 
%             disp(similarity);
%             
%             [~,idx] = sort(similarity);
% 
%             similarcase = this.Cases(idx(end));
%         end
%         
        function this = retain(this, newcase)    
                weights=this.weights;              
                cases=this.cases;
                emot=newcase.Emotion;
                % update +ve weights of cluster

                weights( newcase.Emotion, newcase.AUs, 1) = weights(newcase.Emotion, newcase.AUs, 1) + 1; % adds +1 to all (row=emotion, col=+ve AU for sample) of weights (:,:,1)
                
                % update -ve weights of cluster
                
                AUneg=1:size(weights,2);  
       
                AUneg(newcase.AUs)=[];    %AU neg contains indexes of negative attributes
                
                weights( newcase.Emotion, AUneg, 2) = weights(newcase.Emotion, AUneg, 2) + 1; % adds +1 to all (row=emotion, col=-ve AU for sample) of weights (:,:,2)
                 
            
                % for every new sample, it checks the same exact sample does not already exists 
               importanceIDX=0;
               
%                attribLogical = zeros(1,length(newcase.AUs)); worng using
%                length!!!!!!!!!!!!!!!!!!
%                attribLogical( newcase.AUs ) = 1;
%                importanceNC = ( weights(clus,:,1) .* attribLogical ) + ( weights(clus,:,2) .* ~attribLogical );
               
               for (il=1:length( cases{newcase.Emotion} )) % steps through all cases classified as emotion of sample
                    
                        %  if sample case (<-end) have same AUs as case(il) (for emotion)
                       
                        if ( isequal (newcase.AUs, cases{newcase.Emotion}(il).AUs) )
                            
                            cases{newcase.Emotion}(il).Typicality = cases{newcase.Emotion}(il).Typicality + newcase.Typicality;   % increases sums typic. of cases -> into first case
                            
                            newcase=[];
                            
                            break;  %out of for
%                         else
%                                 
%                             attribLogical =
%                             zeros(1,length(newcase.AUs));wrong use of
%                             length!!!!!!!!!!!!!!!!
%                             attribLogical( cases{newcase.Emotion}(il).AUs ) = 1;
%                             importanceIL = ( weights(newcase.Emotion,:,1) .* attribLogical ) + ( weights(newcase.Emotion,:,2) .* ~attribLogical );
%                             
%                             if 
                            
                        end        
               end
  
                
               if ~isempty(newcase)
                   
                    
                %appends case to {emotion} cell in cluster
                
                cases{newcase.Emotion} = [cases{newcase.Emotion} newcase]; % appends newcase to the vector of right emotion cell
                   
               end    
               
               
            %creates indexes of importance of cases
            
%                 
%                 for ol = 2: length(cases{newcase.Emotion}) 
%                     
%                     for il=1:(ol-1)
%                         
%                         attribLogical = zeros(1,size(weights,2));
%                         attribLogical( cases{newcase.Emotion}(ol).AUs ) = 1;
%                         importanceOL = ( weights(newcase.Emotion,:,1) .* attribLogical ) + ( weights(newcase.Emotion,:,2) .* ~attribLogical );
%                         
%                         attribLogical = zeros(1,size(weights,2));
%                         attribLogical( cases{newcase.Emotion}(il).AUs ) = 1;
%                         importanceIL = ( weights(newcase.Emotion,:,1) .* attribLogical ) + ( weights(newcase.Emotion,:,2) .* ~attribLogical );
%                         
%                         if ( importanceOL>importanceIL )
%                             
%                             caseOL = cases{newcase.Emotion}(ol);
%                             cases{newcase.Emotion}(ol)=[];
%                             cases{newcase.Emotion}(il)=[cases{newcase.Emotion}(ol), cases{newcase.Emotion}(il)];
%                             
%                         end
%                         
%                     end
%      
%                 end
            
                
                                for ol = 2: length(cases{emot}) 
                    
                    for il=1:(ol-1)
                        
                        attribLogical = zeros(1,size(weights,2));
                        attribLogical( cases{emot}(ol).AUs ) = 1;
                        importanceOL = ( weights(emot,:,1) .* attribLogical ) + ( weights(emot,:,2) .* ~attribLogical );
                        
                        attribLogical = zeros(1,size(weights,2));
                        attribLogical( cases{emot}(il).AUs ) = 1;
                        importanceIL = ( weights(emot,:,1) .* attribLogical ) + ( weights(emot,:,2) .* ~attribLogical );
                        
                        if ( importanceOL>importanceIL )
                            
                            caseOL = cases{emot}(ol);
                            cases{emot}(ol)=[];
                            cases{emot}(il)=[cases{emot}(ol), cases{emot}(il)];
                            
                        end
                        
                    end
     
                end
            
            % updates calss properties
            
            this.cases=cases;
            this.weights=weights;
            
        end

    end
    
end

