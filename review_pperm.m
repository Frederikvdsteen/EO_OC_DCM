function [] = review_pperm(fil_file)


if nargin == 0
fil_file = 'stats*.mat';
end

    main_fig=figure('Units','normalized','Visible','on','Position',[0.1,0.1,0.6,0.8],'Color',[0.5 0.5 0.5],'name','please select analysis file','Menubar','none','Toolbar','Figure','NumberTitle','off','Tag','main_pperm');
h.main_quit    = uicontrol('Units','normalized','Style','pushbutton',...
    'String','Close','Position',[0.80,0.01,0.15,0.05],'FontSize',14,'BackgroundColor',[0.7 0.7 0.7]);
set(h.main_quit,'callback',{@quit_fcn,h});

h.main_load    = uicontrol('Units','normalized','Style','pushbutton',...
    'String','Load','Position',[0.1,0.01,0.15,0.05],'FontSize',14,'BackgroundColor',[0.7 0.7 0.7]);
set(h.main_load,'callback',{@load_fcn,fil_file});
h.main_prev    = uicontrol('Units','normalized','Style','pushbutton',...
    'String','Prev','Position',[0.35,0.01,0.15,0.05],'FontSize',14,'BackgroundColor',[0.7 0.7 0.7],'enable','off','Tag','previous_pperm');
set(h.main_prev,'callback',{@previous_fcn});
h.main_next    = uicontrol('Units','normalized','Style','pushbutton',...
    'String','next','Position',[0.55,0.01,0.15,0.05],'FontSize',14,'BackgroundColor',[0.7 0.7 0.7],'enable','off','Tag','next_pperm');
set(h.main_next,'callback',{@next_fcn});

% set (gcf, 'WindowButtonMotionFcn', @mouseMove);


function h = quit_fcn(hObject,eventdata,handles)

close all;clear all

function h = load_fcn(~,~,x)
main = findobj('Tag','main_pperm');
previous = findobj('Tag','previous_pperm');
next = findobj('Tag','next_pperm');
[dataDir] = uigetfile(x,'Multiselect','on');
setappdata(main,'files',dataDir)
setappdata(main,'ifile',1)
set(previous,'enable','on');
set(next,'enable','on');
  previous = findobj('Tag','previous_pperm');
  set(previous,'enable','off');
try
plot_pperm(dataDir{1})
catch
   plot_pperm(dataDir)
end

function [] = next_fcn(hObject,eventdata,handles)
main = findobj('Tag','main_pperm');
itmp = getappdata(main,'ifile');
dataDir = getappdata(main,'files');
setappdata(main,'ifile',itmp+1)
if itmp+1 == length(dataDir)
  next = findobj('Tag','next_pperm');
  set(next,'enable','off');
end
if itmp+1~= 1
      prev = findobj('Tag','previous_pperm');
  set(prev,'enable','on');
end

plot_pperm(dataDir{itmp+1});

function [] = previous_fcn(hObject,eventdata,handles)
main = findobj('Tag','main_pperm');
itmp = getappdata(main,'ifile');
dataDir = getappdata(main,'files');
setappdata(main,'ifile',itmp-1)
if itmp-1 == 1
  previous = findobj('Tag','previous_pperm');
  set(previous,'enable','off');
end
if itmp-1~=length(dataDir)
      next = findobj('Tag','next_pperm');
  set(next,'enable','on');
end
plot_pperm(dataDir{itmp-1});

    
    
    
    function [] = plot_pperm(dataDir)
        load(dataDir);
    names = fieldnames(Analysis.correction);
    subplot(ceil(length(fieldnames(Analysis.correction))/2),2,1)
%     disp(get(gca,'Position'))
    imagesc(Analysis.correction.(names{1}).thres);
    h =title(names{1});
    set(h,'interpreter','none')
    colorbar
    switch Analysis.dir
        case 'bigger'
    caxis([0 max(max(Analysis.observed_tvals))]);
        case 'smaller'
            caxis([min(min(Analysis.observed_tvals)) 0]);
        case 'both'
            caxis([min(min(Analysis.observed_tvals)) max(max(Analysis.observed_tvals))]);
    end
     set(gcf,'name',dataDir(1:end-4))
    for z = 2:length(fieldnames(Analysis.correction))
        
        subplot(ceil(length(fieldnames(Analysis.correction))/2),2,z)
        imagesc(Analysis.correction.(names{z}).thres);
        h =title(names{z});
        set(h,'interpreter','none')
        colorbar
            switch Analysis.dir
        case 'bigger'
    caxis([0 max(max(Analysis.observed_tvals))]);
        case 'smaller'
            caxis([min(min(Analysis.observed_tvals)) 0]);
        case 'both'
            caxis([min(min(Analysis.observed_tvals)) max(max(Analysis.observed_tvals))]);
    end
    end
%     function mouseMove (object, eventdata)
% 
% C = get (gcf, 'CurrentPoint');
% 
% disp(C)
