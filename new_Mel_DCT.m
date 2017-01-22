function [features]=new_Mel_DCT(frames)
%Compute the MFCC features from Mel filtered frames by DCT
%frames:170*1 cell, with each element a 22*num_frames matrix
%features:170*1 cell, with each element a 15*num_frames matrix
N=15;                                                       %get the first 15th dimensions as MFCC features
features=cell(length(frames),1);
for i=1:length(frames)
    features{i,1}=zeros(N,size(frames{i,1},2));             %15*num_frames
    M=size(frames{i,1},1);                                  %should be 22
    for n=1:N
        for m=1:M
            features{i,1}(n,:)=features{i,1}(n,:)+log10(frames{i,1}(m,:)).*cos(pi*n/M*(m-0.5));
        end
    end
end