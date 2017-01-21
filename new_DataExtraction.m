function [train_frames,test_frames]=new_DataExtraction(dir_path)
%1. Extract speech data
train_frames=cell(0,1);
test_frames=cell(0,1);
speech_dir=dir(dir_path);                                       %get information (dr1-9) under training data speech_dir
for i=1:length(speech_dir)
    index=regexp(speech_dir(i).name,'dr+\d');                   %index=1 if dr_dirpath(i).name matched to dr0-dr9
    if(~size(index))
        continue;
    end
    dr_dirpath=fullfile(dir_path,speech_dir(i).name);           %get paths of (dr1-9)
    dr_dir=dir(dr_dirpath);                                     %get the information under dr_dirpath
    for j=1:length(dr_dir)
        index=regexp(dr_dir(j).name,'\w+\w+\w+\d');             %file names should be matched to \w\w\w\d
        if(~size(index))
            continue;
        end
        dat_dirpath=fullfile(dir_path,speech_dir(i).name,dr_dir(j).name);       %get paths of ppl's name
        dat_dir=dir(dat_dirpath);                                               %get the information under ppl's name
        name=regexp(dat_dirpath,'[fm]\w\w\w+\d','match');                       %get the speaker's name
        num_wav=0;                                                          %number of person's file
        train_frames_a_speaker=[];
        test_frames_a_speaker=[];
        for k=1:length(dat_dir)
            index=regexp(dat_dir(k).name,'s+\w+\S');
            if(~size(index))
                continue;
            end
            wav_path=fullfile(dir_path,speech_dir(i).name,dr_dir(j).name,dat_dir(k).name);      %get path of each wav
            content=audioread(wav_path);                                                        %get the wav signals of one file
%2. Segment speech data into frames
            frames_a_wav=new_FrameSegmentation(content);
%3. 
            voiced_frames=new_VoiceDetection(frames_a_wav);
            num_wav=num_wav+1;
            if num_wav <= 9
                train_frames_a_speaker=[train_frames_a_speaker,voiced_frames];                              %take the voiced framdes in first 8 wav files as a training set
            else
                test_frames_a_speaker=[test_frames_a_speaker,voiced_frames];                                %take the voiced framdes in last 2 wav files as a test set
            end
        end
        train_frames=[train_frames;train_frames_a_speaker,];
        test_frames=[test_frames;test_frames_a_speaker];
    end
end
