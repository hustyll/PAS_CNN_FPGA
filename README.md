——《基于FPGA的数字光声信号处理系统》

该项目主要设计四部分主要内容

一、数据预处理模块

功能：对输入数据降采样、滤波

技术要点：CIC抽取滤波器的RTL设计

结构图：![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/%E4%B8%89%E7%BA%A7CIC.png)

仿真波形图：![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/CIC%E4%BB%BF%E7%9C%9F.jpg)

二、用于浓度反演计算的CNN算法的RTL实现

CNN神经网络通常由卷积层和全连接层构成，单个卷积层包括卷积、激活和池化操作

该项目现已实现单个卷积层的并行加速以及流水线加速设计，设计框图如下
![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/%E5%8D%95%E5%B1%82%E5%8D%B7%E7%A7%AF%E5%8A%A0%E9%80%9F%E6%A1%86%E5%9B%BE.png)

三、对照组算法模块(正交数字锁相放大算法)

算法原理框图：![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/%E6%95%B0%E5%AD%97%E9%94%81%E7%9B%B8%E6%94%BE%E5%A4%A7%E7%AE%97%E6%B3%95.png)

波形仿真验证：![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/%E9%94%81%E7%9B%B8%E6%94%BE%E5%A4%A7%E7%AE%97%E6%B3%95%E4%BB%BF%E7%9C%9F%E6%B3%A2%E5%BD%A2.png)

四：基于AXI——stream总线的异步FIFO模块

作用：解决FPGA各模块与PCIE硬核之间的跨时钟域传输问题

仿真图：![image](https://github.com/hustyll/PAS_CNN_FPGA/blob/main/image/AXI_FIFO.png)


