%% 
% input: pitchtrack_piece, inputSampleRate, pruneThresh, stepSize,
%           noteout_piece, onsetSensitivity, m_level_piece
% output: Notes: onset_time, offset_time, medianPitch
%         loc_states: loc_onset, loc_stablestart, loc_offset
function [Notes, loc_states] = Postprocess(pitchtrack_piece, inputSampleRate, pruneThresh, stepSize,...
                                   noteout_piece, onsetSensitivity, m_level_piece)
    onsetFrame = 0;
    isVoiced = 0;
    oldIsVoiced = 0;
    nFrame = size(pitchtrack_piece, 1);
    timestamp = pitchtrack_piece(:, 1);
    minNoteFrames = (inputSampleRate*pruneThresh) / stepSize;
    
    notePitchTrack = []; % collects pitches for one note at a time
    onset_time = []; % collects onsets of this piece
    loc_onset = []; % collects the loc of onsets of this piece
    offset_time = []; % collects offsets of this piece
    loc_offset = []; % collects the loc of offsets of this piece
    loc_stablestart = []; % collects the loc of stablestart of this piece
    medianPitch = []; % collects the median pitch in notes
    for iFrame = 1:nFrame
        
        isVoiced = noteout_piece(iFrame, 3) < 3 && ...
                            pitchtrack_piece(iFrame, 2) > 0 && ...
                            (iFrame >= nFrame-2 || ((m_level_piece(iFrame,2)/m_level_piece(iFrame+2,2)) > onsetSensitivity));
        
        if isVoiced == 1 && iFrame ~= nFrame-1 % voiced frame
        
            if oldIsVoiced == 0 % beginning of a note
            
                onsetFrame = iFrame;
                loc_onset = [loc_onset; onsetFrame];
                onset = timestamp(onsetFrame);
                onset_time = [onset_time; onset];                
            
            end
            
            
            pitch = pitchtrack_piece(iFrame, 2);
            notePitchTrack = [notePitchTrack; pitch]; % add the pitch of current voiced frame to the note's pitch track
            
        else % not currently voiced
            if oldIsVoiced == 1 % the end of note
                
                loc_offset = [loc_offset; iFrame];
                offset = timestamp(iFrame);
                offset_time = [offset_time; offset];
                    
                if length(notePitchTrack) >= minNoteFrames                
                    medianPitch = [medianPitch; median(notePitchTrack)]; % in frequency
                else
                    loc_onset(end) = [];
                    onset_time(end) = [];
                    loc_offset(end) = [];
                    offset_time(end) = [];
                                                                          
                end
                
                notePitchTrack = [];
            end
        end
        oldIsVoiced = isVoiced;
    end
    
    Notes = [onset_time, offset_time, medianPitch];
    
    n_Notes = size(Notes, 1);
    for i = 1:n_Notes
        
        for iFrame = loc_onset(i)+1:loc_offset(i)-1
            
            if noteout_piece(iFrame, 3) == 2
%                 if iFrame == loc_onset(i)+1 || noteout_piece(iFrame-1, 3) == 1
                    stablestart = iFrame;
                    loc_stablestart = [loc_stablestart; stablestart];
                    break;
            else
                if iFrame == loc_offset(i)-1
                    stablestart = 0;
                    loc_stablestart = [loc_stablestart; stablestart];
                end
                    
              
                
            end
            
        end
        
    end
    
    
    
    loc_states = [loc_onset, loc_stablestart, loc_offset];


          
end
