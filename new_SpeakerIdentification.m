function [result]=new_SpeakerIdentification(frames,means,covariances,weights)
%means: a 170*1 cell with a 15*49 matrix per cell(speaker)
%covariances: a 170*1 cell with a 15*49 matrix per cell(speaker)
%weights: a 170*1 cell with a 1*49 row vector per cell(speaker)
threshold=-3e+04;                                 %the minimum value of all 170 max-likelihood to detect unknown speakers 
num_speaker=170;                                    %number of training speakers
likelihood=zeros(num_speaker,length(frames));       %each row=each training speaker, each column=each test speaker
for n=1:length(frames)                              %iterate for all test speakers
    for m=1:num_speaker                             %should be 168 or 170(number of training speakers)
        sigma(1,:,:)=covariances{m,1};
        obj=gmdistribution(means{m,1}',sigma,weights{m,1});            %generate a GMM model for one speaker
        likelihood(m,n)=sum(log(pdf(obj,frames{n,1}')));               %compute p(b|lambda)
    end
end
[max_value,result]=max(likelihood);                         %find out the max-value by column
%8 Possible enhancement: determine the speakers as unknown people if their likelihood is less than threshold 
result(:,max_value<threshold)=0;                           