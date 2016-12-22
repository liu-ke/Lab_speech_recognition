clc;
speech_dirpath='F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\timit\test';%path of training data
speech_dir=dir(speech_dirpath);%get information (dr1-9) under training data speech_dir
name_res=zeros(160*1);
num_person=0;
Fs=16000;
for i=1:length(speech_dir)
    index=regexp(speech_dir(i).name,'dr+\d');                   %index=1 if dr_dirpath(i).name matched to dr0-dr9
    if(~size(index))
        continue;
    end
    dr_dirpath=fullfile(speech_dirpath,speech_dir(i).name);     %get paths of (dr1-9)
    dr_dir=dir(dr_dirpath);                                     %get the information under dr_dirpath
    for j=1:length(dr_dir)
        index=regexp(dr_dir(j).name,'\w+\w+\w+\d');             %file names should be matched to \w\w\w\d
        if(~size(index))
            continue;
        end
        dat_dirpath=fullfile(speech_dirpath,speech_dir(i).name,dr_dir(j).name); %get paths of ppl's name
        dat_dir=dir(dat_dirpath);                                               %get the information under ppl's name
        name=regexp(dat_dirpath,'[fm]\w\w\w+\d','match');                          %get the speaker's name
        num_person=num_person+1;                                            %number of person
        num_wav=0;                                                          %number of person's file
        train_frames=[];
        test_frames=[];
        for k=1:length(dat_dir)
            index=regexp(dat_dir(k).name,'s+\w+\S');
            if(~size(index))
                continue;
            end
            wav_path=fullfile(speech_dirpath,speech_dir(i).name,dr_dir(j).name,dat_dir(k).name); %get path of each wav
            content=audioread(wav_path);                                                        %get the wav signals of one file
            frames=frameseg(content);
            voiced_frames=voicedetection(frames);
            num_wav=num_wav+1;
            if num_wav <= 8
                train_frames=[train_frames,voiced_frames];                              %take the voiced framdes in first 8 wav files as training set
            else
                test_frames=[test_frames,voiced_frames];                                %take the voiced framdes in last 2 wav files as test set
            end
        end
        window_method=1;            %1=hanning,2=hamming,3=blackman
        windowed_frames=window(frames,window_method);
        spectrum_frames=fft(windowed_frames);
        filtered_frames=Mel_Filter(spectrum_frames,Fs);
        features=dct(filtered_frames);
    end
end