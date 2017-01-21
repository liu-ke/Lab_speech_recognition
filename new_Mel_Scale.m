function [out_frequency]=new_Mel_Scale(in_frequency,inverse)

if inverse==0
    if in_frequency>1000
        out_frequency=2595*log10(1+in_frequency/700);
    else
        out_frequency=in_frequency;
    end
else
    if in_frequency>1000
        out_frequency=700*(10^(in_frequency/2595)-1);
    else
        out_frequency=in_frequency;
    end
end
    