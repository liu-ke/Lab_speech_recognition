
speech_dirpath='F:\Courses\INFOTECH\2017ws\DPRLAB\patRecDat\forStudents\timit\test';%path of training data
speech_dir=dir(speech_dirpath);%get information (dr1-9) under training data speech_dir
name_res=zeros(160*1);
num=0;
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
        num=num+1;
        content=[];
        for k=1:length(dat_dir)
            index=regexp(dat_dir(k).name,'s+\w+\S');
            if(~size(index))
                continue;
            end
            wav_path=fullfile(speech_dirpath,speech_dir(i).name,dr_dir(j).name,dat_dir(k).name); %get path of each wav
            temp=audioread(wav_path);                                                        %get the wav signals
            content=[content;temp];                                                         %collect all wav files of one person
        end
        [train_frames,test_frames]=frameseg(content);
        voiced_frames=voicedetection(train_frames);
        
    end
end