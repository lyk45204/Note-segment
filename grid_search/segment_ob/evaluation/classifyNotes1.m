function Results = classifyNotes1(fileTranscription,fileGroundTruth)
% Author: Emilio Molina (emm@ic.uma.es)
% 23/09/2014
% In case you use this software tool, please cite the following paper:
% [1] Molina, E., Barbancho A. M., Tardon, L. J., Barbancho, I., "Evaluation
% framework for automatic singing transcription", Proceedings of ISMIR 2014
%
% Please, refer to the README.txt for more information about the license
% issues of this software tool.
% ----------------------------------------------------------------------
%
% Results = classifyNotes(fileTranscription,fileGroundTruth) return a set
% of evaluation measures (within a struct variable) that represents the
% transcription performance of fileTranscription (MIDI or ASCII-formatted
% file) with respect to fileGroundTruth.
% 
% -- INPUTS --------------------------------
% Both fileTranscription and fileGroundTruth are monophonic melodies. Two
% formats are accepted: (1) monophonic, one track MIDI file or (2)
% ASCII-formatted in three columns as follows:
%
%          Onset (seconds) - Offset (seconds) - Pitch (MIDI number)
%
% Note that, is ASCII-formatted files, the 3rd columns 'Pitch' may contain
% non-integer values.
%
% -- OUTPUT -------------------------------
% The ouput Results is a struct containing all the evaluation measures
% described in [1]:
%
% Results.Dur_GT --> Duration of fileGroundTruth
% Results.Dur_TR --> Duration of fileTranscription
% Results.N_GT --> No. of notes in fileGroundTruth
% Results.N_TR --> No. of notes in fileTranscription
%   COnPOff: Correct Onset, Pitch & Offset
% Results.COnPOff_listgt
% Results.COnPOff_Precision
% Results.COnPOff_Recall
% Results.COnPOff_Fmeasure
%   COnP: Correct Onset, Pitch
% Results.COnP_listgt
% Results.COnP_Precision
% Results.COnP_Recall
% Results.COnP_Fmeasure
%   COn: Correct Onset
% Results.COn_listgt
% Results.COn_Precision
% Results.COn_Recall
% Results.COn_Fmeasure
%   OBOn: Only Bad Onset (i.e. Correct Pitch&Offset, Wrong Onset)
% Results.OBOn_listgt
% Results.OBOn_rategt
%   OBOn: Only Bad Pitch (i.e. Correct Onset&Offset, Wrong Pitch)
% Results.OBP_listgt
% Results.OBP_rategt
%   OBOn: Only Bad Offset (i.e. Correct Onset&Pitch, Wrong Offset)
% Results.OBOff_listgt
% Results.OBOff_rategt
%   S: Split
% Results.S_listgt
% Results.S_rategt
% Results.S_ratio
%   M: Merged
% Results.M_listgt
% Results.M_rategt
% Results.M_ratio
%   PU: Spurious
% Results.PU_listtr
% Results.PU_ratetr
%   ND: Non-Detected
% Results.ND_listgt
% Results.ND_rategt
%
% Please, refer to evaluation.m in order to analyse a complete dataset.
% addpath('./aux_files');
onset_lim = 0.05; %secs % Default parameters (used in MIREX):
dur_percent_range = 20; % percentage
min_dur_dist = 0.05; %secs
f0_range_in_cents = 50; %cents

hopsize=0.01;
%-- load files
notes_tr=fileTranscription;
[M_t,notes_tr]=notes2matrixnotes(notes_tr,hopsize);
notes_gt=fileGroundTruth;
[M_g,notes_gt]=notes2matrixnotes(notes_gt,hopsize);

% %-- Open midifiles
% if strcmp(fileTranscription(end-2:end),'mid')
%     [M_t,notes_tr]=midi2matrixnotes(fileTranscription,hopsize);
% else
%     notes_tr=importdata(fileTranscription);
%     [M_t,notes_tr]=notes2matrixnotes(notes_tr,hopsize);
% end
% if strcmp(fileGroundTruth(end-2:end),'mid')
%     [M_g,notes_gt]=midi2matrixnotes(fileGroundTruth,hopsize);
% else
%     notes_gt=importdata(fileGroundTruth);
%     [M_g,notes_gt]=notes2matrixnotes(notes_gt,hopsize);
% end

sizeMax=max(size(M_t,2),size(M_g,2));
M_t=[M_t zeros(size(M_t,1),sizeMax-size(M_t,2))];
M_g=[M_g zeros(size(M_g,1),sizeMax-size(M_g,2))];

L_g=normalization_factors(M_g); %Normalize to duration of gt notes
L_t=normalization_factors(M_t); %Normalize to duration of transcribed notes

Moverlapped=foverlap(M_g,M_t); %Find which notes overlap
Moverlapped_pitch=foverlap_pitch(M_g,M_t,f0_range_in_cents); %Find which notes overlap


for i = 1:size(notes_tr,1)
    sNote_tr(i).data=notes_tr(i,:);
    sNote_tr(i).gt_onsetsok=[];
    sNote_tr(i).gt_offsetsok=[];
    sNote_tr(i).ovlaptime=find(Moverlapped(:,i)>0);
    sNote_tr(i).ovlaptimepitch=find(Moverlapped_pitch(:,i)>0);
    sNote_tr(i).gt_split=[];
    sNote_tr(i).gt_merged=[];
end
for i = 1:size(notes_gt,1)
    sNote_gt(i).data=notes_gt(i,:);
    sNote_gt(i).tr_onsetsok=[];
    sNote_gt(i).tr_offsetsok=[];
    sNote_gt(i).ovlaptime=find(Moverlapped(i,:)>0);
    sNote_gt(i).ovlaptimepitch=find(Moverlapped_pitch(i,:)>0);
    sNote_gt(i).tr_split=[];
    sNote_gt(i).tr_merged=[];
end

%Find close onsets
for i = 1:length(sNote_tr)
    for j=1:length(sNote_gt)
        if(abs(sNote_gt(j).data(1)-sNote_tr(i).data(1)) <= onset_lim);
            sNote_tr(i).gt_onsetsok=[sNote_tr(i).gt_onsetsok j];
            sNote_gt(j).tr_onsetsok=[sNote_gt(j).tr_onsetsok i];
        end
    end
end

%Find close offsets
for i = 1:length(sNote_tr)
    for j=1:length(sNote_gt)
        offset = sNote_tr(i).data(1)+sNote_tr(i).data(2);
        durrange = max(min_dur_dist , sNote_gt(j).data(2)*dur_percent_range/100 );
        if (offset >= sNote_gt(j).data(1) + sNote_gt(j).data(2)-durrange) && ...
                (offset <= sNote_gt(j).data(1) + sNote_gt(j).data(2)+durrange)
            sNote_tr(i).gt_offsetsok=[sNote_tr(i).gt_offsetsok j];
            sNote_gt(j).tr_offsetsok=[sNote_gt(j).tr_offsetsok i];
        end
    end
end

%Find split notes
M_refg = L_g*Moverlapped;
M_reft = Moverlapped*L_t;
S = [];
t=0.4;
for i=1:size(M_refg,1)
    nflag =0;
    for j=1:size(M_refg,2)
        reft = M_reft(i,j);
        %The t% of the segment must overlap with the ref.
        if (reft>t)
            nflag=nflag+1;
        end
    end
    if (nflag>1)
        % All the short segments together must overlap the t% of the ref.
        if (sum(M_refg(i,:))>t)
            tr_split=find(M_reft(i,:)>t);
            sNote_gt(i).tr_split=tr_split;
            for j=tr_split
                sNote_tr(j).gt_split=i;
            end
        end
    end
end
%Find merged notes
M = [];
for j=1:size(M_reft,2)
    nflag =0;
    for i=1:size(M_reft,1)
        refg = M_refg(i,j);
        if (refg>t)
            nflag=nflag+1;
        end
    end
    if (nflag>1)
        gt_merged=find(M_refg(:,j)>t);
        sNote_tr(j).gt_merged=gt_merged;
        for i=gt_merged'
            sNote_gt(i).tr_merged=j;
        end
    end
end

%C=[ONSET_OK OFFSET_OK PITCH_OK]
C=[1 1 1; 1 0 0; 0 1 1; 1 0 1; 1 1 0];
for c = 1:5
    Fnotes_tr = [];
    Fnotes_gt = [];
    for i = 1:length(sNote_tr)
        aux_gtnotes=1:length(sNote_gt);
        if (C(c,1)==1)
            aux_gtnotes=intersect(aux_gtnotes,sNote_tr(i).gt_onsetsok);
        end
        if (C(c,2)==1)
            aux_gtnotes=intersect(aux_gtnotes,sNote_tr(i).gt_offsetsok);
        end
        if (C(c,3)==1)
            aux_gtnotes=intersect(aux_gtnotes,sNote_tr(i).ovlaptimepitch);
        end
        
        %Only one ground-truth <-> Transcribed note association
        aux_gtnotes=setdiff(aux_gtnotes,Fnotes_gt); %Ignore if already considered
        if ~isempty(aux_gtnotes)
            aux_gtnotes=aux_gtnotes(1);
            Fnotes_gt=unique([Fnotes_gt ...
                aux_gtnotes(1)]);
        end
    end
    eval(['notes_gt_',strrep(num2str(C(c,:)),' ',''),'=Fnotes_gt;']);
end

notes_gt_011b = setdiff(notes_gt_011,notes_gt_111);
notes_gt_101b = setdiff(notes_gt_101,notes_gt_111);
notes_gt_110b = setdiff(notes_gt_110,notes_gt_111);

Fnotes_tr_split = [];
Fnotes_gt_split = [];
Fnotes_tr_merged = [];
Fnotes_gt_merged = [];
Fnotes_tr_detected = [];
Fnotes_gt_detected = [];

for i = 1:length(sNote_tr)
    Fnotes_gt_split=[Fnotes_gt_split;sNote_tr(i).gt_split'];
    if ~isempty(sNote_tr(i).gt_split)
        Fnotes_tr_split=[Fnotes_tr_split i];
    end
    Fnotes_gt_detected=[Fnotes_gt_detected;sNote_tr(i).ovlaptime];
    Fnotes_gt_merged=[Fnotes_gt_merged;sNote_tr(i).gt_merged];
    if ~isempty(sNote_tr(i).gt_merged)
        Fnotes_tr_merged=[Fnotes_tr_merged i];
    end
    if ~isempty(sNote_tr(i).ovlaptime)
        Fnotes_tr_detected=[Fnotes_tr_detected i];
    end
end
N_GT=length(sNote_gt);
N_TR=length(sNote_tr);

S_listgt=unique(Fnotes_gt_split);
S_listtr=unique(Fnotes_tr_split);
M_listgt=unique(Fnotes_gt_merged);
M_listtr=unique(Fnotes_tr_merged);
ND_listgt=setdiff(1:N_GT,unique(Fnotes_gt_detected));
PU_listtr=setdiff(1:N_TR,unique(Fnotes_tr_detected));

% ---- Write output struct Results:
Results.Dur_GT=notes_gt(end,1)+notes_gt(end,2);
Results.Dur_TR=notes_tr(end,1)+notes_tr(end,2);
Results.N_GT=N_GT;
Results.N_TR=N_TR;
Results.COnPOff_listgt=notes_gt_111;
Results.COnPOff_Precision=length(notes_gt_111)/N_GT;
Results.COnPOff_Recall=length(notes_gt_111)/N_TR;
Results.COnPOff_Fmeasure=2*length(notes_gt_111)/(N_GT+N_TR);
Results.COnP_listgt=notes_gt_101;
Results.COnP_Precision=length(notes_gt_101)/N_GT;
Results.COnP_Recall=length(notes_gt_101)/N_TR;
Results.COnP_Fmeasure=2*length(notes_gt_101)/(N_GT+N_TR);
Results.COn_listgt=notes_gt_100;
Results.COn_Precision=length(notes_gt_100)/N_GT;
Results.COn_Recall=length(notes_gt_100)/N_TR;
Results.COn_Fmeasure=2*length(notes_gt_100)/(N_GT+N_TR);
Results.OBOn_listgt=notes_gt_011b;
Results.OBOn_rategt=length(notes_gt_011b)/N_GT;
Results.OBP_listgt=notes_gt_110b;
Results.OBP_rategt=length(notes_gt_110b)/N_GT;
Results.OBOff_listgt=notes_gt_101b;
Results.OBOff_rategt=length(notes_gt_101b)/N_GT;
Results.S_listgt=S_listgt';
Results.S_rategt=length(S_listgt)/N_GT;
Results.S_ratio=length(S_listtr)/length(S_listgt);
Results.M_listgt=M_listgt';
Results.M_rategt=length(M_listgt)/N_GT;
Results.M_ratio=length(M_listtr)/length(M_listgt);
Results.PU_listtr=PU_listtr';
Results.PU_ratetr=length(M_listtr)/N_TR;
Results.ND_listgt=ND_listgt;
Results.ND_rategt=length(ND_listgt)/N_GT;