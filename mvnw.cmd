@echo off
@setlocal

set "DIR=%~dp0"
if "%DIR:~-1%"=="\" set "DIR=%DIR:~0,-1%"

set "WRAPPER_JAR=%DIR%\.mvn\wrapper\maven-wrapper.jar"
set "WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain"

java "-Dmaven.multiModuleProjectDirectory=%DIR%" -classpath "%WRAPPER_JAR%" %WRAPPER_LAUNCHER% %*
exit /b %ERRORLEVEL%
