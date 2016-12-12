function [train_frames,test_frames]=frameseg(audio_input)
%to segment the audio input into several frames, with each one 320 samples
num=floor(length(audio_input)/160)-1;
frames=zeros(320,num);
j=0;
for i=1:num
    frames(:,i)=audio_input(j+1:j+320,1);
    j=j+160;
end
train_frames=frames(:,1:floor(num*0.8));
test_frames=frames(:,floor(num*0.8)+1:end);


