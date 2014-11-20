function [ cbr ] = CBRinit( x, y )
    cbr = CBR_flat;
    
    for i = 1:length(x)
       cbr = cbr.retain(Case(x(i), y(i))); 
    end
end

