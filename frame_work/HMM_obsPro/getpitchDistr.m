%%%%%%%%%pitchDistr%%%%%%%%%%
function pitchDistr = getpitchDistr(nS,nPPS,nSPP,minPitch,sigmaYinPitchAttack,sigmaYinPitchStable)
%get mu(the mean of the distribution)
nS = 69; %number of semitones
nPPS = 3; %number of pitch per semitone
nSPP = 3; %number of states per pitch

iPitch = 0:1:nS*nPPS-1; %every step of pitch
minPitch = 35; %the lowest pitch
mu = minPitch + iPitch/nPPS; % a vector which include every mu of their pitch
% if max(oblist)>mu(end)
%     x_pitchDistr = 0:1/nPPS:max(oblist)+1/nPPS; % the horizontal axis
% else
%     x_pitchDistr = 0:1/nPPS:mu(end)+1/nPPS; % the horizontal axis
% end
x_pitchDistr = 0:0.01:2*mu(end); % the horizontal axis, broden 35:1/3:103.667 to allow the nearest candidtate's pitch out of the mu range

%set the sigma
sigmaYinPitchAttack = 5; 
sigmaYinPitchStable = 0.8;
%get the pitchDistr of every pitch step in two states
n = nS*nPPS*nSPP;
pitchDistr = zeros(n,length(x_pitchDistr));
for index = (iPitch(1)+1):3:((iPitch(end)+1)*nSPP)
    pitchDistr(index,:) = normpdf(x_pitchDistr, mu(floor(index/3)+1), sigmaYinPitchAttack);
    pitchDistr(index+1,:) = normpdf(x_pitchDistr, mu(floor(index/3)+1), sigmaYinPitchStable);
    pitchDistr(index+2,:) = normpdf(x_pitchDistr, mu(floor(index/3)+1), 1); %fake
end
for i = 1:nS*nPPS
% figure(1)
% plot(x_pitchDistr,pitchDistr(3*i-2,:));
% hold on;
% plot(x_pitchDistr,pitchDistr(3*i-1,:),'r');
% hold on;
% plot(x_pitchDistr,pitchDistr(3*i,:),'y');
% hold off;
end
