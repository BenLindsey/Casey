function [ cbr ] = CBRinit( x, y )

    cbr = CBR_cluster();
%     for i = 1:length(x)
    for i = 1:50
       cbr = retain(cbr, Case(x(i,:),y(i))); 
    end

end

