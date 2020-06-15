function pianoRoll(ax, notes_tr,notes_gt,highlight_tr,highlight_gt,c_highlight,Parameters)
onsettol=Parameters.onsettol;
%Parameters.offsettolms;
%Parameters.offsettolper;
tolgt=Parameters.pitchtol;
%Parameters.splitmergeth;
cla(ax);
set(ax,'Color',[0,0,0]);
xlabel('Time (s)');
ylabel('Note (MIDI number)');
%maxx=max([notes_tr(:,2);notes_gt(:,2)]);
%miny=min([notes_tr(:,3);notes_gt(:,3)])-0.5;
%maxy=max([notes_tr(:,3);notes_gt(:,3)])+0.5;
for i=10:2:120
    rectangle('Parent',ax,'Position',[0 i-0.5 300 1],'FaceColor',[0, 0.1, 0.1],'Clipping','On','LineWidth',0.1);
    %rectangle('Parent',ax,'Position',[0 i+0.5 300 1],'FaceColor',[0, 0.05, 0.05],'Clipping','On','LineWidth',0.1);
end
%set(ax,'XLim',[0 maxx], 'YLim', [miny maxy]);
%zoom reset;
if ~isempty(notes_tr) && ~isempty(notes_gt)
    notes_tr(1:end,1:2)=round(notes_tr(1:end,1:2)*1000);
    notes_gt(1:end,1:2)=round(notes_gt(1:end,1:2)*1000);
    
    for i=1:length(notes_gt)
        x=notes_gt(i,1);
        xw=notes_gt(i,2)-notes_gt(i,1);
        y=notes_gt(i,3)*100-(tolgt);
        yh=tolgt*2;
        x=x/1000;
        xw=xw/1000;
        y=y/100;
        yh=yh/100;
        c=[0,0,1];
        if any(highlight_gt==i)
            c=c_highlight;
        end
        rectangle('Parent',ax,'Position',[x y xw yh],'FaceColor',c*0.7,'Clipping','On','LineWidth',0.1);%,'ButtonDownFcn',{@clickOnRectangle,notes_gt,ax});
        rectangle('Parent',ax,'Position',[x y onsettol/1000 yh],'FaceColor',c,'Clipping','On','LineWidth',0.1);%,'ButtonDownFcn',{@clickOnRectangle,notes_gt,ax});
        aux=max(0.05,0.2*xw);
        %line([x+xw-aux x+xw+aux],[y+yh/2 y+yh/2],'Color',c,'LineWidth',2);
        %line([x+xw-aux x+xw-aux],[y-0.04 y+yh+0.04],'Color',c,'LineWidth',2);
        %line([x+xw+aux x+xw+aux],[y-0.04 y+yh+0.04],'Color',c,'LineWidth',2);
    end
    height_tr=15;
    for i=1:length(notes_tr)
        x=notes_tr(i,1);
        xw=notes_tr(i,2)-notes_tr(i,1);
        y=notes_tr(i,3)*100-(height_tr/2);
        yh=height_tr;
        x=x/1000;
        xw=xw/1000;
        y=y/100;
        yh=yh/100;
        c=[1,1,0];
        if any(highlight_tr==i)
            c=c_highlight;
        end
        rectangle('Parent',ax,'Position',[x y xw yh],'FaceColor',c*0.7,'Clipping','On','LineWidth',0.1);%,'ButtonDownFcn',{@clickOnRectangle,notes_tr,ax});
        rectangle('Parent',ax,'Position',[x y onsettol/1000 yh],'FaceColor',c,'Clipping','On','LineWidth',0.1);%,'ButtonDownFcn',{@clickOnRectangle,notes_tr,ax});
    end
    xticks=str2num(get(ax,'XTickLabel'));
    yticks=str2num(get(ax,'YTickLabel'));
    for i=1:length(xticks)
        xtickl{i}=sprintf('%.3f',xticks(i)/1000);
    end
    for i=1:length(yticks)
        ytickl{i}=sprintf('%.2f',yticks(i)/100);
    end
end
end
