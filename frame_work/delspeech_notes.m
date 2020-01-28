%% delete the speech part of the pitch track extracted from the audio with
% help of ground truth notes
% input: ground truth notes
% output: notes track without speech part
function Tonynotes_ds = delspeech_notes(Tonynotes, note)

% % debug
% pitch_o = pitchtrack_o{1};
% note = note_gt{1};

% 1.find the begining and end of every piece of singing by using the groundtruth note
offset_note = note(:,1)+note(:,3);
offset_note = [0; offset_note(1:end-1)];
onset_note = note(:,1);
gap_note = onset_note-offset_note;
[val ind] = sort(gap_note,'descend');
gap_max = val(1:3); % three repetition in the recordings
loc_gap_max = ind(1:3);
loc_singing_begintime = loc_gap_max;
singing_begintime = onset_note(loc_gap_max);
loc_singing_endtime = loc_gap_max-1;
loc_singing_endtime(find(loc_gap_max==1)) = [];
singing_endtime = offset_note(loc_singing_endtime+1);

% 2. set the range of the speech
%     extend 0.58 s in the begining and the end to form speech range
delt = 0.0058; %time span of one frame 
ext_singing_begintime = singing_begintime-100*delt;
ext_singing_endtime = singing_endtime+100*delt;
bpoint_temp = [ext_singing_begintime; ext_singing_endtime];
bpoint = [0; sort(bpoint_temp)]; 

% 3. delete the range of speech
speech_note_loc = [];
for i=1:2:length(bpoint)-1
    
    speech_note = find(Tonynotes(:,1)>=bpoint(i)&Tonynotes(:,1)<=bpoint(i+1));
    speech_note_loc = [speech_note_loc; speech_note];

end

Tonynotes_ds = Tonynotes;
Tonynotes_ds(speech_note_loc,:) = [];
 
end

