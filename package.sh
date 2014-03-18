#! /bin/bash
mkdir package/plugins/UReader -p
cp logo.png components ui uReader.qml manifest.json uReader.desktop img uReader.json ./package -rf
cp plugins/UReader/libfilesplugin.so plugins/UReader/qmldir package/plugins/UReader/
cd package
click build .
cp *.click ..
cd ..
#rm -rf package

