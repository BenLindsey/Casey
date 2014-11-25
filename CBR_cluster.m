classdef CBR_cluster
    properties
        cases
        weights
    end
    
    methods
        
       function this = CBR_cluster(x,y)
            
            weights=zeros(6,45);
                    
            cases={[],[],[],[],[],[]};
            
            
           %% steps through samples putting them into 'cases', organized in clusters
           
            for ol=1:length(y)
                
               
                %appends case to {emotion} cell in cluster
                
                cases{y(ol)} = [cases{y(ol)} caseClus(getAU(x(ol,:)), y(ol))]; %caseCLus creates new case with xAU and y as inputs
                               
                % update weights of cluster
                
                weights(y(ol),cases{y(ol)}(end).AUs) = weights(y(ol),cases{y(ol)}(end).AUs) + 1; % adds +1 to all (row=emotion, col=+ve AU for sample) of weights
                            
              
            
                %% for every new sample, it checks the same exact sample does not already exists 
                              
               for il=1:length( cases{y(ol)} ) % steps through all cases classified as emotion of sample
                    
                        %  if sample case (<-end) have same AUs as case(il) (for emotion)
                        % AND il th case is not the last case (ie compraing case to itself) 
                                        % * if put condition in 'for', problem for lenght=1
                       
                        if ( isequal  (cases{y(ol)}(end).AUs, cases{y(ol)}(il).AUs)  && (length( cases{y(ol)} )~=il) )
                            
                            cases{y(ol)}(il).Typicality = cases{y(ol)}(il).Typicality +1;   % increases typic. for first case
                            cases{y(ol)}(end)=[];   % delete second case
                            
                            break;  %out of for
                        end 
                end
                
            end     
                
                this.cases=cases;
                this.weights=weights;
             
       end
               
      %%          
                
            %other loop
            
                % indexing ??
                
            % normalize weights
            
               

        
        
        function [cbr] = CBRinit_clus(x, y)
      
     %%          

            
            
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
%         function this = retain(this, newcase)
%             this.Cases = [this.Cases, newcase];
%         end
    end
    
end

