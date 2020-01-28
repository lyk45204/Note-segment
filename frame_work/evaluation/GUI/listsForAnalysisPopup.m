function [instanceList,transcriberList]=listsForAnalysisPopup(dataStruct,currInst,currTrans)
nrows=size(dataStruct.data,1);
ncolumns=size(dataStruct.data,2);
if (nrows==0) || (ncolumns<3)
    instanceList={''};
    transcriberList={''};
else
    instanceList={};
    transcriberList={};
    for i=1:nrows
        filen=dataStruct.data{i,currTrans+2};
        inst=dataStruct.data{i,1};
        if isempty(filen)
            instanceList{i}={[inst,' (MISSING)']};
        else
            instanceList{i}={inst};
        end
    end
    for j=1:ncolumns-2
        filen=dataStruct.data{currInst,j+2};
        tran=dataStruct.columnnames{j+2};
        if isempty(filen)
            transcriberList{j}={[tran,' (MISSING)']};
        else
            transcriberList{j}={tran};
        end
    end
end
end