% Draw confusion matric
% ConfMatPlot(CM,'key',value)
% CM: Confusion matric, every column is predicted values of samples of a true label
%   'labelname', deafult=numbers start from 1, the name of the x- and y-ticklabel
%   'power', default=1/3 ,0~1, smaller and the mislabeled values more visible
%   'MCcolor', default='bone', color of the confusion matric
%   'fontcolor_diag', default='black'
%   'fontcolor_nondiag', default='white'
%   'fontsize_acc',default=5
%   'MCsize',default=[0.118,0.2], width and hight

function [] = ConfMatPlot(CM,varargin)

p = inputParser;
addParameter(p,'labelname',1:length(CM));
addParameter(p,'power',1/3);
addParameter(p,'MCcolor','bone');
addParameter(p,'fontcolor_diag','black');
addParameter(p,'fontcolor_nondiag','white');
addParameter(p,'fontsize_acc',5);
addParameter(p,'MCsize',[0.118,0.2]);
parse(p,varargin{:});


figure
imagesc(CM.^p.Results.power)
colormap(p.Results.MCcolor)
xlabel('True label'); ylabel('Predicted label')
set(gca,'ytick',1:length(CM)); set(gca,'yticklabel',p.Results.labelname);
set(gca,'xtick',1:length(CM)); set(gca,'xticklabel',p.Results.labelname);
set(gcf,'unit','normalized','position',[0.1,0.1,p.Results.MCsize]);

for i = 1:length(CM)
    for j = 1:length(CM)
        if i == j
            text(i,j,[num2str(CM(j,i)*100), '%'],'fontsize',p.Results.fontsize_acc,'color',p.Results.fontcolor_diag,'HorizontalAlignment','center');
        else
            text(i,j,[num2str(CM(j,i)*100), '%'],'fontsize',p.Results.fontsize_acc,'color',p.Results.fontcolor_nondiag,'HorizontalAlignment','center');
        end
    end
end

end