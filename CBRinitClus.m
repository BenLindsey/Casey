function [ cbr ] = CBRinitClus( x, y )

    cbr=CBR_cluster();
%     for i = 1:length(x)
    for i=1:10
       newcase=caseClus(getAU(x(i,:)),y(i));
       cbr = addCase(cbr, newcase);
       
    end

    
    cbr = updateIndexes(cbr);
  
end

