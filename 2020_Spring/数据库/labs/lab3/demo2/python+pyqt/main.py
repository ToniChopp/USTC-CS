from PyQt5.QtWidgets import QApplication 
from PyQt5.QtWidgets import QMainWindow
from PyQt5.QtWidgets import QTableWidgetItem, QHeaderView
from PyQt5 import QtCore
from UI.ui_table import Ui_TablePage
from login import LoginDialog
from db import *

debug = False

class MainWindow(QMainWindow):
    " The Entrance of the Main window"
    def __init__(self):
        super().__init__()
        # 主窗口需要有一个UI界面，我们使用TablePage作为主窗口显示的UI界面
        self.ui = Ui_TablePage()
        self.ui.setupUi(self)

        # 初始化配置
        self.initLayout()
        self.initBinding()
        
        self.show()

        if debug:
            self.db = db_login("lyp1234", "1234", "127.0.0.1", "test")
            self.dbname = "test"
            self.ui.ClearBtn.setEnabled(True)
            self.ui.SearchBtn.setEnabled(True)
        else:
            self.db = None
            self.dbname = ''

    def initLayout(self):
        # 设置主窗口UI界面的初始布局
        self.ui.ClearBtn.setEnabled(False)
        self.ui.SearchBtn.setEnabled(False)
        self.ui.title.setText("All Tables for Database - ")
        self.ui.table.setColumnCount(2) # 不设置不显示这些列
        self.ui.table.setHorizontalHeaderLabels(['Table Name', 'Row Count'])
        self.ui.table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch) #设置表格等宽
        self.ui.table.horizontalHeader().setStyleSheet("QHeaderView::section{background:skyblue;}")
    
    def initBinding(self):
        # 将主界面按钮点击动作绑定到函数
        self.ui.ClearBtn.clicked.connect(self.clearTable)

        self.ui.SearchBtn.clicked.connect(self.renderTable)

        # 将菜单点击动作绑定到函数
        self.ui.actionLogin.triggered.connect(self.Login)

        self.ui.actionLogout.triggered.connect(self.LogOut)
    

    # all the function to bind with
    def clearTable(self):
        self.ui.table.setRowCount(0)

    def renderTable(self):
        self.ui.table.setRowCount(0)

        tabs = db_showtable(self.db)

        currentRowCount = self.ui.table.rowCount()
        for tab in tabs:
            self.ui.table.insertRow(currentRowCount)

            item0 = QTableWidgetItem(str(tab[0]))
            item0.setTextAlignment(QtCore.Qt.AlignCenter)
            item1 = QTableWidgetItem(str(tab[1]))
            item1.setTextAlignment(QtCore.Qt.AlignCenter)

            self.ui.table.setItem(currentRowCount, 0, item0) #列1
            self.ui.table.setItem(currentRowCount, 1, item1) #列2
            currentRowCount += 1
            self.ui.table.setRowCount(currentRowCount)

    def Login(self):
        dialog = LoginDialog(self)
        dialog.exec_()

        if self.db != None:
            self.ui.ClearBtn.setEnabled(True)
            self.ui.SearchBtn.setEnabled(True)
            self.ui.title.setText("All Tables for Database - " + self.dbname)
            self.renderTable()
    
    def LogOut(self):
        db_close(self.db)
        self.db = None
        self.dbname = ''
        self.ui.ClearBtn.setEnabled(False)
        self.ui.SearchBtn.setEnabled(False)
        self.clearTable()

if __name__ == "__main__":
    import sys

    app = QApplication(sys.argv)
    
    w = MainWindow()

    sys.exit(app.exec_())