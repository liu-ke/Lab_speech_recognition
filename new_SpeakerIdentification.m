function [result]=new_SpeakerIdentification(frames,means,covariances,weights)
%means: a 170*1 cell with a 15*49 matrix per cell(speaker)
%covariances: a 170*1 cell with a 15*49 matrix per cell(speaker)
%weights: a 170*1 cell with a 1*49 row vector per cell(speaker)
num_speaker=170;
likelihood=zeros(num_speaker,length(frames));
for n=1:length(frames)                  %iterate for all test speakers
    for m=1:num_speaker                 %should be 168 or 170(number of training speakers)
        sigma(1,:,:)=covariances{m,1};
        obj=gmdistribution(means{m,1}',sigma,weights{m,1});            %generate a GMM model for one speaker
        likelihood(m,n)=sum(log(pdf(obj,frames{n,1}')));               %compute p(b|lambda)
    end
end
[~,result]=max(likelihood);