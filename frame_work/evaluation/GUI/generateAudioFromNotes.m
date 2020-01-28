function x = generateAudioFromNotes(notes,fs)
onset=0.01;
Lonset=onset*fs;
notes(:,1:2)=round(notes(:,1:2)*fs)+1;
x=zeros(1,notes(end,2));
for i=1:size(notes,1)
    L=notes(i,2)-notes(i,1);   
    f=440*2^((notes(i,3)-69)/12);
    xnote=0.7*sin((1:L)/fs*2*pi*f)+0.2*sin(2*(1:L)/fs*2*pi*f)+0.1*sin(3*(1:L)/fs*2*pi*f);
    xnote(1:Lonset)=rand(1,Lonset)*0.5;
    if L<Lonset
        xnote=xnote(1:L);
    end
    x(notes(i,1):(notes(i,2)-1))=xnote;
end
end