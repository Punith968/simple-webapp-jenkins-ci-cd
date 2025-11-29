@echo off
REM deploy.bat — Windows batch version of deploy.sh
setlocal
set SRC=%cd%
set TARGET=%cd%\published_site
if not exist "%TARGET%" mkdir "%TARGET%"
copy /Y index.html "%TARGET%\index.html"
copy /Y styles.css "%TARGET%\styles.css"
copy /Y script.js "%TARGET%\script.js"
echo Deployment complete. Files copied to %TARGET%.
endlocal
