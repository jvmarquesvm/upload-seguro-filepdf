@echo off
@setlocal EnableExtensions

set "DIR=%~dp0"
if "%DIR:~-1%"=="\" set "DIR=%DIR:~0,-1%"

set "WRAPPER_JAR=%DIR%\.mvn\wrapper\maven-wrapper.jar"
set "WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain"

REM Se JAVA_HOME estiver definido e apontar para um JDK valido (com javac.exe), usa ele preferencialmente
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\java.exe" (
        set "JAVACMD=%JAVA_HOME%\bin\java.exe"
    )
)

if not defined JAVACMD (
    set "JAVACMD=java"
)

"%JAVACMD%" "-Dmaven.multiModuleProjectDirectory=%DIR%" -classpath "%WRAPPER_JAR%" %WRAPPER_LAUNCHER% %*
exit /b %ERRORLEVEL%
