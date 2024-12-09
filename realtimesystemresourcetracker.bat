@echo off
setlocal EnableDelayedExpansion

:: Set default color: Green text on black background
color 0A

:: Display title
cls
echo =====================================================
echo       Welcome to Realtime System Resource Tracker
echo =====================================================
echo          Checks your CPU, Memory, and Disk Usage
pause

:: Ask if the user wants to create a log file
set logfile=
set /p createLog="Do you want to create a log file? (Y/N): "
if /i "%createLog%"=="Y" (
    set logfile=RealtimeSystemResourceTrackerLog.txt
    (
        echo ========================================
        echo Real-time System Resource Tracker Log - %date% %time%
        echo ========================================
    ) > "%logfile%"
)

:: Set warning thresholds
set cpuWarningThreshold=80
set memWarningThreshold=80

:menu
cls
echo ==========================================
echo       Real-time System Resource Tracker
echo ==========================================
echo Choose system resource you would like to check.
echo.
echo [1] Check CPU Usage
echo [2] Check Memory Usage
echo [3] Check Disk Usage
echo [Q] Quit
echo.
set /p choice="Choose an option: "

if "%choice%"=="1" goto checkCPU
if "%choice%"=="2" goto checkMemory
if "%choice%"=="3" goto checkDisk
if /i "%choice%"=="Q" exit /b

goto menu

:checkCPU
cls
color 0A
echo ========================================
echo       Checking CPU Usage...
echo ========================================
for /f "tokens=2 delims==" %%i in ('wmic cpu get loadpercentage /value ^| find "="') do set cpu=%%i
echo CPU Usage: !cpu!%%
if !cpu! gtr %cpuWarningThreshold% (
    echo WARNING: High CPU usage detected: !cpu!%%
    if defined logfile (
        echo [WARNING] High CPU usage detected: !cpu!%% >> "%logfile%"
    )
)
if defined logfile (
    echo [%date% %time%] CPU Usage: !cpu!%% >> "%logfile%"
)
goto checkAgain

:checkMemory
cls
color 0A
echo ========================================
echo       Checking Memory Usage...
echo ========================================
:: Fetch memory statistics
for /f "tokens=2 delims==" %%j in ('wmic OS get FreePhysicalMemory /value ^| find "="') do set "freeMemBefore=%%j"
for /f "tokens=2 delims==" %%k in ('wmic OS get TotalVisibleMemorySize /value ^| find "="') do set "totalMem=%%k"

:: Calculate memory usage in MB and percentage
set /a "usedMemBefore=totalMem-freeMemBefore"
set /a "memUsage=(usedMemBefore * 100) / totalMem"
set /a "usedMemMB=usedMemBefore / 1024"
set /a "totalMemMB=totalMem / 1024"

:: Display memory usage
echo Memory Usage: !usedMemMB! MB / !totalMemMB! MB (!memUsage!%%)

:: Check if memory usage exceeds warning threshold
if !memUsage! gtr %memWarningThreshold% (
    echo WARNING: High memory usage detected: !memUsage!%%
    echo.
    echo Would you like to free some memory?
    echo [F] Free memory (WARNING: This will close running applications)
    echo [C] Cancel
    set /p "freeMemChoice=Your choice (F/C): "

    :: Handle the user's choice
    if /i "!freeMemChoice!"=="F" (
        echo Attempting to free memory...
        taskkill /F /FI "STATUS eq NOT RESPONDING" >nul

        :: Re-check memory statistics after freeing memory
        for /f "tokens=2 delims==" %%j in ('wmic OS get FreePhysicalMemory /value ^| find "="') do set "freeMemAfter=%%j"
        set /a "freedMem=(freeMemAfter-freeMemBefore)/1024"

        echo Memory cleared. Freed approximately !freedMem! MB.

        :: Log the action if a log file is enabled
        if defined logfile (
            echo [%date% %time%] Freed approximately !freedMem! MB of memory. >> "%logfile%"
        )
    ) else (
        :: Handle cancellation or invalid input
        echo Memory clearance skipped.
    )
) else (
    echo Memory usage is within safe limits.
)

:: Log the memory usage regardless of threshold
if defined logfile (
    echo [%date% %time%] Memory Usage: !usedMemMB! MB / !totalMemMB! MB (!memUsage!%%) >> "%logfile%"
)

:: Return to the main menu or allow the user to choose the next step
goto checkAgain

:checkDisk
cls
color 0A
echo ========================================
echo       Checking Disk Usage...
echo ========================================
wmic logicaldisk get size,freespace,caption
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "caption='C:'" get FreeSpace /value ^| find "="') do set "diskFreeBefore=%%i"

echo Would you like to clean up disk space? (F to free disk space, C to cancel)
set /p "diskChoice=Your choice: "
if /i "!diskChoice!"=="F" (
    echo Running Disk Cleanup...
    cleanmgr /sagerun:1 >nul
    for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "caption='C:'" get FreeSpace /value ^| find "="') do set "diskFreeAfter=%%i"
    set /a "freedDisk=(diskFreeAfter-diskFreeBefore)/1024/1024"
    echo Disk cleanup completed. Freed approximately !freedDisk! MB.
    if defined logfile (
        echo [%date% %time%] Freed approximately !freedDisk! MB of disk space. >> "%logfile%"
    )
) else (
    echo Skipping disk cleanup.
)
if defined logfile (
    wmic logicaldisk get size,freespace,caption >> "%logfile%"
    echo [%date% %time%] Disk Usage logged. >> "%logfile%"
)
goto checkAgain

:checkAgain
echo.
set /p again="Would you like to check again or exit? (C for check again, back to menu / E for exit program): "
if /i "%again%"=="C" goto menu
if /i "%again%"=="E" exit /b

goto checkAgain
