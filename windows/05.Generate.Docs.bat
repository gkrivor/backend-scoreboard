@echo off
call venv\Scripts\activate.bat
cd ..
python website-generator/generator.py --config setup/config.json
cd windows
call venv\Scripts\deactivate.bat
color 02
@echo Website has been updated
pause