@echo off

echo tranforming login.ui
pyuic5 -o ui_login.py login.ui

echo tranforming table.ui
pyuic5  -o ui_table.py table.ui

pause

@echo on