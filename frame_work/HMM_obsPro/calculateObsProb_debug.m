%%%%%%%%%%%calculate O_prob%%%%%%%%%
%%%%%completely copy code of Tony%%%
function out = calculateObsProb_debug(iFrame,pitchProb,mu,nS,nSPP,nPPS,minPitch,yinTrust,pIsPitched,sigmaYinPitchAttack,sigmaYinPitchStable)
%store observation probablity of every pitch step in one frame, the observation
%probablity is getting from the candidates of this frame
    % input: pitchProb: column shows several candidates; row shows frame, first row is semitone
    % and second row is probablity
    % output: (n,1), observation probablity of one frame for every pitch
    % step of three states

%         %debug information
%     candidates_probablity = csvread('candidates_probablity.csv',0,1);%¸Ä
%     candidates_pitch = csvread('candidates_pitch.csv',0,1);%¸Ä
%     [cpm, cpn] = size(candidates_probablity);
%     cpn = cpn-1; %substract the time column 
%     pitchProb_c = zeros(2*cpm, cpn); %store pitch and probablity
%     pitchProb_c(1:2:end,:) = candidates_pitch(:,2:end);
%     pitchProb_c(2:2:end,:) = candidates_probablity(:,2:end); %every two rows are a frame, one is pitch and one is probablity 
% 
%     pitchProb = pitchProb_c(2*1-1:2*1,:);
%     pitchProb(1,:) = f2s(pitchProb(1,:));
%     nS = 69; %number of semitones
%     nPPS = 3; %number of pitch per semitone
%     nSPP = 3;
%     minPitch = 35; %the lowest pitch
%     iPitch = 0:1:nS*nPPS-1; %every step of pitch
%     mu = minPitch + iPitch/nPPS;  % column vector
%     sigmaYinPitchAttack = 5; 
%     sigmaYinPitchStable = 0.8;
%     %pitchDistr is an array(n,nS*nPPS)
%     pitchDistr = getpitchDistr(nS,nPPS,nSPP,minPitch,sigmaYinPitchAttack,sigmaYinPitchStable);
%     pIsPitched = pvoiced(pitchProb(iFrame*2,:)); 
%     %
    
%     getMidiPitch = repmat(mu,nSPP,1);
%     getMidiPitch = getMidiPitch(:);%row vector,(35 35 35 35.333 35.333 35.333 ......)'
    getMidiPitch = mu';
    getMidiPitch = sort(repmat(getMidiPitch,nSPP,1));
    
    sigmaYinPitch = [sigmaYinPitchAttack,sigmaYinPitchStable,0]';
    sigmaYinPitch = repmat(sigmaYinPitch,nSPP*nS,1);
    pitchProb_c_s = pitchProb(2*iFrame-1,:);%get the semitone row
    pitchProb_c_p = pitchProb(2*iFrame,:);%get the probablity row
    tempProbSum = 0;
    yinTrust = 0.1;
    n = nS*nSPP*nPPS;
    out = zeros(n,1);
    for i = 1:1:n; % traverse every step of pitch from 35 to 85 to get the tempProb
            if rem(i,nSPP)~=0
                tempProb = 0;
                if max(pitchProb_c_p)>0 % exist candidate
                    minDist = 10000; 
                    minDistProb = 0; %one frame has one element
                    minDistCandidate = 0;
                    for iCandidate = 1:length(pitchProb_c_s);                    
                            currDist = abs(getMidiPitch(i)-pitchProb_c_s(iCandidate)); %row vector, get distance of candidate pitch to current mu
                            if currDist < minDist
                                minDist = currDist; %minDist stores the current mini distance
                                minDistProb = pitchProb_c_p(iCandidate); %the probablity of current candidate
                                minDistCandidate = iCandidate;%the squence number of current candidate
                            end
                    end
                    tempProb = minDistProb.^yinTrust .* normpdf(pitchProb_c_s(minDistCandidate), getMidiPitch(i), sigmaYinPitch(i));
%                     tempProb = minDistProb.^yinTrust .* pitchDistr(i, round(pitchProb_c_s(minDistCandidate)-0)/0.01+1)'; 
                else
                    tempProb = 1;
                end
            tempProbSum = tempProbSum+tempProb;
            out(i) = tempProb;                
            end

    end

    if tempProbSum>0
       out = out./tempProbSum.*pIsPitched(iFrame); %attack and stable state
    end
    out(3:3:end) = (1-pIsPitched(iFrame)) / (nPPS * nS); %silence state
    
%     out1 = out(1:3:end);
%     out2 = out(2:3:end);    
%     out3 = out(3:3:end);
%     figure(1);
%     plot(mu,out1);
%     hold on;
%     plot(mu,out2,'r');
%     hold on;
%     plot(mu,out3,'y');
%     hold off;
         
                
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%the original code in the main file for calculate O_prob%%%%%%%%%%%%
%     %% set parameters
% tempProbSum = 0; %sum of tempProb in order to realize normalising
% out = zeros(1, n); % a vector to store tempProb of every step of pitch, column 
% yinTrust = 0.1; % how much the pitch estimate is trusted
% getMidiPitch = repmat(mu,nSPP,1); %row vector storing each step of pitch, and every one has three times repetation
% 
% %% calculate every frame's probablity in every state
% O_prob = zeros(1,lob);
% n = nPPS * nS * nSPP;
% h=waitbar(0,'please wait');
% for ii = 1:2:2*lob   
%     str=['running',num2str(ii/lob*100),'%'];
%     waitbar(ii/lob,h,str)
%     for i = 1:1:n; % traverse every step of pitch from 35 to 85 to get the tempProb
%         if rem(i,nSPP)~=0
%             tempProb = 0;
%             if size(pitchProb,1)>0
%                 minDist = 10000.0;
%                 minDistProb = 0;
%                 minDistCandidate = 0;
%                 for iCandidate = 1:size(pitchProb,1);                                                                
%                 currDist = abs(getMidiPitch(i)-pitchProb(iCandidate, ii)); %get distance of pitch
%                     if (currDist < minDist)         
%                         minDist = currDist;
%                         minDistProb = pitchProb(iCandidate, ii+1); %the probablity of current pitch of this frame
%                         minDistCandidate = iCandidate;
%                     end
%                 end
%                 pitch_minDistCandidate = pitchProb(minDistCandidate, ii);
%                 tempProb = minDistProb.^yinTrust * pitchDistr(i, round((pitch_minDistCandidate-0)*nPPS+1)); 
%             else
%                 tempProb = 1;
%             end
%             tempProbSum = tempProbSum+tempProb;
%             out(i) = tempProb;
%         end
%     end
%     %calculate every frame's probablity
%     out = out / tempProbSum * pIsPitched; % probablity distribution of this frame
%     out_a = out(1:3:end);% (1:3:end) are for attack state and (2:3:end) are for stable state
%     out_s = out(2:3:end);
%     out(3:3:end) = (1-pIsPitched) / (nPPS * nS); % for silent stat
%     O_prob_a(1,(ii+1)/2) = out(round((oblist((ii+1)/2)-35)*3)+1); %put the current pitch of this frame into the distribution to calculate probalbity
%     O_prob_s(1,(ii+1)/2) = out(round((oblist((ii+1)/2)-35)*3)+1);
%     O_prob_silence(1,(ii+1)/2) = out(3);
% end
% O_prob = [O_prob_a;O_prob_s;O_prob_silence];
% the output include three states. Every state has a different distribution, including every frame's Obpro. 
%Every row represents the every frame's Obpro of one state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%