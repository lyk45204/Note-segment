%%%%%%% frequency transfer to semitone%%%%%%%%%
function semi = f2semi(f)
    semi = 69+12*log2(f/440); %transfer frequency to pitch
    a = isinf(semi); %return 1 (true) where the elements of A are +Inf or -Inf and logical 0 (false) where they are not
    semi(find(a == 1)) = 0;    

end