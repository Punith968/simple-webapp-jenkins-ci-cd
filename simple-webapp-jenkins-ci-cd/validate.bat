@echo off
REM validate.bat — Windows batch version of validate.sh
if not exist index.html (
  echo Missing: index.html
  exit /b 1
)
if not exist styles.css (
  echo Missing: styles.css
  exit /b 1
)
if not exist script.js (
  echo Missing: script.js
  exit /b 1
)
echo All required files present: index.html styles.css script.js
