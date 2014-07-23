#include "plugin.h"
#include "Files.h"
#include "WrapTextUtils.h"
void FilesPlugin::registerTypes(const char *uri){
    Q_UNUSED(uri);
    qmlRegisterType<FilesModel>("UReader", 0, 1, "FilesModel");
    qmlRegisterType<WrapTextUtiles>("UReader", 0, 1, "WrapTextUtils");
}
