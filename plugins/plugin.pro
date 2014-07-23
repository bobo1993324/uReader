TEMPLATE = lib
CONFIG += plugin
QT +=qml quick

DESTDIR = UReader
TARGET = filesplugin


OBJECTS_DIR = tmp
MOC_DIR = tmp


HEADERS += Files.h \
           WrapTextUtils.h \
           plugin.h

SOURCES += Files.cpp \
           WrapTextUtils.cpp \
           plugin.cpp
