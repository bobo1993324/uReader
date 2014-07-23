#include "Files.h"

QStringList FilesModel::files(){
    //    QFontDatabase qfdb;
//    qDebug() << "FilesModel::files()";
    QDir qdir(QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.qmltextreader/Documents");
    if (!qdir.exists()) {
        qdir.mkpath(qdir.absolutePath());
        return QStringList();
    } else {
        QStringList qsl = qdir.entryList();
        //remove . and ..
        int i = 0;
        while (i < qsl.length()) {
            if (qsl[i] == "." || qsl[i] == "..") {
                qsl.removeAt(i);
            } else {
                i++;
            }
        }
        return qsl;
    }

}

QString FilesModel::readFile(QString fileName, QString encoding){
    QFile f(QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.qmltextreader/Documents/" + fileName);
    qDebug() << "read " << fileName << " " << f.exists();
    f.open(QFile::ReadOnly);
    QTextStream in(&f);
    in.setCodec((const char *)encoding.toLocal8Bit());
    QString s = in.readAll();
    f.close();
    return s;
}

void FilesModel::importFiles(QString fullPath) {
    QFile file(fullPath);
    QFileInfo fileInfo(file.fileName());
    QString target = QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.qmltextreader/Documents/" + fileInfo.fileName();
    if (file.exists()) {
        file.copy(target);
    }
    emit filesChanged();
}

void FilesModel::removeFile(QString fileName) {
    QFile f(QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.qmltextreader/Documents/" + fileName);
    qDebug() << "remove " << fileName << " " << f.exists();
    if (f.exists()) {
        f.remove();
        emit filesChanged();
    }
}
