% notes segment algrithom
% reimplement pyin, which is based on HMM
% input: nSPP, nPPS, nS, minPitch, the pitch track file (two columns matrix)
% output: notes, it is a cell, every cell is the notes result of a pitch
% track
function path = HMM_noteseg(nSPP, nPPS, nS, minPitch, pitchtrack_piece)

%% Initial probablity, silent state starts tracking
n = nS*nPPS*nSPP;
init = zeros(n,1);
init(3:3:end) = 1/nS/nPPS; %silence state
%% Transition probabality
% output: transProb_array (from; to; transProb)
% parameters of transition probablity of silence to attack
minSemitoneDistance = 0.5; 
maxJump = 13;
sigma2Note = 0.7; %the deviation of distantance distrubution
transProb_array = HMM_transProb(nSPP, nPPS, nS, minSemitoneDistance, maxJump, sigma2Note);
%% Observation probablity
% output: the observation probablity of every frame for every state of each
% step of pitch; row stores each frame and column stores each pitch step in three states

% set parameters
% set the obspro distribution
sigmaYinPitchAttack = 5; 
sigmaYinPitchStable = 0.8;
% set the voiced probablity
voicedProb = 0.9;
% set the yinTrust
yinTrust = 0.1;
% use the function HMM_obsPro
% pitchtrack = pitchtrack(1:1100,:);
obsProb = HMM_obsPro(nS,nPPS,nSPP,minPitch, sigmaYinPitchAttack, ...
    sigmaYinPitchStable, pitchtrack_piece, voicedProb, yinTrust);

%% Viterbi_decoder
% input: init, transProb_array, obsProb, nState, nFrame, nTrans
% output: the best path which contain state and pitch
nState = n;
nFrame = length(obsProb(:,1)); % number of the frames of the recording
nTrans = length(transProb_array(3,:)); %// check for consistency, for multipy transProb 
path = Viterbi_decoder(init, transProb_array, obsProb, nState, nFrame, nTrans);

end


