@echo off
setlocal enabledelayedexpansion

:: ------------------- CONFIGURAÇÃO NECESSÁRIA -------------------
:: Ajuste o caminho abaixo para apontar para o seu llvm-readelf.exe
:: Ele fica dentro da pasta do NDK que você instalou.
set READELF="C:\Users\<SEU_USUARIO>\AppData\Local\Android\Sdk\ndk\<NDK_VERSION>\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-readelf.exe"

:: <SEU_USUARIO> = O nome do seu usuário no Windows.
:: <NDK_VERSION> = A versão do NDK que você está usando (ex: 27.0.12077973).
:: ---------------------------------------------------------------

:: Define o caminho onde as bibliotecas de 64 bits foram extraídas
set LIBPATH=aab_out\base\lib\arm64-v8a

:: Define o nome do arquivo de saída
set OUTPUT=relatorio_alinhamento.txt

echo Verificando alinhamento das bibliotecas em %LIBPATH% > %OUTPUT%
echo ============================================================= >> %OUTPUT%

for %%F in (%LIBPATH%\*.so) do (
    echo. >> %OUTPUT%
    echo ====== Analisando: %%~nxF ====== >> %OUTPUT%
    %READELF% -l "%%F" | findstr "LOAD" >> %OUTPUT%
)

echo.
echo Concluido O relatorio foi salvo em %OUTPUT%