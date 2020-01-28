%% delete the speech part of the pitch track extracted from the audio with
% help of ground truth notes
% input: pitch track and ground truth notes
% output: pitch track without speech part
function pitchtrack_ds = delspeech(pitch_o, note)

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
delt = pitch_o(2,1)-pitch_o(1,1); %time span of one frame 
ext_singing_begintime = singing_begintime-100*delt;
ext_singing_endtime = singing_endtime+100*delt;
bpoint_temp = [ext_singing_begintime; ext_singing_endtime];
bpoint = [0; sort(bpoint_temp)]; 

% 3.transfer time to the loc of pitch
loc_point_p = zeros(length(bpoint),1);
for i=1:length(bpoint)
    [closet_v, closet_l] = min(abs(pitch_o(:,1)-bpoint(i)));
    loc_point_p(i) = closet_l;
end
% 4. delete the range of speech
pitch_temp = pitch_o;
pitch_temp([loc_point_p(1):loc_point_p(2), loc_point_p(3):loc_point_p(4), loc_point_p(5):loc_point_p(6)],:) = [];
pitchtrack_ds = pitch_temp;
 
% end

