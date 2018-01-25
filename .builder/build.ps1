# please update this version after new cryptopp release.
$version = "CRYPTOPP_6_0_0"
$versionFolder = "Cryptopp-" + $version

Write-Host("Building CryptoPP")

$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"
$project = $versionFolder + "/cryptest.sln"
$flags = "/p:Configuration=Release"
& $msbuild $project $flags

Write-Host("libelectronpass-cpp")

cd libelectronpass-cpp
mkdir cryptopp
mkdir cryptopp\cryptopp
cd ..

Write-Host("Copying files")

$libLocation = $versionFolder + "\Win32\Output\Release\cryptlib.lib"
cp $libLocation libelectronpass-cpp\cryptopp\
$headerFiles = $versionFolder + "\*"
copy-item -path $headerFiles -destination libelectronpass-cpp\cryptopp\cryptopp -include *.h

Write-Host("Running CMake")

cd libelectronpass-cpp
mkdir build
cd build
cmake ..

Write-Host("Building libelectronpass-cpp")

$project = "electronpass.sln"
$flags = "/p:Configuration=Release"
& $msbuild $project $flags

cd ..
cd ..

mkdir dependencies
mkdir build
mkdir dependencies\cryptopp
mkdir dependencies\electronpass

$libLocation = $versionFolder + "\Win32\Output\Release\cryptlib.lib"
cp $libLocation dependencies\
cp libelectronpass-cpp\lib\Release\electronpass.lib dependencies\

$headerFiles = $versionFolder + "\*"
copy-item -path $headerFiles -destination dependencies\cryptopp -include *.h
$headerFiles = "libelectronpass-cpp\include\*"
copy-item -path $headerFiles -destination dependencies\electronpass
$headerFiles = "libelectronpass-cpp\include\json\*"
copy-item -path $headerFiles -destination dependencies\electronpass\json

Write-Host("Building ElectronPass Desktop")

# TODO: add actual keys, so sync will be possible
cp app\sync\keys.default.hpp app\sync\keys.hpp
.\build_helper.bat

cd build

$flag1 = "/p:Configuration=Release"
$flag2 = "/p:AppxPackageSigningEnabled=false"
& $msbuild "electronpass.vcxproj" $flag1 $flag2

Write-Host("Running WindeployQt")

cd ..
mkdir ElectronPass
cp bin\electronpass.exe ElectronPass
cd ElectronPass
windeployqt electronpass.exe -qmldir ..\app\qml
cd ..

Write-Host("Finished")
