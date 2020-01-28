%%%%%%% frequency transfer to pitch steps%%%%%%%%%
function pitch = f2s(f)
    lob=length(f); % length of observation list
    pitch = 69+12*log2(f/440); %transfer frequency to pitch
    a = isinf(pitch); %return 1 (true) where the elements of A are +Inf or -Inf and logical 0 (false) where they are not
    pitch(find(a == 1)) = 0;
    pitch2 = pitch(find(a == 0));     
    pitchrange = 35:1/3:104-1/3;
    % make pitch in oblist equal to those pitch in every step in range
    for j = 1:length(pitch2)
        [min_d,loc_d] = min(abs(pitch2(j)-pitchrange));%find which pitch is closet to current ob pitch
        pitch2(j) = pitchrange(loc_d); %get the current ob pitch equal to the pitch in the pitch range
    end 
    pitch(find(a == 0)) = pitch2;
end