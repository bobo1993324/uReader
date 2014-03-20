#!/bin/bash
cd plugins
qmake
make
cp qmldir UReader
cd ..

