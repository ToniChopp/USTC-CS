# Xsudoku

## src目录
- sudoku.cpp 为未优化的代码
- sudoku_Optimized.cpp 为优化后的代码
- 对应的.exe文件为可执行文件
  
## 实验编写与环境
- Windows 10 + Visual Studio Code
- 使用 g++ 命令行编译运行
- 注： 请<u>务必</u>将输入放在 \input\ 目录下， 同时新建好 \output\ 目录用来装输出结果，否则无法正常运行程序

## 实验运行
``` shell
cd .\sudoku\src
g++ sudoku.cpp -o sudoku.exe
.\sudoku.exe

g++ sudoku_Optimized.cpp -o sudoku_Optimized.exe
.\sudoku_Optimized.exe
```
运行结果请在 \output\ 目录下对应的.txt文件中查看，文件名与输入相同，命令行仅输出是否完成以及运行时间