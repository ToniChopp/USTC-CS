创建了两个ui文件
login.ui : Dialog 类型窗口
table.ui : MainWindow 类型窗口

使用pyuic将其编译称为对应的python文件

注意: 生成的python文件本身不能启动，因为它只定义了ui本身，不具有自我启动的能力，因此需要定义一个QDialog/QMainWindow 作为ui的载体，见main.py和login.py