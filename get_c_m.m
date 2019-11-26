function [c,m] = get_c_m(reynolds)
    if (reynolds>=1) && (reynolds<40)
        c=0.75;
        m=0.4;
    elseif (reynolds>=40) && (reynolds<10^3)
        c=0.51;
        m=0.5;
    elseif (reynolds>=10^3) && (reynolds<2*10^5)
        c=0.26;
        m=0.6;
    elseif (reynolds>=2*10^5) && (reynolds<=10^6)
        c=0.076;
        m=0.7;
    else
        error('Reynolds number out of bounds');
    end
    

end