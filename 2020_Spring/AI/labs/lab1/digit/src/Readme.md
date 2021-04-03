# digit

## src目录
- digit_AStar.cpp 为A*搜索代码
- digit_IDAStar.cpp 为IDA*的代码
- 对应的.exe文件为可执行文件
  
## 实验编写与环境
- Windows 10 + Visual Studio Code
- 使用 g++ 命令行编译运行
- 注： 请<u>务必</u>将输入放在 \input\ 目录下， 同时新建好 \output\ 目录用来装输出结果，否则无法正常运行程序

## 实验运行
``` shell
cd .\digit\src
g++ digit_AStar.cpp -o digit_AStar.exe
.\digit_AStar.exe

g++ digit_IDAStar.cpp -o digit_IDAStar.exe
.\digit_IDAStar.exe
```
运行结果请在 \output\ 目录下对应的.txt文件中查看，文件名相同，命令行也输出步骤与时间