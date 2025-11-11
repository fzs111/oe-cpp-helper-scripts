:: somewhat based on https://tutorialreference.com/batch-scripting/examples/faq/batch-script-how-to-find-and-replace-text-within-a-file
:: this is the worst piece of code I've ever written (MIT license "as is" says it all)
:: I hate batch
   
:: anyway, run this script from the solution directory (where the .sln is), and enter the *names* of projects (not paths!)
:: if you run it without arguments, it'll prompt you for them
:: otherwise you can pass the same things as arguments

@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

set "testproj=%1"
if "%testproj%"=="" set /p "testproj=Unittest project name: "
SET "SOURCE_FILE=%testproj%\%testproj%.vcxproj"
SET "OLD_FILE=%SOURCE_FILE%.old"

if exist %OLD_FILE% (
    echo Old config file already exists. Do not run this script more than once on the same project. If you want to do it anyway, rename %OLD_FILE% to %SOURCE_FILE% and delete %OLD_FILE%.
    exit /b 1
)

set "feladat=%2"
if "%feladat%"=="" set /p "feladat=Feladat project name: "
set "targets=%3"
if "%targets%"=="" (
    set "targets=%feladat%"
    set /p "targets=Target cpp files to test (without extension, separated by ; default=%feladat%): "
)
echo Targeting config file %SOURCE_FILE%

move "%SOURCE_FILE%" "%OLD_FILE%" >nul

if errorlevel 1 (
    echo Error
    exit /b %errorlevel%
)

echo Original config file moved to %OLD_FILE%

FOR /F "delims=" %%a IN ('TYPE "%OLD_FILE%"') DO (
    IF "%%a"=="      <AdditionalLibraryDirectories>$(VCInstallDir)UnitTest\lib;%%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>" (
        echo(      ^<AdditionalLibraryDirectories^>$^(SolutionDir^)%feladat%\x64\Debug;$^(VCInstallDir^)UnitTest\lib;%%^(AdditionalLibraryDirectories^)^</AdditionalLibraryDirectories^> >> "%SOURCE_FILE%"
        echo(      ^<AdditionalDependencies^>%targets%;$^(CoreLibraryDependencies^);%%^(AdditionalDependencies^)^</AdditionalDependencies^> >> "%SOURCE_FILE%"
    ) ELSE (
        ECHO(%%a>> "%SOURCE_FILE%"
        IF "%%a"=="  <PropertyGroup Condition="'$^(Configuration^)^|$^(Platform^)'=='Debug^|x64'">" echo     ^<IncludePath^>$^(SolutionDir^)%feladat%;$^(VC_IncludePath^);$^(WindowsSDK_IncludePath^);^</IncludePath^> >> "%SOURCE_FILE%"
    )
)

if errorlevel 1 (
    echo Error
    exit /b %errorlevel%
)

if "%1"=="" pause