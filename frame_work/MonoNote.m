%% MonoNote
% input: nSPP, nPPS, minPitch, path_piece, pitchtrack_piece
% output: notes: Frametime, decoded pitch and the state of every frame
%              
function noteout = MonoNote(nSPP, nPPS, minPitch, path_piece, pitchtrack_piece)

%%  calculate noteout_temp containing time, pitch, state of every frame
currPitch = floor((path_piece-1)/nSPP)*(1/nPPS)+minPitch;
% currPitch = s2f(currPitch); %transfer semitone to frequency 
stateKind = rem((path_piece-1),nSPP)+1; %// unvoiced, attack, stable, release, inter
currPitch(find(stateKind==3)) = NaN; %make the silence having no pitch

t_my = pitchtrack_piece(:,1); %time
nFrame = length(path_piece);
noteout = zeros(nFrame,3);
noteout(:,1) = t_my;
noteout(:,2) = currPitch;
noteout(:,3) = stateKind;

% %% collect every note's onset and offset
% % find the loc of every states
% loc_attack = find(noteout_temp(:,3)==1);
% loc_stable = find(noteout_temp(:,3)==2);
% loc_silence = find(noteout_temp(:,3)==3);
%     
% % find the start point of every states
% loc_attackstart = [loc_attack(1); loc_attack(find(diff(loc_attack)>1)+1)];
% loc_stablestart = [loc_stable(1); loc_stable(find(diff(loc_stable)>1)+1)];
% loc_silencestart = [loc_silence(1); loc_silence(find(diff(loc_silence)>1)+1)]; 
% 
% % add the last silence and delete the first silence
% if loc_silencestart(1) == 1
%     loc_silencestart(1) = [];
% end
% % if loc_silencestart(end)<loc_stablestart(end) || loc_silencestart(end)<loc_attackstart(end)
% %     loc_silencestart = [loc_silencestart; nframe+1];
% % end
% loc_onset = loc_attackstart;
% loc_offset = loc_silencestart-1;
% if loc_silencestart(end)<loc_stablestart(end) || loc_silencestart(end)<loc_attackstart(end)
%     loc_offset = [loc_offset; nFrame];
% end
% 
% % calculate the time of every start point
% onset_my = t_my(loc_onset); % the onset of my results
% offset_my = t_my(loc_offset); % the start of silence of my results
% 
% % calculate the pitch of the note
% n_notes = length(onset_my);
% 
% pitch_my = zeros(n_notes, 1);
% for i = 1:n_notes
%     pitch_my(i) = median(pitchtrack_piece(loc_onset(i):loc_offset(i), 2));
% end
% %% get the notes
% 
% notes = zeros(n_notes, 3);
% notes(:,1) = onset_my;
% notes(:,2) = offset_my;
% notes(:,3) = pitch_my;
% 
% %% summarize loc of the begining of the states
% loc_state = zeros(n_notes,3);
% loc_state(:,1) = loc_onset;
% loc_state(:,2) = loc_stablestart;
% loc_state(:,3) = loc_offset;

end