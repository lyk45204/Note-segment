clc; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% batch reading pitch track, note ground truth and rms files 
% input: the path of the folder and the extension
% output: filenames
folder_pitchtrack = 'C:\phd\Dataset\Jiajie\ISMIR_2015\ISMIR_2015_pitchtrack_csv';
folder_note_gt = 'C:\phd\Dataset\Jiajie\ISMIR_2015\ISMIR_2015_GroundTruthnotes_csv';
folder_rms = 'C:\phd\Dataset\Jiajie\ISMIR_2015\ISMIR_2015_rms_csv';
extension = '*.csv';

filename_pitchtrack = batchfolder(folder_pitchtrack,extension);
filename_note_gt = batchfolder(folder_note_gt,extension);
filename_rms = batchfolder(folder_rms,extension);
% read these files
% input: filename: the names of the files
% output: pitch_o(cell) and note_gt(cell): the cell contain pitch tracks or notes which is stored in
% matrix
n_files_pitchtrack = length(filename_pitchtrack);
pitchtrack_o = cell(n_files_pitchtrack,1);
for i = 1:n_files_pitchtrack
    pitchtrack_o{i} = csvread(filename_pitchtrack{i});
end

n_files_note_gt = length(filename_note_gt);
note_gt = cell(n_files_note_gt,1);
for i = 1:n_files_note_gt
    note_gt{i} = csvread(filename_note_gt{i});
end

n_files_rms = length(filename_rms);
m_level = cell(n_files_rms,1);
for i = 1:n_files_rms
    m_level{i} = csvread(filename_rms{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% pre-process %%%%%%%%%%%%%%
%% transfer the negative value of pitch(outputunvoiced:2) to 0
for i = 1:n_files_pitchtrack
    pitchtrack_o{i}(find(pitchtrack_o{i}(:,2)<0),2) = 0;
end

pitchtrack = pitchtrack_o;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
%%%%%%%%%%%notes segmentation%%%%%%%%%%%%%
%% HMM_noteseg
% input: nSPP, nPPS, nS, minPitch, the pitch track file (two columns matrix)
% output: notes, it is a cell, every cell is the notes result of a pitch
% track
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% set parameters
% states
nSPP = 3; %number of states of per pitch(attack, stable, silence)
% pitch steps range
nPPS = 3; %number of pitch of per semitone
nS = 69; % number of semitones
minPitch = 35; % the min semitone

path = cell(n_files_pitchtrack, 1);
for i = 1:n_files_pitchtrack
    pitchtrack_piece = pitchtrack{i};
    path{i}  = HMM_noteseg(nSPP, nPPS, nS, minPitch, pitchtrack_piece);
end

%% MonoNote
% input: nSPP, nPPS, minPitch, path_piece, pitchtrack_piece
% output: notes: Frametime, decoded pitch and the state of every frame

noteout = cell(n_files_pitchtrack, 1);
for i = 1:n_files_pitchtrack
    pitchtrack_piece = pitchtrack{i};
    path_piece = path{i};
    noteout{i} = MonoNote(nSPP, nPPS, minPitch, path_piece, pitchtrack_piece);
end

%% 
%%%%%%%%%%% post-process %%%%%%%%%%%%%%
% input: pitchtrack_piece, inputSampleRate, pruneThresh, stepSize,
%           noteout_piece, onsetSensitivity, m_level_piece
% output: Notes: onset_time, offset_time, medianPitch
%         loc_states: loc_onset, loc_stablestart, loc_offset

inputSampleRate = 44100;
pruneThresh = 0.1;
stepSize = 256;
onsetSensitivity = 0.7;
Notes = cell(n_files_pitchtrack, 1);
loc_states = cell(n_files_pitchtrack, 1);
for i = 1:n_files_pitchtrack
    pitchtrack_piece = pitchtrack{i};
    noteout_piece = noteout{i};
    m_level_piece = m_level{i};
    [Notes{i}, loc_states{i}] = Postprocess(pitchtrack_piece, inputSampleRate, pruneThresh, stepSize,...
                                   noteout_piece, onsetSensitivity, m_level_piece);
end

             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% delete speech part
% input: reimplement notes and ground truth
% output: Tonynotes_ds: Tony notes without speech part
note_im = Notes;
for i = 1:n_files_pitchtrack
    note_im_ds{i} = delspeech_notes(note_im{i}, note_gt{i});                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
end
note_im_temp = note_im_ds;
note_im = note_im_temp;
%%
%%%%%%%%%%%%%%% evaluation(implement vs gt) %%%%%%%%%%%%%%
% addpath('D:\1PhD_working\code\notes_segment\onset_detection_evaluation_code\EvaluationFramework_ISMIR2014\CommandLineTool\aux_files');
% input: listOfGroundTruthFiles,listOfTranscriptionFiles
% they are cell variable which store the matrix of notes of all the pitch
% track
% output: the evaluation results

% change the format of note_gt to standard one
note_gt_sd = cell(n_files_note_gt, 1);
for i = 1:n_files_note_gt
    n_note = size(note_gt{i}, 1);
    note_gt_sd{i} = zeros(n_note, 3);
    note_gt_sd{i}(:,1) = note_gt{i}(:,1);
    note_gt_sd{i}(:,2) = note_gt{i}(:,1) + note_gt{i}(:,3);
    note_gt_sd{i}(:,3) = f2s(note_gt{i}(:,2));
end

% change the format of note_gt to standard one
note_im_sd = cell(n_files_note_gt, 1);
for i = 1:n_files_note_gt
    
    n_note = size(note_im{i}, 1);
    note_im_sd{i} = zeros(n_note, 3);
    note_im_sd{i}(:,1) = note_im{i}(:,1);
    note_im_sd{i}(:,2) = note_im{i}(:,2);
    note_im_sd{i}(:,3) = f2s(note_im{i}(:,3)); 
    
end

% lists of files
listOfGroundTruthFiles=note_gt_sd;
listOfTranscriptionFiles=note_im_sd;

% evaluation:
evalMeasures=evaluation1(listOfGroundTruthFiles, listOfTranscriptionFiles);
rowname={
    'Total Duration (GT)',...
    'Total Duration (Tr)',...
    'Total number of notes (GT)',...
    'Total number of notes (Tr)',...
    'Correct Onset, Offset & Pitch: Total No. Notes',...
    'Correct Onset, Offset & Pitch: Mean Precision',...
    'Correct Onset, Offset & Pitch: Mean Recall',...
    'Correct Onset, Offset & Pitch: Mean F-measure',...
    'Correct Onset, & Pitch: Total No. Notes',...
    'Correct Onset, & Pitch: Mean Precision',...
    'Correct Onset, & Pitch: Mean Recall',...
    'Correct Onset, & Pitch: Mean F-measure',...
    'Correct Onset: Total No. Notes',...
    'Correct Onset: Mean Precision',...
    'Correct Onset: Mean Recall',...
    'Correct Onset: Mean F-measure',...
    'Correct Pitch & Offset / Wrong Onset: Total No. Notes (GT)',...
    'Correct Pitch & Offset / Wrong Onset: Mean Rate (GT)',...
    'Correct Onset & Offset / Wrong Pitch: Total No. Notes (GT)',...
    'Correct Onset & Offset / Wrong Pitch: Mean Rate (GT)',...
    'Correct Onset & Pitch / Wrong Offset: Total No. Notes (GT)',...
    'Correct Onset & Pitch / Wrong Offset: Mean Rate (GT)',...
    'Split: Total No. Notes (GT)',...
    'Split: Mean Rate (GT)',...
    'Split: Mean Ratio (GT->TR)',...
    'Merge: Total No. Notes (GT)',...
    'Merge: Mean Rate (GT)',...
    'Merge: Mean Ratio (TR->GT)',...
    'Spurious: Total No. Notes (TR)',...
    'Spurious: Mean Rate (TR)',...
    'Non-detected: Total No. Notes (GT)',...
    'Non-detected: Mean Rate (GT)'};

%show files in a table
figure(1)
u = uitable('Data',[rowname' num2cell(evalMeasures')],'units','normalized','Position',[0 0 1 1]);
set(u,'ColumnWidth',{200})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%% evaluation(Tony vs gt) %%%%%%%%%%%%%%
%% batch reading pitch track and note ground truth files 
% input: the path of the folder and the extension
% output: filenames
folder_Tonynotes = 'C:\phd\Dataset\Jiajie\ISMIR_2015\ISMIR_2015_Tonynotes_csv';
extension = '*.csv';

filename_Tonynotes= batchfolder(folder_Tonynotes,extension);
% read these files
% input: filename: the names of the files
% output: Tonynotes: the cell contain Tony notes which is stored in
% matrix
n_files_Tonynotes = length(filename_Tonynotes);
Tonynotes_o = cell(n_files_Tonynotes,1);
for i = 1:n_files_Tonynotes
    Tonynotes_o{i} = csvread(filename_Tonynotes{i});
end

%% delete speech part
% input: Tony notes and ground truth
% output: Tonynotes_ds: Tony notes without speech part
Tonynotes_ds = cell(n_files_pitchtrack, 1);
for i = 1:n_files_Tonynotes
    Tonynotes_ds{i} = delspeech_notes(Tonynotes_o{i}, note_gt{i});
end
Tonynotes_temp = Tonynotes_ds;

Tonynotes = Tonynotes_temp;

%% evaluation
% input: listOfGroundTruthFiles,listOfTranscriptionFiles
% they are cell variable which store the matrix of notes of all the pitch
% track
% output: the evaluation results

% change the format of note_gt to standard one
Tonynotes_sd = cell(n_files_Tonynotes, 1);
for i = 1:n_files_Tonynotes
    n_note = size(Tonynotes{i}, 1);
    Tonynotes_sd{i} = zeros(n_note, 3);
    Tonynotes_sd{i}(:,1) = Tonynotes{i}(:,1);
    Tonynotes_sd{i}(:,2) = Tonynotes{i}(:,2);
    Tonynotes_sd{i}(:,3) = f2s(Tonynotes{i}(:,3));
end
% lists of files
listOfGroundTruthFiles=note_gt_sd;
listOfTranscriptionFiles=Tonynotes_sd;
% modify Tonynotes to standard

% evaluation:
evalMeasures=evaluation1(listOfGroundTruthFiles, listOfTranscriptionFiles);

%show files in a table
figure(2)
u = uitable('Data',[rowname' num2cell(evalMeasures')],'units','normalized','Position',[0 0 1 1]);
set(u,'ColumnWidth',{200})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% evaluation(Tony vs im) %%%%%%%%%%%%%%
%% evaluation
% input: listOfGroundTruthFiles,listOfTranscriptionFiles
% they are cell variable which store the matrix of notes of all the pitch
% track
% output: the evaluation results

% lists of files
listOfGroundTruthFiles=Tonynotes_sd;
listOfTranscriptionFiles=note_im_sd;

% evaluation:
evalMeasures=evaluation1(listOfGroundTruthFiles, listOfTranscriptionFiles);

%show files in a table
figure(3)
u = uitable('Data',[rowname' num2cell(evalMeasures')],'units','normalized','Position',[0 0 1 1]);
set(u,'ColumnWidth',{200})

%% save the variable for visulizition in the toolbox
%%% gt VS original pyin
% save the ground truth notes
for i = 1:n_files_Tonynotes
    GroundTruth = note_gt_sd{i};
    GroundTruth_name = sprintf('gt_o%i.GroundTruth.txt', i);
    GUIprepro_Matrix2text(GroundTruth,GroundTruth_name);
end
    
% save pyin_TransExample into midi to get better visualization
for i = 1:n_files_Tonynotes
    pyin_r = Tonynotes_sd{i};
    pyin_r_name = sprintf('gt_o%i.TransExample.mid', i);
    GUIprepro_Matrix2midi(pyin_r,pyin_r_name);
end

%%% gt VS implement pyin
% save the ground truth notes
for i = 1:n_files_Tonynotes
    GroundTruth = note_gt_sd{i};
    GroundTruth_name = sprintf('gt_r%i.GroundTruth.txt', i);
    GUIprepro_Matrix2text(GroundTruth,GroundTruth_name);
end

% save pyin_TransExample into midi to get better visualization
for i = 1:n_files_Tonynotes
    pyin_r = note_im_sd{i};
    pyin_r_name = sprintf('gt_r%i.TransExample.mid', i);
    GUIprepro_Matrix2midi(pyin_r,pyin_r_name);
end

%%% original pyin VS implement pyin

% save pyin_TransExample into midi to get better visualization
for i = 1:n_files_Tonynotes
    pyin_r = Tonynotes_sd{i};
    pyin_r_name = sprintf('ovr%i.GroundTruth.txt', i);
    GUIprepro_Matrix2text(pyin_r,pyin_r_name);
end

% save pyin_TransExample into midi to get better visualization
for i = 1:n_files_Tonynotes
    pyin_r = note_im_sd{i};
    pyin_r_name = sprintf('ovr%i.TransExample.mid', i);
    GUIprepro_Matrix2midi(pyin_r,pyin_r_name);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%% plot %%%%%%%%%%%%%%
figure(4);
i = 1;
pitchtrack_piece = pitchtrack{i};
pitchtrack_temp = pitchtrack_piece;
pitchtrack_temp(find(pitchtrack_piece(:,2)==0), 2) = NaN;

% plot the original pitchtrack
t_p = pitchtrack_temp(:, 1);
pitchtrack_p = pitchtrack_temp(:, 2);
plot(t_p, pitchtrack_p, 'k');
hold on;

% plot the ground truth note
i = 1;
note = note_gt{i};
Trh = 18; % the height of the rectangle
for i = 1:length(note(:,1))
    rectangle('position', [note(i,1), note(i,2)-Trh/2, note(i,3), Trh], 'edgecolor','b'); 
end
hold on;

% plot the Tonynotes
i = 1;
note = Tonynotes{i};
Trh = 18; % the height of the rectangle
for i = 1:length(note(:,1))
    rectangle('position', [note(i,1), note(i,3)-Trh/2, note(i,2)-note(i,1), Trh], 'edgecolor','k', 'LineStyle', '--'); 
end
hold on;



% plot implement result
k = 1; % the number of the plotted track 

Ton = note_im{k}(:,1); % the onset of my results

% the stablestart
loc_stablestart = loc_states{k}(:,2);
loc_stablestart(find(loc_stablestart==0)) = [];

loc_onset = loc_states{k}(:,1);
loc_stablestart = loc_stablestart(find(Notes{k}(:,1)==Ton(1)):end);
Tstat = t_p(loc_stablestart);

Toff = note_im{k}(:,2); % the start of the silence of my results

ylim=get(gca,'Ylim');
for i = 1:length(Ton)
    line([Ton(i) Ton(i)], ylim,'color','r');
end
hold on;

for i = 1:length(Tstat)
    line([Tstat(i) Tstat(i)], ylim,'color','y', 'LineStyle', '--');
end
hold on;

for i = 1:length(Toff)
    line([Toff(i) Toff(i)], ylim,'color','g');
end
hold on;

%pitch
for i = 1:length(Ton)
    x1 = Ton(i);
    x2 = Toff(i);
    y_pitch = note_im{k}(i,3);
    line([x1 x2],[y_pitch y_pitch],'color','r');
    
    hold on;
    
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    