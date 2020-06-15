%%%%%%%  semitone transfer to frequency%%%%%%%%%
function f = s2f(semi)
    f = 2.^((semi-69)/12)*440;   
end