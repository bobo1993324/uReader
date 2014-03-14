TEMPLATE = lib
CONFIG += plugin
QT +=qml quick

DESTDIR = UReader
TARGET = filesplugin


OBJECTS_DIR = tmp
MOC_DIR = tmp


HEADERS += Files.h \
           plugin.h

SOURCES += Files.cpp \
           plugin.cpp
