@rem Gradle wrapper thin starter (Windows).
@rem Requires Gradle installed (Android Studio or `winget install Gradle.Gradle`).
@rem Set GRADLE_HOME or ensure `gradle` is on your PATH.

@if "%DEBUG%"=="" @echo off
@setlocal EnableExtensions

if defined JAVA_HOME (
    set "JAVACMD=%JAVA_HOME%\bin\java.exe"
) else (
    set "JAVACMD=java.exe"
)
%JAVACMD% -version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.>&2
    exit /b 1
)

if defined GRADLE_HOME (
    set "GRADLECMD=%GRADLE_HOME%\bin\gradle.bat"
) else (
    set "GRADLECMD=gradle.bat"
)
where %GRADLECMD% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Gradle not found. Install Gradle and add it to PATH, or set GRADLE_HOME.>&2
    exit /b 1
)

"%GRADLECMD%" --project-dir "%~dp0" %*
