function [frames,endindex]=new_DataExtraction(dir_path)
%1. Extract, segment speech data into frames and detect voiced frames
%dir_path: path of speech data, within which are dr1-dr9 folders
%frames: 170*1 cell, with each element a matrix (dim:320*number_of_frames), which contains all voiced frames of one speaker
%endindex: 170*1 cell, with each element a row vector (dim: 1*11)

frames=cell(0,1);
endindex=cell(0,1);                                             %the end index of each wav-file
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
        frames_a_speaker=[];
        endindex_a_wav=[0];
        for k=1:length(dat_dir)
            index=regexp(dat_dir(k).name,'s+\w+\S');
            if(~size(index))
                continue;
            end
            wav_path=fullfile(dir_path,speech_dir(i).name,dr_dir(j).name,dat_dir(k).name);      %get path of each wav
            content=audioread(wav_path);                                                        %get the wav signals of one file
%2. Segment speech data into frames
            frames_a_wav=new_FrameSegmentation(content);
%3. Detect voiced frames
            voiced_frames=new_VoiceDetection(frames_a_wav);
            frames_a_speaker=[frames_a_speaker,voiced_frames];                              %take the voiced frames          
            endindex_a_wav=[endindex_a_wav,size(frames_a_speaker,2)];                       %log the end index of each wav-file
        end
        frames=[frames;frames_a_speaker,];
        endindex=[endindex;endindex_a_wav];
    end
end
