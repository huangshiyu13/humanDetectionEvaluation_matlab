for thr = 0.5:0.1:0.7
p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
close all

figTitle = ['Overlap Ratio = ' num2str(thr)];
saveImgPath = ['../../cvprPaper/supplementary/images/caltech_' num2str(thr) '.eps'];

resDir = '../../DATA/Caltech/res/';
resfiles = {'ev-haar.mat',...
            'ev-Reasonable-VJ.mat',...
            'ev-Reasonable-HOG.mat',...
            'ev-Reasonable-ACF.mat',...
            'ev-Reasonable-MT-DPM.mat',...
            'ev-ldcf.mat',...
            'ev-Reasonable-Checkerboards.mat',...
            'ev-rpn_origin.mat'};
types = {'c--','b--','r-','m-','y-','g-','c-','b-'};

names = {'HAAR','VJ','HOG','ACF','MT-DPM','LDCF','Checkerboards','Ours'};
n = length(resfiles);
assert(n == length(types));
res=cell(1,n);

gts = cell(1,n);
dts = cell(1,n);

for i = 1:n
    res{i} = load([resDir '/' resfiles{i}]);
%     names{i} = res{i}.R.stra;
    gts{i} = res{i}.R.gtr;
    dts{i} = res{i}.R.dtr;
end

yMin = 100;
xMax = 0;

samples = 10.^(-2:.25:0); % samples for computing area under the curve log-average miss rate
plotRoc = 1;
scores = zeros(length(names),1);

for i = 1:n
    disp(names{i});
    [xs,ys,~,score] = bbGt('compRoc',gts{i},dts{i},plotRoc, samples);
    if(plotRoc),  score=1-score; end
    if(plotRoc), score=exp(mean(log(score))); else score=mean(score); end
    scores(i) = roundn(score*100,-2);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,types{i},'LineWidth',3);
    
    yMin=min(yMin,min(ys)); 
    xMax=max(xMax,max(xs));
   
end
xlabel('false positives per image','FontSize',18,'FontWeight','bold');
ylabel('miss rate','FontSize',18,'FontWeight','bold');

grid on
yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
title(figTitle,'FontSize',14);
xlim([0 xMax]);
ylim([yMin, 1]);

for i = 1:length(names)
    names{i} = [num2str(scores(i)) '% ' names{i} ];
end
legend(names,'Position',[0.18,0.2,0.30,0.2],'FontSize',14,'FontWeight','bold');
saveas(gcf,saveImgPath,'psc2');
end
