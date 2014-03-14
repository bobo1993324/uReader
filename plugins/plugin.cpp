#include "plugin.h"
#include "Files.h"
void FilesPlugin::registerTypes(const char *uri){
    qmlRegisterType<FilesModel>("UReader", 0, 1, "FilesModel");
}
