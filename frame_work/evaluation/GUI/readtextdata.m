function M = readtextdata(filename,skiplines)
delimiters=[' ,;|',char(9),char(13)];
fid = fopen(filename,'r');
for i=1:skiplines
    tline = fgets(fid);
end
tline = fgets(fid);
j=0;
M={};
while ischar(tline)
    j=j+1;
    i=1;
    auxst=[];
    for k = 1:length(tline)
        if isempty(strfind(delimiters,tline(k)))&&(k<length(tline))
            auxst=[auxst tline(k)];
        else
            M{j,i}=auxst;
            auxst=[];
            i=i+1;
        end
    end
    tline = fgets(fid);
end
end