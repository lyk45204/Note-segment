clc; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%reading%%%%%%%%%%%%%%%%%%%%
% batch reading pitch track, note ground truth files 
% get the filenames of all the files in one folder
% input: the path of the folder and the extension
% output: filenames

% br = batchreading;
% folder_path = 'C:\phd\Code\note segmentation\new_model\evaluate';
% 
% folder_pitchtrack = strcat(folder_path,'\pitchtrack');
% folder_note_gt = strcat(folder_path,'\gt');
% folder_rms = strcat(folder_path,'\loudness_rms');
% 
% extension_pitchtrack = '*.csv'; extension_rms = '*.csv'; 
% extension_note_gt = '*.txt';
% 
% filename_pitchtrack = br.file2filename(folder_pitchtrack,extension_pitchtrack);
% filename_note_gt = br.file2filename(folder_note_gt,extension_note_gt);
% filename_rms = br.file2filename(folder_rms,extension_rms);
% 
% % check if they have the same number of piece 
% n_files_pitchtrack = length(filename_pitchtrack);
% n_files_note_gt = length(filename_note_gt);
% n_files_rms = length(filename_rms);
% if n_files_pitchtrack == n_files_note_gt && n_files_rms == n_files_note_gt
%     n_files = n_files_pitchtrack;
% else
%     warning('The number of files of pitchtrack and gt shoul be equal')
% end
% % read these files
% pitchtrack_o = br.filename2cell(filename_pitchtrack, extension_pitchtrack);
% note_gt = br.filename2cell(filename_note_gt, extension_note_gt);
% m_level = br.filename2cell(filename_rms, extension_rms);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%% pre-process %%%%%%%%%%%%%%
% % transfer Hz to semitone and the negative value of pitch to 0
% pitchtrack = pitchtrack_o;
% for i_files = 1:n_files  
%     pitchtrack_o{i_files}(find(pitchtrack_o{i_files}(:,2)<0),2) = 0;
%     pitchtrack{i_files}(:,2) = f2semi(pitchtrack_o{i_files}(:,2));
% end
% % save
% save('pitchtrack.mat','pitchtrack');
% save('note_gt.mat','note_gt');
% save('m_level.mat','m_level');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% load data %%%%%%%%%%%%%%%%%%%%
addpath('evaluation/');
addpath('HMM_obsPro/');
addpath('+prob/'); % load laplace distribution

makedist -reset; % load laplace distribution
load('pitchtrack');
load('note_gt');
load('m_level');
n_files = size(pitchtrack,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% load HMM and calculate probability matrix %%%%%%%%%%%%%%

%% basic parameters of HMM

% State sequence
    basicstates = ["Attack","Stable","Release","Silence"];
    statesname = ["upAttack","downAttack","Stable","upRelease","downRelease","Silence"];
    nSPP = size(statesname,2); %number of states of per pitch(attack, stable, silence)
    % pitch scale of states
    nPPS = 3; %number of pitch of per semitone
    nS = 69; % number of semitones
    minPitch = 35; % the min semitone
    
% Observation sequence
%   pitchtrack{i_files}

% Initial probablity(silent state starts tracking)
    n = nS*nPPS*nSPP;
    init = zeros(n,1);
    init(nSPP:nSPP:end) = 1/nS/nPPS; %silence state

% Observation probablity
    % load observation distribution
    load('Obdistri_trained'); 
    Obdistri = Obdistri_trained;
    % calculation
        % set parameters 
        voicedProb = 0.9; % set the voiced probablity
        yinTrust = 0.1; % set the yinTrust
        % preallocate
        obsProb = cell(n_files,1);
        % calculate by using the function HMM_obsPro
        for i_files = 1:n_files
            pitchtrack_piece = pitchtrack{i_files};
            obsProb{i_files} = HMM_obsPro(nS,nPPS,nSPP,minPitch, Obdistri, pitchtrack_piece, voicedProb, yinTrust);
        end

% Transition probablity
    % possible transition probability sequences generation
        % possible transition probability array
        tranProb_value_trained = [0.999,0.9999,0.99999,0.999999];
        tranProb_value = tranProb_value_trained;
        % tran_value_pyin = [0.9, 0.99, 0.999, 0.9999];
        % tran_value = tran_value_pyin;

        % generate Permutations with repetition of sequence of all the possible transition
        % probabilities
        tranProb_permu = tranProb_gen(tranProb_value);
        
    % tranProb matrix calculation
        % set parameters
        minSemitoneDistance = 0.5; 
        maxJump = 13;
        sigma2Note = 0.7; %the deviation of distantance distrubution
        % preallocate
        n_tranProb_value = length(tranProb_value);
        n_permu = size(tranProb_permu,1);
        Tran_p = zeros(1,n_tranProb_value);
        transProb = cell(n_permu,1);
        % calculation tranProb
        for i_permu = 1:n_permu
            Tran_p = tranProb_permu(i_permu,:);
            transProb{i_permu} = HMM_transProb(basicstates, statesname, nSPP, nPPS, nS, minSemitoneDistance, maxJump, sigma2Note, Tran_p);
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%% grid search %%%%%%%%%%%%%%

% Metrics preallocate all the evaluation mesurements
load('Metrics_rowname.mat');
Metrics = cell(length(Metrics_rowname),n_permu+1);
Metrics(:,1) = Metrics_rowname;

% start search
i_search = i_permu;
n_search = n_permu;

parfor i_search = 1:n_search
    disp(sprintf ('Processing... %i_search / %i_search',i_search,n_search) );
    % get the tranProb matrix of one search tran prob sequence
    tranProb_search = transProb{i_search};
    
    % Viterbi algorithm get the best state sequence
    bestpath = cell(n_files, 1);
%     h=waitbar(0,'please wait');
    for i_files = 1:n_files
%         str=['running',num2str(i_files/n_files*100),'%'];
%         waitbar(i_files/n_files,h,str)
        bestpath{i_files}  = hmmViterbi(obsProb{i_files}',tranProb_search,init);
    end
    
    % MonoNote 
    noteout = cell(n_files, 1);
    for i_files = 1:n_files
        pitchtrack_piece = pitchtrack{i_files};
        path_piece = bestpath{i_files};
        noteout{i_files} = MonoNote(nSPP, nPPS, minPitch, path_piece, pitchtrack_piece);
    end  
    
    % post-process   
    inputSampleRate = 44100;
    pruneThresh = 0.1;
    stepSize = 256;
    onsetSensitivity = 0.7; 
    
    Notes = cell(n_files, 1);
    ind_silence = find(contains(statesname,"silence",'IgnoreCase',true)==1);
    
    for i_files = 1:n_files
        pitchtrack_piece = pitchtrack{i_files};
        noteout_piece = noteout{i_files};
        m_level_piece = m_level{i_files};
        [Notes{i_files}] = Postprocess(pitchtrack_piece, inputSampleRate, pruneThresh,...
            stepSize,noteout_piece, onsetSensitivity,m_level_piece, ind_silence);           
    end       
        
    % evaluation
    % input: listOfGroundTruthFiles,listOfTranscriptionFiles
    % they are cell variable which store the matrix of notes of all the pitch
    % track
    % output: the evaluation results
    
    % change the format of note_gt to standard one
    listOfGroundTruthFiles = cell(n_files, 1);
    listOfGroundTruthFiles = note_gt;
    
    % change the format of Notes to standard one
    listOfTranscriptionFiles = cell(n_files, 1);
    listOfTranscriptionFiles = Notes;
    
    % Evaluation:
    evalMeasures=evaluation1(listOfGroundTruthFiles, listOfTranscriptionFiles);
    % store the result to Metrics
    Metrics(:,i_search+1) = num2cell(evalMeasures);
    
end
Metrics_trained = Metrics;
save('Metrics_trained.mat','Metrics_trained');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    