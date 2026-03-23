@echo off
color 0B
title ESPHome Flasher - Smart Fan
echo ========================================================
echo         ESP32 SMART FAN - ESPHOME FLASH TOOL
echo ========================================================
echo.
echo Please select an option:
echo   1. Compile Only (Check for errors without flashing)
echo   2. Flash via USB (COM Port)
echo   3. Flash via WiFi (OTA Over-The-Air)
echo   4. View Logs Only (WiFi / OTA)
echo   5. View Logs Only (USB)
echo   6. Exit
echo.
set /p choice="Enter your choice (1-6): "

set CONFIG_FILE=main.yaml

if "%choice%"=="1" goto compile
if "%choice%"=="2" goto flash_usb
if "%choice%"=="3" goto flash_ota
if "%choice%"=="4" goto logs_ota
if "%choice%"=="5" goto logs_usb
if "%choice%"=="6" goto end

:compile
echo.
echo [INFO] Compiling firmware...
esphome compile %CONFIG_FILE%
goto end

:flash_usb
echo.
set /p com_port="[?] Enter COM Port (e.g., COM3): "
echo.
echo [INFO] Flashing via %com_port%...
esphome run %CONFIG_FILE% --device %com_port%
goto end

:flash_ota
echo.
set /p ip_address="[?] Enter device IP address (e.g., 192.168.20.179) [Leave empty for mDNS]: "
echo.
if "%ip_address%"=="" (
    echo [INFO] Flashing via OTA (mDNS auto-discovery)...
    esphome run %CONFIG_FILE%
) else (
    echo [INFO] Flashing via OTA (%ip_address%)...
    esphome run %CONFIG_FILE% --device %ip_address%
)
goto end

:logs_ota
echo.
set /p ip_address="[?] Enter device IP address (e.g., 192.168.20.179) [Leave empty for mDNS]: "
echo.
if "%ip_address%"=="" (
    echo [INFO] Viewing logs via OTA (mDNS auto-discovery)...
    esphome logs %CONFIG_FILE%
) else (
    echo [INFO] Viewing logs via OTA (%ip_address%)...
    esphome logs %CONFIG_FILE% --device %ip_address%
)
goto end

:logs_usb
echo.
set /p com_port="[?] Enter COM Port (e.g., COM3): "
echo.
echo [INFO] Viewing logs via %com_port%...
esphome logs %CONFIG_FILE% --device %com_port%
goto end

:end
echo.
pause