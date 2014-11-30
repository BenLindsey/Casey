function [ cbr ] = CBRinit( x, y )

    cbr = CBR_cluster();
    for i = 1:size(x, 1)
       cbr = retain(cbr, Case(x(i,:),y(i))); 
    end

end

