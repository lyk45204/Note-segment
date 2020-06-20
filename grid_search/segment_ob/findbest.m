%% this function is to get the best performance tran Prob sequence
% input: Metrics, rowname_ind, tranProb_value
% output: the value, and the tran Prob sequence which has the value

function [best_mat] = findbest(Metrics, rowname_ind, tranProb_value)

% preallocate 
best_mat = cell(length(rowname_ind),3);

Metrics_v = Metrics(:,2:end); % get the value part of the metrics cell array
Metrics_v_mat = cell2mat(Metrics_v); % transform the cell to matrix

[best_v, best_Tran_p_ind] = max(Metrics_v_mat(rowname_ind,:),[],2);

% get the best_Tran_p from tranProb_permu
tranProb_permu = tranProb_gen(tranProb_value);
best_Tran_p = tranProb_permu(best_Tran_p_ind,:);

% assign the result to best_mat
Metrics_rowname = Metrics(:,1); % get the rowname array of the metrics cell array
best_mat(:,1) = Metrics_rowname(rowname_ind);
best_mat(:,2) = num2cell(best_v);
best_mat(:,3) = num2cell(best_Tran_p,2);

end




