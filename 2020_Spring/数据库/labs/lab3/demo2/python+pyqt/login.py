from PyQt5.QtWidgets import QDialog, QMessageBox
from UI.ui_login import Ui_LoginDialog

from db import db_login

class LoginDialog(QDialog):
    "A dialog class for Ui_LoginDialog, who can show itself"
    def __init__(self, parent):
        super(LoginDialog, self).__init__(parent)
        self.ui = Ui_LoginDialog()
        self.ui.setupUi(self)

        self.ui.LoginBtn.clicked.connect(self.login)

        self.parent = parent
    
    def login(self):
        ipaddr = self.ui.ipaddr.text()
        dbname = self.ui.database.text()
        username = self.ui.username.text()
        password = self.ui.password.text()

        db = db_login(username, password, ipaddr, dbname)

        if db == None:
            QMessageBox.information(self,'提示','登录失败!', QMessageBox.Close, QMessageBox.Close)
        
        # that a bad way to comunicate with other window, but it is easy
        self.parent.db = db
        self.parent.dbname = dbname

        self.close()