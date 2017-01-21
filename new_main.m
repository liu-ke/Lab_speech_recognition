clc;
speech_dirpath='F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\timit\test';%path of training data
ubm_dataset=load('F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\ubm\UBM_GMMNaive_MFCC_Spectrum0to8000Hz.mat');%path of ubm file
Fs=16000;
%Extract speech data from wav files
%Segment speech data into frames
%Detect voiced speech frames
[frames,index]=new_DataExtraction(speech_dirpath);  % index is the end frame index of each wav file

%Extract MFCC feature from speech signals
window_method=1;                                    %1=hanning,2=hamming,3=blackman
windowed_frames=new_Window(frames,window_method);
spectrum_frames=windowed_frames;
for i=1:length(windowed_frames)
    spectrum_frames{i,1}=abs(fft(windowed_frames{i,1})).^2/length(windowed_frames);
end
filtered_frames=new_Mel_Filter(spectrum_frames,Fs);
features=new_Mel_DCT(filtered_frames);

%Cross validation
test_data=cell(size(features));
true_labels=[1:size(features,1)];
err=[];
for i=1:10
    temp=features;
    %Seperate training data and test data
    for j=1:length(features)
        test_data{j,:}=features{j,:}(:,index{j,:}(:,i)+1 : index{j,:}(:,i+1));
        temp{j,:}(:,index{j,:}(:,i)+1 : index{j,:}(:,i+1))=[];
        training_data=temp;
    end
    %Make the model
    [means,covariances,weights]=new_SpeakerModel(ubm_dataset,training_data);
    
    %Identify the speaker
    classified_labels=new_SpeakerIdentification(test_data,means,covariances,weights);
    err=[err,sum(classified_labels-true_labels~=0,2)];
end