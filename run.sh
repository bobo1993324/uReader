#!/bin/bash
cd plugins
qmake
make
cd ..
qmlscene -I plugins uReader.qml --desktop_file_hint=`pwd`/uReader.desktop
