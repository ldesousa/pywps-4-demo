set online=%1

pushd "%~dp0"

@echo installation paths
set PYTHONHOME=C:\Python38\
if not exist "%PYTHONHOME%" set PYTHONHOME=

set talos_wps=%~dp0\talos_wps
set wheels=%~dp0\wheels\
set talos_gis=D:\dev\gis\TaLoS\1\p\talos

@echo talos_wps install files
set talos_wps_7z=%~dp0\talos_wps_install\talos_wps.7z
::set talos_7z=%~dp0\talos_wps_install\talos.7z

@echo step 2: git clone or extract talos_wps
git clone https://github.com/talos-gis/pywps-flask.git %talos_wps%
pushd "%~dp0"
cd /d %talos_wps%
git checkout talos_wps
git pull
popd 

7za a %talos_wps_7z% %talos_wps%\*
::7za a %talos_7z% %PYTHONHOME%talos.dll

@echo step 3: install talos_wps python package requirements
%PYTHONHOME%python -m pip download -r %talos_wps%\requirements.txt -d %wheels%
::%PYTHONHOME%python -m pip download -r %talos_wps%\requirements-opt.txt -d %wheels%
%PYTHONHOME%python -m pip download -r %talos_wps%\requirements-iis.txt -d %wheels%
%PYTHONHOME%python -m pip download -r %talos_wps%\requirements-apache.txt -d %wheels%

pushd %talos_gis%
rmdir /s/q dist
rmdir /s/q build
%PYTHONHOME%python setup.py bdist_wheel
copy dist\*.whl %wheels%
popd

popd

@echo done!

:finish
pause