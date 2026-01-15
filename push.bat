@echo off
echo Starting to push...

:: 添加所有文件
git add .

:: 提交，并把当前日期时间自动作为 Commit 信息
git commit -m "Auto update: %date% %time%"

:: 推送
git push

echo.
echo Done! 
pause