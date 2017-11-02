set DB_PATH="%SRC_DIR%\temp-mongo-db"
set LOG_PATH="%SRC_DIR%\mongolog"
set DB_PORT=27272
set PID_FILE_PATH="%SRC_DIR%\mongopidfile"

mkdir "%DB_PATH%"

start /b cmd /c mongod --dbpath="%DB_PATH%" --logpath="%LOG_PATH%" --port="%DB_PORT%" --pidfilepath="%PID_FILE_PATH%"
if errorlevel 1 exit 1

pushd %SRC_DIR%

python setup.py test
set test_result=%errorlevel%

: Terminate the forked process after the test suite exits
set /P MONGO_PID=<%PID_FILE_PATH%
taskkill /F /PID %MONGO_PID%

if %test_result% neq 0 exit /b %test_result%

python setup.py install --single-version-externally-managed --record=record.txt
if errorlevel 1 exit 1