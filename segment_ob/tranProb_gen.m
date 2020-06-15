%% this function is to generate all the possible transition probabilities sequence 
% input: tranProb_value(all the possible transition probability value
% array) 1*M (M = the number of possible values of transition probability)
% output: tranProb_permu(all the possible transition probabilities
% sequence) N*M (N = the number of possible sequence of transition probablities)

function tranProb_permu = tranProb_gen(tranProb_value)

M = length(tranProb_value);
permu = cell(M,1);
[permu{M:-1:1}] = ndgrid(1:4);
permu = reshape(cat(M+1,permu{:}),[],M); % Permutations with repetition of sequence
% preallocate all the possible transition probabilities
N = size(permu,1);
tranProb_permu = zeros(N,M);
% pick up all the possible transition probabilities sequence
for i_permu = 1:size(permu,1)
    for i_tranProb_value = 1:4
        tranProb_permu(i_permu, i_tranProb_value) = tranProb_value(permu(i_permu,i_tranProb_value));
    end
end