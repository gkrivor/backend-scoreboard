@echo off
git checkout master
git pull
git add ../results
git diff-index --quiet HEAD
echo %ERRORLEVEL%
IF NOT "%ERRORLEVEL%" == "0" (
  git commit -m "Scoreboard results [skip ci]"
  git push
) ELSE (
    @echo Nothing to push
)
pause