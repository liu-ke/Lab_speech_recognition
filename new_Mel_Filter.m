function[filtered_vectors]=new_Mel_Filter(spectrum_frames,fs)
Mel_fmax=new_Mel_Scale(fs/2,0);                     %Map frequency to Mel frequency
num_tri_filters=22;                             %number of triangle filters
len_a_filter=Mel_fmax/(num_tri_filters+1);      %length of one triangle filter in Mel frequency
Mel_tri=zeros(num_tri_filters+2,1);             %triangle points in Mel Scale frequency
F_tri=Mel_tri;                                  %triangle points in frequency
for i=1:length(Mel_tri)-1                       %1:23 
    Mel_tri(i+1)=Mel_tri(i)+len_a_filter;
end
for i=1:length(Mel_tri)                         %Mel frequency scale
    F_tri(i)=new_Mel_Scale(Mel_tri(i),1);           %Map triangle points from Mel_frequency to frequency    
end
filtered_vectors=cell(length(spectrum_frames),1);
num_f=size(spectrum_frames{1,1},1)                     %the number of frequency length
for j=1:length(spectrum_frames)
    s=size(spectrum_frames{j,1},2);                 %s is the number of frames of each speaker
    filtered_vectors{j,1}=zeros(num_tri_filters,s);
    for i=1:num_tri_filters
        W_start=(F_tri(i)*(num_f/2)/(fs/2)+1);            %F_tri(i)*160/8000+1
        W_end=(F_tri(i+2)*(num_f/2)/(fs/2)+1);            %F_tri(i+2)*160/8000+1
        W_points=size(spectrum_frames{j,1}(ceil(W_start):floor(W_end),:),1);     %how many points between W_start and W_end
        W_length=W_end-W_start;
        W=zeros(W_points,1);
        for k=0:W_points-1
            W(k+1)=(W_length/2-abs(k+(ceil(W_start)-W_start)-W_length/2))/(W_length/2);                 %linear interpolation
        end
        W=repmat(W,[1,s]);
        filtered_vectors{j,1}(i,:)=sum(spectrum_frames{j,1}(ceil(W_start):floor(W_end),:).*W,1);        %multiply spectrum with triangles correspondingly, and then sum by column
    end
end