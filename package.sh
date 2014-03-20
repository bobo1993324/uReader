#! /bin/bash
mkdir package/plugins/UReader -p
mkdir package/locale/zh_CN/LC_MESSAGES -p
cp logo.png components ui uReader.qml manifest.json qmlTextReader.desktop img qmlTextReader.json ./package -rf
cp plugins/UReader/libfilesplugin.so plugins/UReader/qmldir package/plugins/UReader/
cp locale/zh_CN/LC_MESSAGES/com.ubuntu.developer.bobo1993324.qmltextreader.mo package/locale/zh_CN/LC_MESSAGES/
cd package
click build .
cp *.click ..
cd ..
#rm -rf package

