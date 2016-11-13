clear all
close all
p = genpath('../toolbox');
addpath(p);

fid1=fopen('configure/draw_method.cfg');
groundtruth = '';
testFiles={};
testNames={};
type={};
i = 0;
while ~feof(fid1)
    aline=fgetl(fid1);
    if i == 0,
        strs = regexp(aline, ' ', 'split');
        groundtruth = strs{1};
        saveImgName = strs{2};
    else
       strs = regexp(aline, ' ', 'split');
       testFiles{i} = strs{1}; 
       
       testNames{i} = strs{2};
       type{i} = strs{3};
    end
    i=i+1;
end
fclose(fid1);
pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41},'hRng',[50 inf]};
p = {};
figure(1)
yMin = 100;
xMax = 0;
grid on;

samples = 10.^(-2:.25:0); % samples for computing area under the curve log-average miss rate
plotRoc = 1;
for i = 1:size(testFiles,2)
    [gt,dt] = bbGt( 'myLoadAll', groundtruth,testFiles{i},pLoad);
    thr = 0.5;
    [gt,dt] = bbGt('evalRes',gt,dt,thr,0);
    [xs,ys,~,score] = bbGt('compRoc',gt,dt,plotRoc, samples );
    if(plotRoc),  score=1-score; end
    if(plotRoc), score=exp(mean(log(score))); else score=mean(score); end
    disp({testNames{i},score});
    ys = 1 - ys;
    hold on;
    plot(xs,ys,type{i},'LineWidth',3);
    yMin=min(yMin,min(ys)); 
    xMax=max(xMax,max(xs));
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
end
yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
title('ROC');
xlim([0 xMax]);
ylim([yMin, 1]);

legend(testNames,'Position',[0.15,0.22,0.31,0.2],'FontSize',11,'FontWeight','bold');
% saveas(gcf,saveImgName);