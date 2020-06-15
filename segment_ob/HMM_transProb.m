% calculate transition probablity
% input: nSPP, nPPS, nS, minSemitoneDistance, maxJump, sigma2Note(the deviation of distantance distrubution); 
%        basicstates, statesname, 
% output: transProb_array (from; to; transProb)
function [transProb,transProb_array] = HMM_transProb(basicstates, statesname, nSPP, nPPS, nS, minSemitoneDistance, maxJump, sigma2Note, Tran_p)

%% calculate 'from' and 'to' vectors
% from and to list all the possibilities of transition 
% eg. 1 2 3 is three states of the first pitch 35,    4 5 6 is three states of
% the second pitch 35.333. 1to1 or 2, 2to2 or 3, 3to3 or 4 7 10.....; 
% the number of sequence increase from attack to silence

%get the sequence of the states
statesequence = zeros(2,nSPP);
statesequence(1,:) = 1:nSPP;
% get the class of every state in terms of basic states
for i_bstates = 1:size(basicstates,2)
    class_loc_statesname = find(contains(statesname,basicstates(i_bstates))==1);
    stateclass = i_bstates;
    statesequence(2,[class_loc_statesname]) = stateclass;
end
n_Attack = size(find(statesequence(2,:)==1),2)
% manually produce the transition possibilities except silence to attack (simple part)
% the from and to of the first pitch
from_sim_p1 = [1,1,2,2,3,3,3,4,4,5,5,6]; 
to_sim_p1 = [1,3,2,3,3,4,5,4,6,5,6,6]; 
% get all the pitch's
from_sim = [];
to_sim = [];
for i_steppitch = 1:nS*nPPS
    from_sim = [from_sim;from_sim_p1+(i_steppitch-1)*nSPP];
    to_sim = [to_sim;to_sim_p1+(i_steppitch-1)*nSPP];
end

% produe the transition possibilities of silence to attack (complex part)
    % determine the pitch steps which satisfy permitted pitch distance from silence to attack 
        % calculate pitch distance by collecting every ipitch(from) and jpitch(to)
        iPitch = zeros(nS*nPPS,nS*nPPS);
        jPitch = zeros(nS*nPPS,nS*nPPS);
        iPitch(1,:) = 0:nS*nPPS-1;
        iPitch = repmat(iPitch(1,:),nS*nPPS,1);
        jPitch(:,1) = 0:nS*nPPS-1;
        jPitch = repmat(jPitch(:,1),1,nS*nPPS);
        semitoneDistance = abs(iPitch - jPitch) * 1.0 / nPPS;
        %find the element in semitoneDistance which can satisfy the condition, 1 means can, 0 means can not. row loc is jPitch,
        % column loc is iPitch
        sati_Distance = semitoneDistance == 0 | (semitoneDistance > minSemitoneDistance & semitoneDistance < maxJump);
    % producing the complex part
    from_com = cell(nPPS*nS,1); to_com = cell(nPPS*nS,1);
    noteDistance = cell(nPPS*nS,1); % store the distance of pitch step between from and to 
    for i_ipitch = 1:nPPS*nS
        % get the loc of the ipitch and jpitch which satisfy the condition
        I  = sati_Distance(:,i_ipitch);
        loc_j = find(I==1);
        loc_i = i_ipitch*I([loc_j]);
        % duplicate the element because there are more than one attack states
        % in a pitch step
        loc_i_multi = repmat(loc_i,n_Attack,1);
        loc_j_multi = repelem(loc_j,n_Attack,1);
        noteDistance{i_ipitch} = abs(loc_i_multi'-loc_j_multi');
        % assign the squence value of the silence and attack state to the ipitch and jpitch loc
        % array
        from_com_temp = (loc_i_multi * nSPP)';% silence state
        from_com{i_ipitch} = from_com_temp;

        to_com_temp = zeros(1,length(loc_j_multi));
        to_com_temp(1:n_Attack:end) = 1+(loc_j_multi(1:n_Attack:end)'-1)*nSPP; % attack1 states
        to_com_temp(2:n_Attack:end) = to_com_temp(1:n_Attack:end)+1; % attack2 states
        to_com{i_ipitch} = to_com_temp;

    end


%% transition probablity
    % Simple
%     load('Tran_p');
    transProb_sim = zeros(1,nS*nPPS*length(from_sim_p1));%every 12 elements are from a pitch step
    
%     p_upAttackSelftrans = Tran_p{1,1}; p_downAttackSelftrans = Tran_p{2,1}; 
%     p_upAttack2Stable = 1-p_upAttackSelftrans; p_downAttack2Stable = 1-p_downAttackSelftrans; 
% 
%     pStableSelftrans = Tran_p{3,1}; 
%     pStable2Release = 1-pStableSelftrans; pStable2upRelease = pStable2Release/2; pStable2downRelease = pStable2Release/2;
% 
%     p_upReleaseSelftrans = Tran_p{4,1}; p_downReleaseSelftrans = Tran_p{5,1}; 
%     p_upRelease2Silence = 1-p_upAttackSelftrans; p_downRelease2Silence = 1-p_downAttackSelftrans;
% 
%     pSilentSelftrans = Tran_p{6,1};
%     transProb_sim = [p_upAttackSelftrans,p_upAttack2Stable,p_downAttackSelftrans,p_downAttack2Stable,...
%     pStableSelftrans,pStable2upRelease,pStable2downRelease,p_upReleaseSelftrans,p_upRelease2Silence,...
%     p_downReleaseSelftrans,p_downRelease2Silence,pSilentSelftrans];

    pAttackSelftrans = Tran_p(1); p_upAttackSelftrans = pAttackSelftrans; p_downAttackSelftrans = pAttackSelftrans; 
    pAttack2Stable = 1-pAttackSelftrans; p_upAttack2Stable = pAttack2Stable; p_downAttack2Stable = pAttack2Stable; 

    pStableSelftrans = Tran_p(2); 
    pStable2Release = 1-pStableSelftrans; pStable2upRelease = pStable2Release/2; pStable2downRelease = pStable2Release/2;

    pReleaseSelftrans = Tran_p(3); p_upReleaseSelftrans = pReleaseSelftrans; p_downReleaseSelftrans = pReleaseSelftrans; 
    pRelease2Silence = 1-pReleaseSelftrans; p_upRelease2Silence = pRelease2Silence; p_downRelease2Silence = pRelease2Silence;

    pSilentSelftrans = Tran_p(4);
    transProb_sim = [p_upAttackSelftrans,p_upAttack2Stable,p_downAttackSelftrans,p_downAttack2Stable,...
    pStableSelftrans,pStable2upRelease,pStable2downRelease,p_upReleaseSelftrans,p_upRelease2Silence,...
    p_downReleaseSelftrans,p_downRelease2Silence,pSilentSelftrans];

%     pAttackSelftrans = 0.9; p_upAttackSelftrans = pAttackSelftrans; p_downAttackSelftrans = pAttackSelftrans; 
%     pAttack2Stable = 1-pAttackSelftrans; p_upAttack2Stable = pAttack2Stable; p_downAttack2Stable = pAttack2Stable; 
% 
%     pStableSelftrans = 0.99; 
%     pStable2Release = 1-pStableSelftrans; pStable2upRelease = pStable2Release/2; pStable2downRelease = pStable2Release/2;
% 
%     pReleaseSelftrans = 0.9; p_upReleaseSelftrans = pReleaseSelftrans; p_downReleaseSelftrans = pReleaseSelftrans; 
%     pRelease2Silence = 1-pReleaseSelftrans; p_upRelease2Silence = pRelease2Silence; p_downRelease2Silence = pRelease2Silence;
% 
%     pSilentSelftrans = 0.9999;
%     transProb_sim = [p_upAttackSelftrans,p_upAttack2Stable,p_downAttackSelftrans,p_downAttack2Stable,...
%     pStableSelftrans,pStable2upRelease,pStable2downRelease,p_upReleaseSelftrans,p_upRelease2Silence,...
%     p_downReleaseSelftrans,p_downRelease2Silence,pSilentSelftrans];

    % Complex, transition probablity of silence to attack(a vector)
    %parameters
    sd = 0:1/nPPS:maxJump; %according to the condition of distance
    noteDistanceDistr = normpdf(sd, 0, sigma2Note); %obey Normal distribution, column vector

    % calculate transProb of silence to attack and combine complex part and simple part together according to pitch step
    from = []; to = []; transProb = [];
    for i_steppitch = 1:nS*nPPS
        from = [from,from_sim(i_steppitch,:),from_com{i_steppitch}];
        to = [to,to_sim(i_steppitch,:),to_com{i_steppitch}];
        transProb_com_temp = noteDistanceDistr([noteDistance{i_steppitch}+1]); 
        % normalization
        probSumS2A = sum(transProb_com_temp); %sum each column, equal to sum each loop
        transProb_com = transProb_com_temp./probSumS2A*(1-pSilentSelftrans);
        transProb = [transProb,transProb_sim,transProb_com];
    end
    % combine the from, to and prob together
    transProb_array = zeros(3,length(transProb));
    transProb_array(1,:) = from;
    transProb_array(2,:) = to;
    transProb_array(3,:) = transProb;
    % transform the array to matrix
    n = nSPP * nPPS * nS;
    transProb = zeros(n,n);
    for i = 1:size(transProb_array,2)
        row_t = transProb_array(1,i);
        col_t = transProb_array(2,i);  
        transProb(row_t,col_t) = transProb_array(3,i);
    end

end