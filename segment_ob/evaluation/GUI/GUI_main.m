function [] = GUI_main()
fclose('all');
format long;
global data;
data=[];
data.currResults=[];
data.dataStruct=createdatastruct();
data.mainFig=figure('units','normalized','position',[0.02 0.12 0.7 0.8],'numbertitle','off','resize','on','menubar','none','name','Evaluation Framework for Singing Transcription (ISMIR 2014)');%,'WindowButtonDownFcn',@getClickOnFigure);
set(gcf,'Renderer','OpenGL')
data.maintabs=uitabgroup('Parent',data.mainFig);
%% Dataset Tab
data.datasettab=uitab(data.maintabs,'title','Dataset');
uicontrol('Parent',data.datasettab,'units','normalized','position',[0.02, 0.82, 0.3, 0.15],'Style','text','FontUnits','normalized','FontSize',0.2,'String',sprintf('Evaluation framework for automatic \n singing transcription'),'HorizontalAlignment','center','FontWeight','bold');
uicontrol('Parent',data.datasettab,'units','normalized','position',[0.02, 0.72, 0.3, 0.11],'Style','text','FontUnits','normalized','FontSize',0.2,'String',sprintf('published in ISMIR 2014 \n by \n ATIC Research Group'),'HorizontalAlignment','center');
data.tablefiles = uitable('Parent',data.datasettab,'Units','normalized','Position',[0.35 0.02 0.6 0.96], 'Data', data.dataStruct.data,'ColumnName', data.dataStruct.columnnames,'ColumnFormat', [],'ColumnEditable', [],'CellSelectionCallback',@cellSelect);
data.paneldatasetmanage=uipanel('Parent',data.datasettab,'units','normalized','position',[0.03 0.54 0.3 0.15],'title','Load & Save .eva files');
uicontrol('Parent',data.paneldatasetmanage,'units','normalized','Style','pushbutton','Position',[0.1 0.6 0.8 0.3],'String','Load dataset info.','Callback',@loadinfo);
uicontrol('Parent',data.paneldatasetmanage,'units','normalized','Style','pushbutton','Position',[0.1 0.1 0.8 0.3],'String','Save dataset info.','Callback',@saveinfo);
data.paneladdfiles=uipanel('Parent',data.datasettab,'units','normalized','position',[0.03 0.28 0.3 0.24],'title','Add files to the dataset');
uicontrol('Parent',data.paneladdfiles,'units','normalized','Style','text','Position',[0.1 0.2 0.8 0.2],'String','Ground-Truth column:','HorizontalAlignment','left','Callback',@changeGT);%,'Callback',@tomove);
data.gtpopup=uicontrol('Parent',data.paneladdfiles,'units','normalized','Style','popup','Position',[0.1 0.1 0.8 0.2],'String','---','Callback',@changeGT);%,'Callback',@tomove);
uicontrol('Parent',data.paneladdfiles,'units','normalized','Style','pushbutton','Position',[0.1 0.6 0.8 0.2],'String','Add files...','Callback',@buttonAddFiles,'tooltipString','Formatted');
data.paneleditcells=uipanel('Parent',data.datasettab,'units','normalized','position',[0.03 0.02 0.3 0.24],'title','Edit cells');
uicontrol('Parent',data.paneleditcells,'units','normalized','Style','pushbutton','Position',[0.1 0.7 0.8 0.2],'String','Remove selected rows','Callback',@buttonRemoveRow);
uicontrol('Parent',data.paneleditcells,'units','normalized','Style','pushbutton','Position',[0.1 0.4 0.8 0.2],'String','Remove selected columns','Callback',@buttonRemoveColumn);
uicontrol('Parent',data.paneleditcells,'units','normalized','Style','pushbutton','Position',[0.1 0.1 0.8 0.2],'String','Change format of selected columns','Callback',@changeFormatColumn);
%% Analysis Tab
data.Parameters.onsettol=50;
data.Parameters.offsettolms=50;
data.Parameters.offsettolper=20;
data.Parameters.pitchtol=50;
data.Parameters.splitmergeth=40;
data.currInst=1;
data.currTrans=1;
data.analysistab=uitab(data.maintabs,'title','Analysis');
data.panel_statistics = uipanel('Parent',data.analysistab,'units','normalized','position',[0.27 0.66 0.72 0.34],'title','Statistics');
data.statSingle = uitable('Parent',data.panel_statistics,'Units','normalized','Position',[0.02 0.02 0.4 0.8], 'Data', [],'ColumnWidth',{250,'auto'},'ColumnName', {'Eval. Measure','Value'},'ColumnFormat', [],'ColumnEditable', [],'RowName',[]);
data.statWhole = uitable('Parent',data.panel_statistics,'Units','normalized','Position',[0.45 0.02 0.53 0.8], 'Data', '','ColumnName', [],'ColumnFormat', [],'ColumnEditable', [],'Enable','on');
data.buttonDoAnalysisWhole = uicontrol('Parent',data.panel_statistics,'Units','normalized','Position',[0.5 0.85 0.2 0.1],'style','pushbutton','String','Analyse whole dataset','Callback',@doWholeDataset);
uicontrol('Parent',data.panel_statistics,'Units','normalized','Position',[0.74 0.85 0.2 0.1],'style','pushbutton','String','Export statistics','Callback',@exportStatistics);
uicontrol('Parent',data.panel_statistics,'Style', 'text','String', 'Current instance/transcriber','Units','normalized','Position',[0.02 0.82 0.4 0.1]);
data.panel_criteria = uipanel('Parent',data.analysistab,'units','normalized','position',[0.01 0.66 0.25 0.19],'title','Correctness criteria');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.05 0.8 0.3 0.1],'String','Onset tolerance: ','HorizontalAlignment','left');
data.onsettolerance=uicontrol('parent',data.panel_criteria,'units','normalized','Style','edit','Position',[0.32 0.78 0.1 0.12],'String','50','Callback',@changeParameters,'Enable','off');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.45 0.8 0.18 0.1],'String',' ms','HorizontalAlignment','left');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.05 0.65 0.34 0.1],'String','Offset tolerance: max(','HorizontalAlignment','left');
data.offsettolerance1=uicontrol('parent',data.panel_criteria,'units','normalized','Style','edit','Position',[0.4 0.63 0.1 0.12],'String','50','Callback',@changeParameters,'Enable','off');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.515 0.65 0.08 0.1],'String','ms ,','HorizontalAlignment','left');
data.offsettolerance2=uicontrol('parent',data.panel_criteria,'units','normalized','Style','edit','Position',[0.58 0.63 0.12 0.12],'String','20','Callback',@changeParameters,'Enable','off');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.7 0.65 0.3 0.1],'String',' % of duration)','HorizontalAlignment','left');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.05 0.5 0.3 0.1],'String','Pitch tolerance: +/- ','HorizontalAlignment','left');
data.pitchtolerance=uicontrol('parent',data.panel_criteria,'units','normalized','Style','edit','Position',[0.33 0.48 0.12 0.12],'String','50','Callback',@changeParameters,'Enable','off');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.45 0.5 0.2 0.1],'String',' cents','HorizontalAlignment','left');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.05 0.32 0.3 0.13],'String','Split-Merge thresh.: ','HorizontalAlignment','left');
data.splitmergeth=uicontrol('parent',data.panel_criteria,'units','normalized','Style','edit','Position',[0.35 0.32 0.12 0.12],'String','40','Callback',@changeParameters,'Enable','off');
uicontrol('parent',data.panel_criteria,'units','normalized','Style','text','Position',[0.48 0.34 0.2 0.1],'String',' %','HorizontalAlignment','left');
data.defaultsettings=uicontrol('parent',data.panel_criteria,'units','normalized','Style','checkbox','Position',[0.5 0.05 0.48 0.18],'String','Default settings (MIREX)','Callback',@defaultMirex,'Value',1);
data.panel_file = uipanel('Parent',data.analysistab,'units','normalized','position',[0.01 0.85 0.25 0.15],'title','File');
uicontrol('Parent',data.panel_file,'Style', 'text','String', 'Choose transcriber','Units','normalized','Position', [0.1 0.4 0.8 0.1]);
uicontrol('Parent',data.panel_file,'Style', 'text','String', 'Choose instance','Units','normalized','Position', [0.1 0.85 0.8 0.1]);
data.popupinstances=uicontrol('parent',data.panel_file,'units','normalized','Style','popupmenu','Position',[0.1 0.75 0.8 0.04],'String','-','Callback',@changeCurrInst);
data.popuptranscribers=uicontrol('parent',data.panel_file,'units','normalized','Style','popupmenu','Position',[0.1 0.3 0.8 0.04],'String','-','Callback',@changeCurrTrans);
data.panel_pianoroll = uipanel('Parent',data.analysistab,'units','normalized','position',[0.01 0.01 0.98 0.65],'title','View');
data.axlegend=axes('parent',data.panel_pianoroll,'position',[0.23 0.18 0.73 0.15],'XTickLabel','','YTickLabel','','XMinorGrid','off','YMinorGrid','off','XGrid','off','YGrid','off','XTick',[],'YTick',[],'Box','off','Color',[0,0,0],'XLim',[0 1],'YLim',[0 1]);
title('Legend:');
rectangle('Parent',data.axlegend,'Position',[0.05 0.1 0.15 0.3],'FaceColor',[0 0 0.7],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.3 0.1 0.15 0.3],'FaceColor',[0 0.7 0],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.5 0.1 0.15 0.3],'FaceColor',[0.7 0 0],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.8 0.2 0.15 0.1],'FaceColor',[0.7 0.7 0],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.05 0.1 0.02 0.3],'FaceColor',[0 0 1],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.3 0.1 0.02 0.3],'FaceColor',[0 1 0],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.5 0.1 0.02 0.3],'FaceColor',[1 0 0],'Clipping','On','LineWidth',0.1);
rectangle('Parent',data.axlegend,'Position',[0.8 0.2 0.005 0.1],'FaceColor',[1 1 0],'Clipping','On','LineWidth',0.1);
text(0.08,0.75,'Ground-Truth','Color',[1 1 1],'FontWeight','bold');
text(0.03,0.5,sprintf('Onset tol.'),'Color',[1 1 1]);
pitchtol_text=text(0.22,0.1,sprintf('Pitch\ntol.'),'Color',[1 1 1]);
set(pitchtol_text,'rotation',90);
text(0.4,0.75,'Highlighted Ground-Truth Notes','Color',[1 1 1],'FontWeight','bold');
text(0.3,0.5,sprintf('Green: Correct'),'Color',[1 1 1]);
text(0.5,0.5,sprintf('Red: Error'),'Color',[1 1 1]);
text(0.83,0.75,'Transcription','Color',[1 1 1],'FontWeight','bold');
data.pianorollax=axes('parent',data.panel_pianoroll,'position',[0.23 0.45 0.73 0.5]);
%data.panel_view = uipanel('Parent',data.panel_pianoroll,'units','normalized','position',[0.005 0.7 0.15 0.3],'title','Layers');
%data.checkbox_viewgt=uicontrol('Parent',data.panel_view,'Style','checkbox','units','normalized','position',[0.05 0.7 0.9 0.2],'String','View ground-truth');
%data.checkbox_viewtr=uicontrol('Parent',data.panel_view,'Style','checkbox','units','normalized','position',[0.05 0.5 0.9 0.2],'String','View transcription');
%data.checkbox_viewwav=uicontrol('Parent',data.panel_view,'Style','checkbox','units','normalized','position',[0.05 0.3 0.9 0.2],'String','View waveform');
%data.checkbox_viewspec=uicontrol('Parent',data.panel_view,'Style','checkbox','units','normalized','position',[0.05 0.1 0.9 0.2],'String','View spectrogram');
data.panel_play = uipanel('Parent',data.panel_pianoroll,'units','normalized','position',[0.005 0.012 0.15 0.98],'title','Play');
uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Audio (WAV file)','Units','normalized','Position', [0.05 0.91 0.7 0.04],'HorizontalAlignment','left');
data.textaudiovol=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Vol: 80','Units','normalized','Position', [0.5 0.85 0.4 0.04],'HorizontalAlignment','left');
data.textaudiopan=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Pan: L100','Units','normalized','Position', [0.5 0.78 0.4 0.04],'HorizontalAlignment','left');
data.audioslidervol=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.85 0.4 0.04],'Max',100,'Min',0,'Value',80,'Callback',@changeVolPan);
data.audiosliderpan=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.78 0.4 0.04],'Max',100,'Min',-100,'Value',-100,'Callback',@changeVolPan);
uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Ground-Truth','Units','normalized','Position', [0.05 0.71 0.7 0.04],'HorizontalAlignment','left');
data.textgtvol=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Vol: 0','Units','normalized','Position', [0.5 0.65 0.4 0.04],'HorizontalAlignment','left');
data.textgtpan=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Pan: 0','Units','normalized','Position', [0.5 0.58 0.4 0.04],'HorizontalAlignment','left');
data.gtslidervol=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.65 0.4 0.04],'Max',100,'Min',0,'Value',0,'Callback',@changeVolPan);
data.gtsliderpan=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.58 0.4 0.04],'Max',100,'Min',-100,'Value',0,'Callback',@changeVolPan);
uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Transcription','Units','normalized','Position', [0.05 0.51 0.7 0.04],'HorizontalAlignment','left');
data.texttrvol=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Vol: 20','Units','normalized','Position', [0.5 0.45 0.4 0.04],'HorizontalAlignment','left');
data.texttrpan=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Pan: R100','Units','normalized','Position', [0.5 0.38 0.4 0.04],'HorizontalAlignment','left');
data.trslidervol=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.45 0.4 0.04],'Max',100,'Min',0,'Value',20,'Callback',@changeVolPan);
data.trsliderpan=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.38 0.4 0.04],'Max',100,'Min',-100,'Value',100,'Callback',@changeVolPan);
uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Speed','Units','normalized','Position', [0.05 0.31 0.7 0.04],'HorizontalAlignment','left');
data.textspeed=uicontrol('Parent',data.panel_play,'Style', 'text','String', 'Speed: 100%','Units','normalized','Position', [0.5 0.25 0.4 0.04],'HorizontalAlignment','left');
data.speedslider=uicontrol('Parent',data.panel_play,'Style','slider','units','normalized','position',[0.05 0.25 0.4 0.04],'Max',200,'Min',20,'Value',100,'SliderStep',[0.002 0.1],'Callback',@changeSpeed);
uicontrol('Parent',data.panel_play,'Style', 'pushbutton','String', 'Play view','Units','normalized','Position', [0.1 0.03 0.3 0.1],'Callback',@playView);
uicontrol('Parent',data.panel_play,'Style', 'pushbutton','String', 'Stop','Units','normalized','Position', [0.5 0.03 0.3 0.1],'Callback',@stopPlay);
data.panel_navigate = uipanel('Parent',data.panel_pianoroll,'units','normalized','position',[0.53 0.005 0.43 0.15],'title','Navigate');
data.toggleplaynote=uicontrol('Parent',data.panel_navigate,'units','normalized','position',[0.85 0.25 0.1 0.5],'String','Play note','style','togglebutton','Callback',@playNoteAx,'Visible','off');
data.togglemove=uicontrol('Parent',data.panel_navigate,'units','normalized','position',[0.7 0.25 0.2 0.5],'String','Move','style','togglebutton','Callback',@moveAx);
data.togglezoomin=uicontrol('Parent',data.panel_navigate,'units','normalized','position',[0.4 0.25 0.2 0.5],'String','Zoom in','style','togglebutton','Callback',@zoomInAx);
data.togglezoomout=uicontrol('Parent',data.panel_navigate,'units','normalized','position',[0.1 0.25 0.2 0.5],'String','Zoom out','style','pushbutton','Callback',@zoomOutAx);
data.panel_highlight = uipanel('Parent',data.panel_pianoroll,'units','normalized','position',[0.23 0.005 0.29 0.15],'title','Highlight');
data.popuphighlight=uicontrol('parent',data.panel_highlight,'units','normalized','Style','popupmenu','Position',[0.05 0.7 0.9 0.04],'String',{'Correct Onset & Pitch & Offset (MIREX)','Correct Onset & Pitch','Correct Onset (MIREX)','Wrong Onset / Correct Pitch & Offset','Wrong Pitch / Correct Onset & Offset','Wrong Offset / Correct Onset & Pitch','Split','Merged','Spurious','Not-detected'},'Callback',@changeHighlight);
%% About Tab
try
    data.abouttab=uitab(data.maintabs,'title','About...');
    data.uiabouttext=uicontrol('Parent',data.abouttab,'style','edit','Max',100,'units','normalized','position',[.05 .05 .9 .9],'hor','left','Callback','global data;fname=''README.txt''; M=textread(fname,''%s'',''delimiter'',''\n''); set(data.uiabouttext,''string'',M)');
    fname='README.txt'; M=textread(fname,'%s','delimiter','\n'); set(data.uiabouttext,'string',M)
catch
    errordlg('README.txt is missing?');
end
end
%% Dataset Tab - Functions
function loadinfo(hObject,eventData)
global data;
[FileName,PathName] = uigetfile('*.eva','Load Dataset Info');
if ~isnumeric(FileName)
    load([PathName,FileName],'-mat','aux');
    data.dataStruct=aux;
    aux=data.dataStruct.columnGT;
    refreshTable();
    if aux>-1
        set(data.gtpopup,'Value',aux-2);
    end
    setZoom();
end
end
function saveinfo(hObject,eventData)
global data;
[FileName,PathName] = uiputfile('*.eva','Save Dataset Info');
if ~isnumeric(FileName)
    aux=data.dataStruct;
    save([PathName,FileName],'-mat','aux');
    refreshTable();
end
end
function cellSelect(src,evt)
% get indices of selected rows and make them available for other callbacks
index = evt.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    set(src,'UserData',index);
end
end
function buttonRemoveRow(hObject,eventData)
global data;
index = get(data.tablefiles,'UserData');
if size(index,1)>0
    rows = unique(index(:,1));
else
    rows=[];
end
if ~isempty(rows)
    data.dataStruct.data(rows,:)=[];
    data.dataStruct.paths(rows,:)=[];
    data.currInst=max(data.currInst-sum(rows<=data.currInst),1);
    if size(data.dataStruct.data,1)==0
        data.dataStruct = createdatastruct();
        set(data.tablefiles,'UserData',[]);
    end
    columnstoremove=[];
    for i=1:size(data.dataStruct.data,2)
        if isempty([data.dataStruct.data{:,i}])
            columnstoremove=[columnstoremove i];
        end
    end
    columnstoremove(columnstoremove<3)=[];
    if ~isempty(columnstoremove)
        set(data.tablefiles,'UserData',[columnstoremove' columnstoremove']);
        buttonRemoveColumn([],[]);
    end
    refreshTable();
end
end
function buttonRemoveColumn(hObject,eventData)
global data;
index = get(data.tablefiles,'UserData');
if size(index,1)>0
    columns = unique(index(:,2));
else
    columns=[];
end
columns(columns<3)=[]; %Avoid Instance Name and Audio
if ~isempty(columns)
    data.dataStruct.data(:,columns)=[];
    data.dataStruct.paths(:,columns)=[];
    data.dataStruct.columnnames(columns)=[];
    data.dataStruct.format(columns)=[];
    data.dataStruct.columnGT=max(data.dataStruct.columnGT-...
        sum(columns<=data.dataStruct.columnGT),3);
    data.currTrans=max(data.currTrans-...
        sum(columns+2<=data.currTrans),1);
    if size(data.dataStruct.columnnames,2)<3%data.dataStruct.columnGT<3
        data.dataStruct.columnGT=-1;
    end
end
if isempty([data.dataStruct.data{:,2:end}])
    data.dataStruct = createdatastruct(); %Reset
end
refreshTable();
end
function changeFormatColumn(hObject,eventData)
global data;
index = get(data.tablefiles,'UserData');
if size(index,1)>0
    columns = unique(index(:,2));
else
    columns=[];
end
columns(columns<2)=[]; %Avoid Instance Name and Audio
for i=columns
    if  length(data.dataStruct.format{i})>3
        for j=1:size(data.dataStruct.data(:,i))
            if ~isempty(data.dataStruct.data{j,i})
                break;
            end
        end
        data.dataStruct.format{i}=GUI_dialogimport(strrep([data.dataStruct.paths{j,i},data.dataStruct.data{j,i}],'\','/'),...
            data.dataStruct.format{i});
    else
        errordlg('.WAV or .MID formats can not be changed','Error');
    end
    
end
refreshTable();
end
function buttonAddFiles(hObject,eventData)
global data;
data.dataStruct =addFiles(data.dataStruct);
refreshTable();
setZoom();
end
function changeGT(hObject,eventData)
global data;
if ~strcmp(get(data.gtpopup,'String'),'---')
    if get(data.gtpopup,'Value')+2~=data.dataStruct.columnGT
        data.dataStruct.columnGT=get(data.gtpopup,'Value')+2;
        changeParameters([],[]);
    end
end
refreshTable();
end
function refreshTable()
global data;
if data.dataStruct.columnGT>-1
    set(data.gtpopup,'Value',data.dataStruct.columnGT-2);
else
    set(data.gtpopup,'Value',1);
end
if length(data.dataStruct.columnnames)>2
    set(data.gtpopup,'String',data.dataStruct.columnnames(3:end));
else
    set(data.gtpopup,'String','---');
end
colorgen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
auxdata=data.dataStruct.data;
% for i=1:length(auxdata(:,1))
%     auxdata{i,1}=colorgen('#FFEEEE',auxdata{i,1});
% end
set(data.tablefiles,'Data',auxdata);
set(data.tablefiles,'ColumnName',data.dataStruct.columnnames);
[instanceList,transcriberList]=listsForAnalysisPopup(data.dataStruct,data.currInst,data.currTrans);
aux=strjoin(instanceList,'|');
if isempty(aux)
    aux='-';
    data.currInst=1;
end
set(data.popupinstances,'Value',data.currInst);
set(data.popupinstances,'String',aux);
aux=strjoin(transcriberList,'|');
if isempty(aux)
    aux='-';
    data.currTrans=1;
end
set(data.popuptranscribers,'Value',data.currTrans);
set(data.popuptranscribers,'String',aux);
refreshPianorollStats()
drawnow();
end
%% Analysis Tab - Functions
function changeCurrInst(hObject,eventData)
global data;
data.currInst=get(hObject,'Value');
setZoom();
refreshTable();
end
function setZoom()
global data;
[notes_tr,notes_gt]=notesFromStruct(data.dataStruct,data.currInst,data.currTrans);
maxx=max([notes_tr(:,2);notes_gt(:,2)]);
miny=min([notes_tr(:,3);notes_gt(:,3)])-0.5;
maxy=max([notes_tr(:,3);notes_gt(:,3)])+0.5;
set(data.pianorollax,'XLim',[0 maxx], 'YLim', [miny maxy]);
zoom reset;
end
function changeCurrTrans(hObject,eventData)
global data;
data.currTrans=get(hObject,'Value');
refreshTable();
end
function playNoteAx(hObject,eventData)
global data;
pan off;
zoom off;
set(data.togglemove,'Value',0);
set(data.togglezoomin,'Value',0);
v=get(hObject,'Value');
end
function moveAx(hObject,eventData)
global data;
set(data.toggleplaynote,'Value',0);
set(data.togglezoomin,'Value',0);
zoom off;
v=get(hObject,'Value');
if v==1
    pan on;
else
    pan off;
end
end
function zoomInAx(hObject,eventData)
global data;
set(data.toggleplaynote,'Value',0);
set(data.togglemove,'Value',0);
%set(data.togglezoomin,'Value',0);
v=get(hObject,'Value');
pan off;
if v==1
    zoom on;
else
    zoom off;
end
end
function zoomOutAx(hObject,eventData)
global data;
set(data.togglemove,'Value',0);
set(data.togglezoomin,'Value',0);
set(data.toggleplaynote,'Value',0);
pan off;
zoom out;
zoom off;
end
function refreshPianorollStats()
global data;
% refreshStatistcs
[notes_tr,notes_gt]=notesFromStruct(data.dataStruct,data.currInst,data.currTrans);
data.currResults=[];
try
    data.currResults=data.dataStruct.stats{data.currInst,data.currTrans+2};
end
if isempty(data.currResults)
    data.dataStruct.stats{data.currInst,data.currTrans+2}=doAnalysis(notes_tr,notes_gt,data.Parameters);
    data.currResults=data.dataStruct.stats{data.currInst,data.currTrans+2};
end
highlight_gt=[];
highlight_tr=[];
switch get(data.popuphighlight,'Value')
    case 1
        highlight_gt=data.currResults.COnPOff_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[0 1 0],data.Parameters);
    case 2
        highlight_gt=data.currResults.COnP_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[0 1 0],data.Parameters);
    case 3
        highlight_gt=data.currResults.COn_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[0 1 0],data.Parameters);
    case 4
        highlight_gt=data.currResults.OBOn_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 5
        highlight_gt=data.currResults.OBP_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 6
        highlight_gt=data.currResults.OBOff_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 7
        highlight_gt=data.currResults.S_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 8
        highlight_gt=data.currResults.M_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 9
        highlight_tr=data.currResults.PU_listtr;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
    case 10
        highlight_gt=data.currResults.ND_listgt;
        pianoRoll(data.pianorollax,notes_tr,notes_gt,highlight_tr,highlight_gt,[1 0 0],data.Parameters);
end
%orderRes=[3 6 4 5 7 10 8 9 11 14 12 13 16 18 20 22 23 25 26 28 30 1 2 31 32];
r=struct2cell(data.currResults);
for i=[25 28];
    if isnan(r{i})
        r{i}='-';
    end
end

for i=[5 9 13 17 19 21 23 26 29 31]
    r{i}=length(r{i});
end
rowname={
    'Total Duration (GT)',...
    'Total Duration (Tr)',...
    'Total number of notes (GT)',...
    'Total number of notes (Tr)',...
    'Correct Onset, Offset & Pitch: No. Notes',...
    'Correct Onset, Offset & Pitch: Precision',...
    'Correct Onset, Offset & Pitch: Recall',...
    'Correct Onset, Offset & Pitch: F-measure',...
    'Correct Onset, & Pitch: No. Notes',...
    'Correct Onset, & Pitch: Precision',...
    'Correct Onset, & Pitch: Recall',...
    'Correct Onset, & Pitch: F-measure',...
    'Correct Onset: No. Notes',...
    'Correct Onset: Precision',...
    'Correct Onset: Recall',...
    'Correct Onset: F-measure',...
    'Wrong Onset / Correct Pitch & Offset: No. Notes (GT)',...
    'Wrong Onset / Correct Pitch & Offset: Rate (GT)',...
    'Wrong Pitch / Correct Onset & Offset: No. Notes (GT)',...
    'Wrong Pitch / Correct Onset & Offset: Rate (GT)',...
    'Wrong Offset / Correct Onset & Pitch: No. Notes (GT)',...
    'Wrong Offset / Correct Onset & Pitch: Rate (GT)',...
    'Split: No. Notes (GT)',...
    'Split: Rate (GT)',...
    'Split: Ratio (GT->TR)',...
    'Merge: No. Notes (GT)',...
    'Merge: Rate (GT)',...
    'Merge: Ratio (TR->GT)',...
    'Spurious: No. Notes (TR)',...
    'Spurious: Rate (TR)',...
    'Non-detected: No. Notes (GT)',...
    'Non-detected: Rate (GT)'};
r=[rowname' r];
set(data.statSingle,'Data',r);
end
function R=doAnalysis(notes_tr,notes_gt,Parameters)
R=classifyNotesv2(notes_tr,notes_gt,Parameters);
end
function changeParameters(hObject,eventData)
global data;
button = questdlg('Modifying the evaluation criteria will delete all current statistics. Continue?','Statistics will be deleted!','Yes','No','Yes');
if strcmp(button,'Yes')
    data.Parameters.onsettol=str2num(get(data.onsettolerance,'String'));
    data.Parameters.offsettolms=str2num(get(data.offsettolerance1,'String'));
    data.Parameters.offsettolper=str2num(get(data.offsettolerance2,'String'));
    data.Parameters.pitchtol=str2num(get(data.pitchtolerance,'String'));
    data.Parameters.splitmergeth=str2num(get(data.splitmergeth,'String'));
    for i=1:size(data.dataStruct.stats,1)
        for j=1:size(data.dataStruct.stats,2)
            data.dataStruct.stats{i,j}=[];
        end
        set(data.statWhole,'Data','');
    end
    refreshPianorollStats();
else
    set(data.onsettolerance,'String',num2str(data.Parameters.onsettol),'Enable','on');
    set(data.offsettolerance1,'String',num2str(data.Parameters.offsettolms),'Enable','on');
    set(data.offsettolerance2,'String',num2str(data.Parameters.offsettolper),'Enable','on');
    set(data.pitchtolerance,'String',num2str(data.Parameters.pitchtol),'Enable','on');
    set(data.splitmergeth,'String',num2str(data.Parameters.splitmergeth),'Enable','on');
    set(data.defaultsettings,'Value',0);
end
end
function defaultMirex(hObject,eventData)
global data;
if get(hObject,'Value')==1
    set(data.onsettolerance,'String','50','Enable','off');
    set(data.offsettolerance1,'String','50','Enable','off');
    set(data.offsettolerance2,'String','20','Enable','off');
    set(data.pitchtolerance,'String','50','Enable','off');
    set(data.splitmergeth,'String','40','Enable','off');
    if ((data.Parameters.onsettol~=50)||...
            (data.Parameters.offsettolms~=50)||...
            (data.Parameters.offsettolper~=20)||...
            (data.Parameters.pitchtol~=50)||...
            (data.Parameters.splitmergeth~=40))
        changeParameters([],[]);
    end
else
    set(data.onsettolerance,'Enable','on');
    set(data.offsettolerance1,'Enable','on');
    set(data.offsettolerance2,'Enable','on');
    set(data.pitchtolerance,'Enable','on');
    set(data.splitmergeth,'Enable','on');
end
end
function changeHighlight(hObject,eventData)
refreshPianorollStats()
end
function doWholeDataset(hObject,eventData)
global data;
nrows=size(data.dataStruct.data,1);
ncolumns=size(data.dataStruct.data,2);
hbar=waitbar(0,'');
c=0;
maxC=nrows*(ncolumns-2);
for i=1:nrows
    for j=3:ncolumns
        c=c+1;
        waitbar(c/maxC,hbar,sprintf('Instance: %i, Transcriber: %i',i,j));
        if ~isempty(data.dataStruct.data{i,j})
            [notes_tr,notes_gt]=notesFromStruct(data.dataStruct,i,j-2);
            % refreshStatistcs
            aux=[];
            try
                aux=data.dataStruct.stats{i,j};
            end
            if isempty(aux)
                data.dataStruct.stats{i,j}=doAnalysis(notes_tr,notes_gt,data.Parameters);
            end
        end
    end
end
close(hbar);
% Refresh whole statistics table
rowname={
    'Total Duration (GT)',...
    'Total Duration (Tr)',...
    'Total number of notes (GT)',...
    'Total number of notes (Tr)',...
    'Correct Onset, Offset & Pitch: Total No. Notes',...
    'Correct Onset, Offset & Pitch: Mean Precision',...
    'Correct Onset, Offset & Pitch: Mean Recall',...
    'Correct Onset, Offset & Pitch: Mean F-measure',...
    'Correct Onset, & Pitch: Total No. Notes',...
    'Correct Onset, & Pitch: Mean Precision',...
    'Correct Onset, & Pitch: Mean Recall',...
    'Correct Onset, & Pitch: Mean F-measure',...
    'Correct Onset: Total No. Notes',...
    'Correct Onset: Mean Precision',...
    'Correct Onset: Mean Recall',...
    'Correct Onset: Mean F-measure',...
    'Wrong Onset / Correct Pitch & Offset: Total No. Notes (GT)',...
    'Wrong Onset / Correct Pitch & Offset: Mean Rate (GT)',...
    'Wrong Pitch / Correct Onset & Offset: Total No. Notes (GT)',...
    'Wrong Pitch / Correct Onset & Offset: Mean Rate (GT)',...
    'Wrong Offset / Correct Onset & Pitch: Total No. Notes (GT)',...
    'Wrong Offset / Correct Onset & Pitch: Mean Rate (GT)',...
    'Split: Total No. Notes (GT)',...
    'Split: Mean Rate (GT)',...
    'Split: Mean Ratio (GT->TR)',...
    'Merge: Total No. Notes (GT)',...
    'Merge: Mean Rate (GT)',...
    'Merge: Mean Ratio (TR->GT)',...
    'Spurious: Total No. Notes (TR)',...
    'Spurious: Mean Rate (TR)',...
    'Non-detected: Total No. Notes (GT)',...
    'Non-detected: Mean Rate (GT)'};
dataw={};
for j=3:ncolumns
    c=0;
    auxc=[];
    for i=1:nrows
        if ~isempty(data.dataStruct.data{i,j})
            c=c+1;
            r=struct2cell(data.dataStruct.stats{i,j});
            for l=[5 9 13 17 19 21 23 26 29 31]
                r{l}=length(r{l});
            end
            for k=1:length(r)
                auxc(i,k)=r{k};
            end
        end
    end
    meanc=[6 7 8 10 11 12 14 15 16 18 20 22 24 25 27 28 30 32];
    for k=1:size(auxc,2)
        aux=auxc(:,k);
        if any(k==meanc)
            aux=aux(~isnan(aux));
            dataw{k,j-1}=mean(aux);
        else
            dataw{k,j-1}=sum(aux);
        end
    end
end
dataw(:,1)=rowname';
set(data.statWhole,'Data',dataw,'ColumnName',[{''},data.dataStruct.columnnames(3:end)]);
end
function exportStatistics(hObject,eventData)
global data;
try
    statisticsPerFile=data.dataStruct.stats(:,3:end);
    fileNames=data.dataStruct.data(:,3:end);
    wholeStatistics=get(data.statWhole,'Data');
    [FileName,PathName] = uiputfile('*.mat','Save statistics');
    if ~isnumeric(FileName)
        save([PathName,FileName],'statisticsPerFile','fileNames','wholeStatistics');
    end
catch
    errordlg('Export error!','Export error')
end
end
function playView(hObject,eventData)
global data;
[notes_tr,notes_gt]=notesFromStruct(data.dataStruct,data.currInst,data.currTrans);
wavfile=strrep([data.dataStruct.paths{data.currInst,2},data.dataStruct.data{data.currInst,2}],'\','/');
[x,fs]=wavread(wavfile);
xgt=generateAudioFromNotes(notes_gt,fs);
xtr=generateAudioFromNotes(notes_tr,fs);
maxL=max([length(x),length(xgt),length(xtr)]);
x(length(x)+1:maxL)=zeros(1,maxL-length(x));
xgt(length(xgt)+1:maxL)=zeros(1,maxL-length(xgt));
xtr(length(xtr)+1:maxL)=zeros(1,maxL-length(xtr));
xgt=xgt';
xtr=xtr';
xgt=xgt*get(data.gtslidervol,'Value')/100;
xtr=xtr*get(data.trslidervol,'Value')/100;
x=x*get(data.audioslidervol,'Value')/100;
pangt=get(data.gtsliderpan,'Value')/100;
st_xgt=[xgt*(1-pangt) xgt*(1+pangt)]*0.5;
pantr=get(data.trsliderpan,'Value')/100;
st_xtr=[xtr*(1-pantr) xtr*(1+pantr)]*0.5;
panx=get(data.audiosliderpan,'Value')/100;
st_x=[x*(1-panx) x*(1+panx)]*0.5;
out=st_x+st_xtr+st_xgt;
out_lims=round(get(data.pianorollax,'XLim')*fs);
t0=max(out_lims(1),1);
tf=min(out_lims(2),size(out,1));
sound(timeStretch(out(t0:tf,:),get(data.speedslider,'Value')/100),fs);

end
function stopPlay(hObject,eventData)
clear playsnd;
end
function changeVolPan(hObject,eventData)
global data;
%---
avol=get(data.audioslidervol,'Value');
apan=get(data.audiosliderpan,'Value');
svol=sprintf('Vol: %i',avol);
span='Pan: 0';
if apan<0
    span=sprintf('Pan: L%i',abs(apan));
elseif apan>0
    span=sprintf('Pan: R%i',apan);
end
set(data.textaudiovol,'String',svol);
set(data.textaudiopan,'String',span);
%---
avol=get(data.gtslidervol,'Value');
apan=get(data.gtsliderpan,'Value');
svol=sprintf('Vol: %i',avol);
span='Pan: 0';
if apan<0
    span=sprintf('Pan: L%i',abs(apan));
else
    span=sprintf('Pan: R%i',apan);
end
set(data.textgtvol,'String',svol);
set(data.textgtpan,'String',span);
%---
avol=get(data.trslidervol,'Value');
apan=get(data.trsliderpan,'Value');
svol=sprintf('Vol: %i',avol);
span='Pan: 0';
if apan<0
    span=sprintf('Pan: L%i',abs(apan));
else
    span=sprintf('Pan: R%i',apan);
end
set(data.texttrvol,'String',svol);
set(data.texttrpan,'String',span);
end
function changeSpeed(hObject,eventData)
global data;
%---
aspeed=round(get(data.speedslider,'Value'));
sspeed=sprintf('Speed: %i%%',aspeed);
set(data.textspeed,'String',sspeed);
end