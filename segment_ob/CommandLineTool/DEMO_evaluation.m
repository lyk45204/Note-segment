addpath('./aux_files');
% lists of files
listOfGroundTruthFiles=importdata('gt_files.txt');
listOfTranscriptionFiles=importdata('baseline_files.txt');

% evaluation:
evalMeasures=evaluation(listOfGroundTruthFiles,listOfTranscriptionFiles);
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
figure(3);
uitable('Data',[rowname' num2cell(evalMeasures')],'units','normalized','Position',[0 0 1 1]);