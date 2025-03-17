# Matlab_simulation
This is a Matlab simulation project about ecological population competition, which has a UI interface and related demonstration videos.
## 程序运行指南
1. 点击test.m，让源路径在该文件夹下，点击运行

![img](/figs/图片1.png) 

2. 输入相关参数，可以自己定义，这里我给一个示例

![img](/figs/图片2.png) 

3. 点击start，开始仿真

![img](/figs/图片3.png) 

4. 仿真结束后，可以点击Save Picture,保存图片

保存时的界面：

![img](/figs/图片4.png) 

保存后提交显示：

![img](/figs/图片5.png) 

保存后的图像：

 

![img](/figs/图片6.png) 

5. 点击close，清除参数和仿真

![img](/figs/图片7.png) 

6. 点击pause to check,可以暂停10秒，然后继续运行

## 程序运行实例分析

分别用这个参数实例对三个模型进行分析：

![img](/figs/图片8.png) 

**对模型一：Lotka-Volterra竞争模型：**

 

![img](/figs/图片9.png) 

![img](/figs/图片10.png) 

食饵数量快速增长后受到捕食者掠取能力的抑制。

捕食者 1 和捕食者 2 的数量随食饵数量的变化而波动，同时因彼此竞争而进一步限制各自种群增长。因此有如下结果：

![img](/figs/图片11.png) 

**对模型二：捕食者-食物链模型：**

只考虑了捕食者1和食饵的参数，使用上面提出的捕食者-食物链模型：捕食者1和食饵是一个反比例关系，如下：

![img](/figs/图片12.png) 

**对模型三：捕食者-竞争模型：**

在该模型中，捕食者 1 和捕食者 2 对食饵的掠取能力直接影响各自的种群数量

![img](/figs/图片13.png) 
