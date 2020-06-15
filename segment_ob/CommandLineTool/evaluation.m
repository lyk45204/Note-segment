function evalMeasures=evaluation(listOfGroundTruthFiles,listOfTranscriptionFiles)
% Author: Emilio Molina (emm@ic.uma.es)
% 23/09/2014
% In case you use this software tool, please cite the following paper:
% [1] Molina, E., Barbancho A. M., Tardon, L. J., Barbancho, I., "Evaluation
% framework for automatic singing transcription", Proceedings of ISMIR 2014
%
% Please, refer to the README.txt for more information about the license
% issues of this software tool.
% ----------------------------------------------------------------------
% evalMeasures = evaluation(listOfGroundTruthFiles,listOfTranscriptionFiles)
% reads a bunch of transcription files, and provide a set of evaluation measures
% associated to them.
%
% --INPUTS---------------------------------------------
% listOfGroundTruthFiles --> Cell of filenames of the ground-truth files.
% See classifyNotes.m to know the accepted formats.
% listOfTranscriptionFiles --> Cell of filenames of the transcription
% files. See classifyNotes.m to know the accepted formats.
%
% Note that two cell arrays must have the same length, and all items must
% be ordered in the same way. Additionally, the filenames must be formatted
% as follow: "xxxxx.yyyyyy.zzz" where xxxx is the instance name (e.g.
% 'song1'), yyyyy is the transcriber name (e.g. 'transcriber1'), and zzz is
% the file extension (e.g. 'mid'). Example:
%
%listOfGroundTruthFiles = {'song1.GT.mid','song2.GT.mid','song3.GT.mid'};
%listOfTranscriptionFiles = {'song1.Tr1.mid','song2.Tr1.mid','song3.Tr1.mid'};
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
addpath('./aux_files');
for i=1:length(listOfGroundTruthFiles)
    fileTranscription=listOfTranscriptionFiles{i};
    fileGroundTruth=listOfGroundTruthFiles{i};
    R(i)=classifyNotes(fileTranscription,fileGroundTruth);
    disp(sprintf('Processing... %i / %i',i,length(listOfGroundTruthFiles)));
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