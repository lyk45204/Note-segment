% notes segment algrithom
% reimplement pyin, which is based on HMM
% input: nSPP, nPPS, nS, minPitch, the pitch track file (two columns matrix)
%        basicstates, statesname,
% output: notes, it is a cell, every cell is the notes result of a pitch
% track
function path = HMM_noteseg(basicstates, statesname, nSPP, nPPS, nS, minPitch, pitchtrack_piece, Tran_p)


%% Transition probabality
% output: transProb_array (from; to; transProb)
% parameters of transition probablity of silence to attack
minSemitoneDistance = 0.5; 
maxJump = 13;
sigma2Note = 0.7; %the deviation of distantance distrubution
transProb_array = HMM_transProb(basicstates, statesname, nSPP, nPPS, nS, minSemitoneDistance, maxJump, sigma2Note, Tran_p);
transProb = zeros(n,n);
for i = 1:size(transProb_array,2)
    row_t = transProb_array(1,i);
    col_t = transProb_array(2,i);  
    transProb(row_t,col_t) = transProb_array(3,i);
end


%% Viterbi_decoder
% input: init, transProb_array, obsProb, nState, nFrame, nTrans
% output: the best path which contain state and pitch

% nState = n;
% nFrame = length(obsProb(:,1)); % number of the frames of the recording
% nTrans = length(transProb_array(3,:)); %// check for consistency, for multipy transProb 
% path = Viterbi_decoder(init, transProb_array, obsProb, nState, nFrame, nTrans);

path = hmmViterbi_(obsProb',transProb,init);
end


