classdef CBR_cluster
    properties
        cases
        weights
    end
    
    methods
        function this = CBR_cluster()
            
            weights=zeros(6,45);
            
               
        end
        
        
        
        function [cbr] = CBRinit(x, y)
      
     %%          
        
            cases={[],[],[],[],[],[]};
            
           
            for ol=1:length(y)
                
               
                %create case in cluster
                
                cases{y(ol)} = [cases{y(ol)} caseClus(getAU(x(ol,:)), y(ol))]; 
                               
                % update weights of cluster
                
                weights(y(ol),cases{y(ol)}(end).AUs) = weights(y(ol),cases{y(ol)}(end).AUs) + 1;
                                     
                % case already known
                              
                for il=1:length( cases{y(ol)} )
                    if ( isequal  (cases{y(ol)}(end).AUs, cases{y(ol)}(il).AUs)  && (length( cases{y(ol)} )~=il) )
                        cases{y(ol)}(il).Typicality = cases{y(ol)}(il).Typicality +1;
                        cases{y(ol)}(end)=[];
                        break;
                    end 
                end
                
             
           end
               
      %%          
                
            %other loop
            
                % indexing ??
                
            % normalize weights
            
            
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

