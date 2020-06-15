classdef Obdistri_class
    %Obdistri_class is a class of observation distribution of different
    %attacks

    
    properties 
        states_name
        distr_name
        equation
        parameters_value
        
    end
    
    methods (Static)
        function ObsProb = calObsProb(pitchtrack,mu,obj,voicedProb,yinTrust)
            %calObsProb calculate the Obpro of a pitchtrack for one state
            %   the result contains the probablities of very frame of every
            %   pitch in one state. row is frame; column is pitch step.
            n_pitchsteps = length(mu);
            n_frame = size(pitchtrack,1);
            ObsProb = zeros(n_frame,n_pitchsteps);
            pitchtrack_mat = repmat(pitchtrack(:,2),1,n_pitchsteps);
            ind_nop = find(pitchtrack_mat==0); % the index of elements without pitch
            ObsProb(ind_nop) = 1; % the prob is 1 when there is no pitch

            ind_pitch = find(pitchtrack_mat~=0); % the index of elements with pitch
            diff = pitchtrack_mat - repmat(mu,n_frame,1);
            diff_pitch = diff(ind_pitch);
            if contains(obj.states_name,["Attack","Release"],'IgnoreCase',true)
                ind_p = find(diff_pitch>=0); ind_n = find(diff_pitch<=0);
                op_diff_pitch = zeros(size(diff_pitch,1),size(diff_pitch,2));
                if contains(obj.states_name,"up",'IgnoreCase',true)
                    op_diff_pitch(ind_n) = obj.equation([diff_pitch(ind_n)]);
                else %"down"
                    op_diff_pitch(ind_p) = obj.equation([diff_pitch(ind_p)]);
                end
            else
                op_diff_pitch = obj.equation([diff_pitch]);
            end
            ObsProb(ind_pitch) = voicedProb.^yinTrust .* op_diff_pitch;
        

        end
    end
end
