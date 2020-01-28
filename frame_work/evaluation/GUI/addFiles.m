function datasetStruct = addFiles(datasetStruct)
datasetStructbackup=datasetStruct;
% Define possible exceptions
errformat = MException('ADDFILES:badfilesname',...
    'Files are not properly named (prefix: instance, sufix: transcriber; e.g. Audio1TranscriberA.txt).');
errwav = MException('ADDFILES:badwavfile', ...
    'Some files are not formatted as xxxxx.wav (e.g. audio1.wav)');
% Select files
[filename, pathname] = uigetfile({'*.*'},'File Selector','MultiSelect','on');
if isnumeric(filename) % It is numeric when no file is selected (filename==0)
    return
end
if ~iscell(filename) % When only ONE file is selected.
    aux=filename;
    filename={};
    filename{1}=aux; %We are working with cells all the time
end
%Get information
formatlist=cell(size(filename));
instancelist=cell(size(filename));
transcriberlist=cell(size(filename));
for i=1:length(filename)
    aux=regexp(filename{i},'[.]','split');
    %Store information
    if strcmp(aux{end},'wav')
        formatlist{i}='wav';
        instancelist{i}=aux{1};
        transcriberlist{i}='Audio';
    elseif strcmp(aux{end},'mid')
        formatlist{i}='mid';
        instancelist{i}=aux{1};
        transcriberlist{i}=aux{2};
    else
        formatlist{i}='other';
        instancelist{i}=aux{1};
        transcriberlist{i}=aux{2};
    end
end

%Find the row and column corresponding to each filename
[Bt,aux2,aux]=unique(transcriberlist);
for i=1:length(Bt)
    if ~any(strcmp(datasetStruct.columnnames,Bt{i}))
        L=length(datasetStruct.columnnames);
        datasetStruct.columnnames{L+1}=Bt{i};
        It(aux==i)=L+1;
    else
        auxid=find(strcmp(datasetStruct.columnnames,Bt{i}));
        It(aux==i)=auxid;
    end
end
[Bi,aux2,aux]=unique(instancelist);
for i=1:length(Bi)
    if  (isempty(datasetStruct.data(:,1))) || ~any(strcmp(datasetStruct.data(:,1),Bi{i}))
        L=length(datasetStruct.data(:,1));
        datasetStruct.data{L+1,1}=Bi{i};
        Ii(aux==i)=L+1;
    else
        auxid=find(strcmp(datasetStruct.data(:,1),Bi{i}));
        Ii(aux==i)=auxid;
    end
end
if (datasetStruct.columnGT==-1) && (length(datasetStruct.columnnames)>2)
    datasetStruct.columnGT=3;
end
% Add new data to the current struct
for c=2:length(datasetStruct.columnnames)
    ids=find(It==c); %Indexes of filename which corresponding to column c
    if ~isempty(ids)
        if (c>length(datasetStruct.format))||isempty(datasetStruct.format{c})
            if strcmp(formatlist{ids(1)},'other')
                vformat = GUI_dialogimport([pathname filename{ids(1)}],[]);
                if isempty(vformat)
                    datasetStruct=datasetStructbackup;
                    return;
                end
            else
                vformat = formatlist{ids(1)};
            end
            datasetStruct.format{c}=vformat;
        end
        for i=1:length(ids)
            datasetStruct.data{Ii(ids(i)),c}=filename{ids(i)};
            datasetStruct.paths{Ii(ids(i)),c}=relativepath(pathname);
        end
    end
end
end