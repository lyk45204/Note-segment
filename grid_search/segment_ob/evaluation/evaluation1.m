function evalMeasures=evaluation1(listOfGroundTruthFiles,listOfTranscriptionFiles)
% do modification to allow the function input matrix instead of filename
% Author: Emilio Molina (emm@ic.uma.es)
% In case you use this software tool, please cite the following paper:
% [1] Molina, E., Barbancho A. M., Tardon, L. J., Barbancho, I., "Evaluation
% framework for automatic singing transcription", Proceedings of ISMIR 2014
%
%
% --INPUTS---------------------------------------------
% listOfGroundTruthFiles --> Cell of matrix of the ground-truth.
% See classifyNotes.m to know the accepted formats.
% listOfTranscriptionFiles --> Cell of matrix of the transcription

% Note that two cell arrays must have the same length
%
% --OUTPUTS:---------------------------------------------------------------
% evalMeasures contains all relevant information described in [1], averaged
% for the whole dataset.
% 
% The list of measures are:
% evalMeasures(1)=sum([R(:).Dur_GT]);
% evalMeasures(2)=sum([R(:).Dur_TR]);
% evalMeasures(3)=sum([R(:).N_GT]);
% evalMeasures(4)=sum([R(:).N_TR]);
% evalMeasures(5)=length([R(:).COnPOff_listgt]);
% evalMeasures(6)=mean([R(:).COnPOff_Precision]);
% evalMeasures(7)=mean([R(:).COnPOff_Recall]);
% evalMeasures(8)=mean([R(:).COnPOff_Fmeasure]);
% evalMeasures(9)=length([R(:).COnP_listgt]);
% evalMeasures(10)=mean([R(:).COnP_Precision]);
% evalMeasures(11)=mean([R(:).COnP_Recall]);
% evalMeasures(12)=mean([R(:).COnP_Fmeasure]);
% evalMeasures(13)=length([R(:).COn_listgt]);
% evalMeasures(14)=mean([R(:).COn_Precision]);
% evalMeasures(15)=mean([R(:).COn_Recall]);
% evalMeasures(16)=mean([R(:).COn_Fmeasure]);
% evalMeasures(17)=length([R(:).OBOn_listgt]);
% evalMeasures(18)=mean([R(:).OBOn_rategt]);
% evalMeasures(19)=length([R(:).OBP_listgt]);
% evalMeasures(20)=mean([R(:).OBP_rategt]);
% evalMeasures(21)=length([R(:).OBOff_listgt]);
% evalMeasures(22)=mean([R(:).OBOff_rategt]);
% evalMeasures(23)=length([R(:).S_listgt]);
% evalMeasures(24)=mean([R(:).S_rategt]);
% evalMeasures(25)=mean([R(:).S_ratio]);
% evalMeasures(26)=length([R(:).M_listgt]);
% evalMeasures(27)=mean([R(:).M_rategt]);
% evalMeasures(28)=mean([R(:).M_ratio]);
% evalMeasures(29)=length(vertcat(R(:).PU_listtr));
% evalMeasures(30)=mean([R(:).PU_ratetr]);
% evalMeasures(31)=length([R(:).ND_listgt]);
% evalMeasures(32)=mean([R(:).ND_rategt]);
%
% Please, refer to the help of classifyNotes.m, or to [1] for more 
% information about these measures.
% addpath('D:\1PhD_working\code\notes_segment\onset_detection_evaluation_code\EvaluationFramework_ISMIR2014\CommandLineTool\aux_files');
for i=1:length(listOfGroundTruthFiles)
    fileTranscription=listOfTranscriptionFiles{i};
    fileGroundTruth=listOfGroundTruthFiles{i};
    if ~isempty(fileTranscription)==1&&~isempty(fileGroundTruth)==1 % avoid empty
        R(i)=classifyNotes1(fileTranscription,fileGroundTruth);
%         disp(sprintf('Processing... %i / %i',i,length(listOfGroundTruthFiles)));
    end
end
evalMeasures(1)=sum([R(:).Dur_GT]);
evalMeasures(2)=sum([R(:).Dur_TR]);
evalMeasures(3)=sum([R(:).N_GT]);
evalMeasures(4)=sum([R(:).N_TR]);
evalMeasures(5)=length([R(:).COnPOff_listgt]);
evalMeasures(6)=mean([R(:).COnPOff_Precision]);
evalMeasures(7)=mean([R(:).COnPOff_Recall]);
evalMeasures(8)=mean([R(:).COnPOff_Fmeasure]);
evalMeasures(9)=length([R(:).COnP_listgt]);
evalMeasures(10)=mean([R(:).COnP_Precision]);
evalMeasures(11)=mean([R(:).COnP_Recall]);
evalMeasures(12)=mean([R(:).COnP_Fmeasure]);
evalMeasures(13)=length([R(:).COn_listgt]);
evalMeasures(14)=mean([R(:).COn_Precision]);
evalMeasures(15)=mean([R(:).COn_Recall]);
evalMeasures(16)=mean([R(:).COn_Fmeasure]);
evalMeasures(17)=length([R(:).OBOn_listgt]);
evalMeasures(18)=mean([R(:).OBOn_rategt]);
evalMeasures(19)=length([R(:).OBP_listgt]);
evalMeasures(20)=mean([R(:).OBP_rategt]);
evalMeasures(21)=length([R(:).OBOff_listgt]);
evalMeasures(22)=mean([R(:).OBOff_rategt]);
evalMeasures(23)=length([R(:).S_listgt]);
evalMeasures(24)=mean([R(:).S_rategt]);
evalMeasures(25)=mean([R(:).S_ratio]);
evalMeasures(26)=length([R(:).M_listgt]);
evalMeasures(27)=mean([R(:).M_rategt]);
evalMeasures(28)=mean([R(:).M_ratio]);
evalMeasures(29)=length(vertcat(R(:).PU_listtr));
evalMeasures(30)=mean([R(:).PU_ratetr]);
evalMeasures(31)=length([R(:).ND_listgt]);
evalMeasures(32)=mean([R(:).ND_rategt]);
end