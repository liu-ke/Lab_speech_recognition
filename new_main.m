clc;
clf;
speech_dirpath='F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\timit\test';%path of speech data
ubm_dataset=load('F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\ubm\UBM_GMMNaive_MFCC_Spectrum0to8000Hz.mat');%path of ubm file
Fs=16000;

%1-3 Extract speech data from wav files, Segment speech data into frames, Detect voiced speech frames
[frames,index]=new_DataExtraction(speech_dirpath);  % index is the end frame index of each wav file

%4 Extract MFCC feature from speech signals
window_method=1;                                    %1=hanning,2=hamming,3=blackman
windowed_frames=new_Window(frames,window_method);
spectrum_frames=windowed_frames;
for i=1:length(windowed_frames)
    spectrum_frames{i,1}=abs(fft(windowed_frames{i,1})).^2/length(windowed_frames);
end
filtered_frames=new_Mel_Filter(spectrum_frames,Fs);
features=new_Mel_DCT(filtered_frames);

%7 Cross validation
test_data=cell(size(features));
true_labels=[1:size(features,1)];
classified_labels=zeros(10,size(features,1));
err=zeros(10,1);
detection_rate=zeros(10,1);
for i=1:10                                          %iteratively take test_data from each speaker's ith wav-file, training data from other 9 wav-files  
    temp=features;
    %Seperate training data and test data
    for j=1:length(features)
        test_data{j,:}=features{j,:}(:,index{j,:}(:,i)+1 : index{j,:}(:,i+1));
        temp{j,:}(:,index{j,:}(:,i)+1 : index{j,:}(:,i+1))=[];
        training_data=temp;
    end
%5 Make the model
    [means,covariances,weights]=new_SpeakerModel(ubm_dataset,training_data);
    
%6 Identify the speaker,unknown speakers labeled as 0,others labeled id from 1-170
    classified_labels(i,:)=new_SpeakerIdentification(test_data,means,covariances,weights) ;
    err(i)=sum(classified_labels(i,:)-true_labels~=0,2)/size(test_data,1);
    detection_rate(i)=sum(classified_labels(i,:)==true_labels,2)/size(test_data,1);
end
save('classification_results.mat','classified_labels');
figure(1);
xlabel('test dataset');
scatter([1:10],err,'b');
hold on;
scatter([1:10],detection_rate,'r');
legend('error rate','detection rate');
hold on;
plot([0,0,1,1],[0,1,0,1],'.');