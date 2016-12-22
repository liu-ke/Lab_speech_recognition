function [windowed_frames]=window(frames,selection)
%without windowing, signals can be seen as rectangular windowed signals
n=size(frames,1);                            %should be 320
if selection == 1 %use Hanning windowing
    W=repmat(hanning(n),1,size(frames,2));    %W has the same dimension with frames
end
if selection == 2 %use Hamming windowing
    W=repmat(hamming(n),1,size(frames,2));
end
if selection == 3 %use Blackman windowing
    W=repmat(blackman(n),1,size(frames,2));
end
 windowed_frames=W.*frames;