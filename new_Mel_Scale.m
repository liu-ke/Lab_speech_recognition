function [out_frequency]=new_Mel_Scale(in_frequency,inverse)
%Transformation between Mel Scale Frequency and Normal Frequency
%inverse==0: transform Normal Frequency to Mel Frequency
%inverse==1: transform Mel Frequency to Normal Frequency
%in_frequency: a real number
%out_frequency: a real number
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
    