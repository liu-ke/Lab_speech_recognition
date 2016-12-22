function[filtered_vectors]=Mel_Filter(spectrum_frames,fs)
Mel_fmax=Mel_Scale(fs/2,0);                     %Map frequency to Mel frequency
num_tri_filters=22;                             %number of triangle filters
filtered_vectors=zeros(num_tri_filters,size(spectrum_frames,2));
len_a_filter=Mel_fmax/(num_tri_filters+1);   %length of one triangle filter in Mel frequency
Mel_tri=zeros(num_tri_filters+2,1);             %triangle points in Mel Scale frequency
F_tri=Mel_tri;                                  %triangle points in frequency
for i=1:length(Mel_tri)-1                       %1:23 
    Mel_tri(i+1)=Mel_tri(i)+len_a_filter;
end
for i=1:length(Mel_tri)                               %Mel frequency scale
    F_tri(i)=Mel_Scale(Mel_tri(i),1);                 %Map triangle points from Mel_frequency to frequency    
end
for i=1:num_tri_filters
    W_start=(F_tri(i)*(size(spectrum_frames,1)/2)/(fs/2)+1);            %F_tri(i)*160/8000+1
    W_end=(F_tri(i+2)*(size(spectrum_frames,1)/2)/(fs/2)+1);            %F_tri(i+2)*160/8000+1
    W_points=size(spectrum_frames(ceil(W_start):floor(W_end),:),1);     %how many points between W_start and W_end
    W_length=W_end-W_start;
    W=zeros(W_points,1);
    for k=0:W_points-1
        W(k+1)=(W_length/2-abs(k+(ceil(W_start)-W_start)-W_length/2))/(W_length/2);                 %linear interpolation
    end
    W=repmat(W,[1,size(spectrum_frames,2)]);
    filtered_vectors(i,:)=sum(spectrum_frames(ceil(W_start):floor(W_end),:).*W,1);        %multiply spectrum with triangles correspondingly, and then sum by column
end
