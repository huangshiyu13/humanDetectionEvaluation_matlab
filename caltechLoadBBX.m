p = genpath('../toolbox');
addpath(p);
p = genpath('../../DATA/code3.2.1');
addpath(p);
clear all;

common = 'ldcf';
% anoDir = ['../../ATOCAR_CNN/results/rpn/' common '/'];
anoDir = ['../ACF/result/LdcfCaltech_caltechTest/bbout'];
saveName = ['../../DATA/Caltech/res/dt-' common '.mat'];
evasaveName = ['../../DATA/Caltech/res/ev-' common '.mat'];
stra=common; 
stre='';
anos = dir(fullfile(anoDir,'*.txt'));
len = size(anos,1);
len
dt = cell(1,len);
aspectRatio = .41;
parfor i = 1:len
    fileName = anos(i).name;
    bboxes = bbGt('acfbbload',[anoDir '/' fileName ]);
    bboxes=bbApply('resize',bboxes,0,0,aspectRatio); 
    dt{i}=bboxes;
end

save(saveName,'dt','-v6');

gt =  load('../../DATA/Caltech/res/gt-Reasonable.mat');
gt = gt.gt;
dt = load(saveName);
dt = dt.dt;

thr = 0.5;
[gt,dt] = bbGt('evalRes',gt,dt,thr,0);
[xs,ys] = bbGt('compRoc',gt,dt,1);
 ys = 1 - ys;
 plot(xs,ys,'LineWidth',3);
 set(gca,'XScale','log','YScale','log',...
        'XMinorGrid','on','XMinorTic','on',...
        'YMinorGrid','on','YMinorTic','on');
    title('ROC');
    xlim([0 10]);
    ylim([0 1]);
    xlabel('false positives per image','FontSize',14);
    ylabel('miss rate','FontSize',14);
    legend(stra);


R=struct('stra',stra,'stre',stre,'gtr',{gt},'dtr',{dt});
save(evasaveName,'R');
