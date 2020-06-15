function [notes_tr,notes_gt]=notesFromStruct(dataStruct,currInst,currTrans)
hopsize=0.001;
if dataStruct.columnGT~=-1
    if isempty(dataStruct.data{currInst,dataStruct.columnGT})
        errordlg(sprintf('GROUND-TRUTH file is MISSING!... please, add it to the dataset!'));
        notes_tr=[];
        notes_gt=[];
        return;
    end
filegt=strrep([dataStruct.paths{currInst,dataStruct.columnGT} dataStruct.data{currInst,dataStruct.columnGT}],'\','/');
filetr=strrep([dataStruct.paths{currInst,currTrans+2} dataStruct.data{currInst,currTrans+2}],'\','/');
formatgt=dataStruct.format{dataStruct.columnGT};
formattr=dataStruct.format{currTrans+2};
%TODO: Diferenciar MIDI y TXT
if strcmp(dataStruct.format{dataStruct.columnGT},'mid')
    [~,notes_gt]=midi2matrixnotes(filegt,hopsize);
    notes_gt(:,2)=notes_gt(:,2)+notes_gt(:,1);
else
    vformat=dataStruct.format{dataStruct.columnGT};
    M=readtextdata(filegt,vformat(7));
    M=[M(:,vformat(2)),M(:,vformat(4)),M(:,vformat(6))];
    Maux=[];
    for i=1:size(M,1)
        Maux(i,1)=str2num(M{i,1});
        Maux(i,2)=str2num(M{i,2});
        Maux(i,3)=str2num(M{i,3});
    end
    M=Maux;
    switch vformat(3)
        case 2
            M(:,2)=M(:,2)+M(:,1);
    end
    notes_gt=M;
end

if strcmp(dataStruct.format{currTrans+2},'mid')
    [~,notes_tr]=midi2matrixnotes(filetr,hopsize);
    notes_tr(:,2)=notes_tr(:,2)+notes_tr(:,1);
else
    vformat=dataStruct.format{currTrans+2};
    M=readtextdata(filetr,vformat(7));
    M=[M(:,vformat(2)),M(:,vformat(4)),M(:,vformat(6))];
    Maux=zeros(size(M));
    for i=1:size(M,1)
        Maux(i,1)=str2num(M{i,1});
        Maux(i,2)=str2num(M{i,2});
        Maux(i,3)=str2num(M{i,3});
    end
    M=Maux;
    switch vformat(3)
        case 2
            M(:,2)=M(:,2)+M(:,1);
    end
    notes_tr=M;
end
else
    notes_gt=[];
    notes_tr=[];
end
end