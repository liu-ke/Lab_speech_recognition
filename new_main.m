clc;
speech_dirpath='F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\timit\test';%path of training data
Fs=16000;
%Extract speech data from wav files
%Segment speech data into frames
%Detect voiced speech frames
[train_frames,test_frames]=new_DataExtraction(speech_dirpath);
frames=[train_frames;test_frames];

%Extract MFCC feature from speech signals
window_method=1;            %1=hanning,2=hamming,3=blackman
windowed_frames=new_Window(frames,window_method);
spectrum_frames=windowed_frames;
for i=1:length(windowed_frames)
    spectrum_frames{i,1}=abs(fft(windowed_frames{i,1})).^2/length(windowed_frames);
end
filtered_frames=new_Mel_Filter(spectrum_frames,Fs);
features=new_Mel_DCT(filtered_frames);

%Make the model
ubm_dataset=load('F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\ubm\UBM_GMMNaive_MFCC_Spectrum0to8000Hz.mat');
[means,covariances,weights]=new_SpeakerModel(ubm_dataset,features(1:170));

%Identify the speaker
results=new_SpeakerIdentification(features(171:340),means,covariances,weights);