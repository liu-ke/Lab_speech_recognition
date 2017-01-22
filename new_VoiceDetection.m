function [voiced_frames]=new_VoiceDetection(frames)
%Detect the voiced frames and remove unvoiced frames, based on SNR (frames with SNR>10dB are regarded voiced)
%frames: segmented speech data (a 320*num_frames matrix)
%voiced_frames: voiced speech data (a 320*num_voiced_frames matrix)
tn=100;
tfeed=10;
length_one_frame=size(frames,1);            %should be 320
noise=sum(frames(:,1:tn/tfeed).^2);         %sum by column, take first tn/tfeed frames as noise, which should not contain human voice
noise=sum(noise./length_one_frame,2);       %sum by row, sum of first tn/tfeed(10) averaged frames 
energy=sum(frames.^2)./length_one_frame;    %sum by column,energy of all frames,averaged energy of all frames
voiced_frames=frames(:,energy>10*noise);     %when SNR>10dB, take that frame as a voiced one.