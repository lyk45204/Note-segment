%% Observation probablity( Prob of observation given the state)
% input: 
%    pitchDistr: nS,nPPS,nSPP,minPitch, sigmaYinPitchAttack, sigmaYinPitchStable, 
%    probablity of voiced: pitchtrack, voicedProb
%    calculateobsProb: yinTrust
% output: obsProb: row stores each frame and column stores each pitch step in three states
function obsProb = HMM_obsPro(nS,nPPS,nSPP,minPitch, sigmaYinPitchAttack, ...
    sigmaYinPitchStable, pitchtrack, voicedProb, yinTrust)
%% pitchDistr
% it is an array(n,nS*nPPS)
% x: the pitch of a frame
% y: the probablity of that the frame is a certain state
% iPitch = zeros(nS*nPPS,nS*nPPS);
% mu = minPitch + iPitch/nPPS;  % column vector
iPitch = 0:1:nS*nPPS-1; %every step of pitch
minPitch = 35; %the lowest pitch
mu = minPitch + iPitch/nPPS; % a vector which include every mu of their pitch

% pitchDistr = getpitchDistr(nS,nPPS,nSPP,minPitch,sigmaYinPitchAttack,sigmaYinPitchStable);
%£¨n,nS*nPPS£©each row represent a state, from attack to silent, and also every three rows are one mu(from minisemi); and each column represent a pitch step
%the horizontal axis x_pitchDistr = 0:1/nPPS:nS-1/nPPS;
%% calculate prior probablity of voiced
% set the voicedProb of every frame
n_frame = length(pitchtrack);
pitch_and_Prob = zeros(2*n_frame,1);
pitch_and_Prob(1:2:end,:) = pitchtrack(:,2);
pitch_and_Prob(2:2:end,:) = voicedProb;
pitch_and_Prob(find(pitchtrack(:,2) == 0) *2) = 0;
% transfer frequency to pitch
pitch_and_Prob_mu = pitch_and_Prob;
pitch_and_Prob_mu(1:2:end,:) =  69+12*log2(pitch_and_Prob(1:2:end,:)/440);
pitch_and_Prob_prob = pitch_and_Prob(2:2:end,:); %array containing the second row which is of probablity
pIsPitched = pvoiced(pitch_and_Prob_prob); %row vector which stores each frame's  probality of voiced
% pIsPitched = pvoiced(pitchProb_pro); %row vector which stores each frame's  probality of voiced
%% calculate observation probablity of each frame
n = nS*nPPS*nSPP;
obsProb = zeros(n_frame,n); %row stores each frame and column stores each pitch step in three states
h=waitbar(0,'please wait');
% for iFrame = 1947:1987
for iFrame = 1:n_frame
    str=['running',num2str(iFrame/n_frame*100),'%'];
    waitbar(iFrame/n_frame,h,str)
    obsProb(iFrame,:) = calculateObsProb_debug(iFrame,pitch_and_Prob_mu,mu,nS,nSPP,nPPS,minPitch,yinTrust,pIsPitched,sigmaYinPitchAttack,sigmaYinPitchStable);
end

end