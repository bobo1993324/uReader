#!/bin/bash
cd plugins
qmake
make
cd ..
qmlscene -I plugins uReader.qml
