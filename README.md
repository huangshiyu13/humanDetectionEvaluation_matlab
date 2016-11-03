# humanDetectionEvaluation_matlab

## 说明
这是做elvaluatino的matlab的仓库

读入groudtruth和test result，画出roc曲线

有个config file可以配置读入的文件夹和曲线的名字和颜色

这里只是给出个示例，具体项目可以具体有不同的写法

为了能够成功运行，需要把https://github.com/huangshiyu13/toolbox 项目并行放在一起

## 程序清单
evaluation.m 这个程序就是读入结果文件，画出roc曲线


configure/draw.cfg 
例子：
../../DATA/dangerousFinal/allResizedAno
result/syntheticDataAll_InriaBkg/bbout syntheticDataAll_InriaBkg g-
result/syntheticDataAll/bbout syntheticDataAll m-
result/Caltech2500/bbout Caltech2500 c--
result/Mix_Caltech2500/bbout Mix_Caltech2500 r-
result/Caltech1000/bbout Caltech1000 b-
result/Mix_Caltech1000/bbout Mix_Caltech1000 b--

images用于存储roc图片

