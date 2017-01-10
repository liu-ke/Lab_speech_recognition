function [features]=Mel_DCT(frames)
%

N=15;
features=zeros(N,size(frames,2));
M=size(frames,1);
for n=1:N
    for m=1:M
    features(n,:)=features(n,:)+log10(frames(m,:)).*cos(pi*n/M*(m-0.5));    
    end
end