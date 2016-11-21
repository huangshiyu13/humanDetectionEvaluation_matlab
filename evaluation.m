for thr = 0.5:0.1:0.7

close all
p = genpath('../toolbox');
addpath(p);

configFile = 'configure/draw_compare_syn.cfg';

figTitle = ['Overlap Ratio = ' num2str(thr)];

fid1=fopen(configFile);
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
        imageNow = strs{2};
    else
       strs = regexp(aline, ' ', 'split');
       if length(strs) <= 2
           break;
       end
       testFiles{i} = strs{1}; 
       
       testNames{i} = strs{2};
       type{i} = strs{3};
    end
    
    i=i+1;
end
saveImgPath = ['../../cvprPaper/supplementary/images/' imageNow '_' num2str(thr) '.eps'];

fclose(fid1);
pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41},'hRng',[50 inf]};
p = {};
figure(1)
yMin = 100;
xMax = 0;
grid on;

samples = 10.^(-2:.25:0); % samples for computing area under the curve log-average miss rate
plotRoc = 1;
scores = zeros(length(testNames),1);
for i = 1:size(testFiles,2)
    [gt,dt] = bbGt( 'myLoadAll', groundtruth,testFiles{i},pLoad);
    [gt,dt] = bbGt('evalRes',gt,dt,thr,0);
    [xs,ys,~,score] = bbGt('compRoc',gt,dt,plotRoc, samples );
    if(plotRoc),  score=1-score; end
    if(plotRoc), score=exp(mean(log(score))); else score=mean(score); end
    disp({testNames{i},score*100});
    scores(i) = roundn(score*100,-2);
    ys = 1 - ys;
    hold on;
    plot(xs,ys,type{i},'LineWidth',3);
    yMin=min(yMin,min(ys)); 
    xMax=max(xMax,max(xs));
    
end

xlabel('false positives per image','FontSize',18,'FontWeight','bold');
    ylabel('miss rate','FontSize',18,'FontWeight','bold');

yt=[.05 .1:.1:.5 .64 .8]; ytStr=int2str2(yt*100,2);
for i=1:length(yt), ytStr{i}=['.' ytStr{i}]; end
set(gca,'XScale','log','YScale','log',...
        'YTick',[yt 1],'YTickLabel',[ytStr '1'],...
        'XMinorGrid','off','XMinorTic','off',...
        'YMinorGrid','off','YMinorTic','off');
title(figTitle,'FontSize',14);
xlim([0 xMax]);
ylim([yMin, 1]);

for i = 1:length(testNames)
    testNames{i} = [num2str(scores(i)) '% ' testNames{i} ];
end

legend(testNames,'Position',[0.15,0.15,0.30,0.2],'FontSize',14,'FontWeight','bold');
saveas(gcf,saveImgPath,'psc2');
end