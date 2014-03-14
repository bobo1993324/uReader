#include "Files.h"

QStringList FilesModel::files(){
//    QFontDatabase qfdb;
    qDebug() << "FilesModel::files()";
    QDir qdir(QDir::homePath() + "/.local/share/com.bobo-324.ureader/Documents");
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
    QFile f(QDir::homePath() + "/.local/share/com.bobo-324.ureader/Documents/" + fileName);
    qDebug() << "read " << fileName << " " << f.exists();
    f.open(QFile::ReadOnly);
    QTextStream in(&f);
    in.setCodec((const char *)encoding.toLocal8Bit());
    QString s = in.readAll();
    f.close();
    return s;
}

QVariantList FilesModel::indexTxt(QFont font, int height, int width, QString text){
    qDebug() << font << " " << height << " " << width << " " << text.length();

    QVariantList list;
    QFontMetrics fm=QFontMetrics(font);
    int PageLineNum = height / fm.lineSpacing();
//    qDebug() << fm.lineSpacing() << fm.height() << PageLineNum;
    int PageLineNow = 0;
    int LineWidthNow = 0;
    int newPageOffset=0;
    list.append(0);
    int FileContentSize = text.size();
    for (int offset = 0; offset < FileContentSize; offset++){
        int b = text[offset].toLatin1();

        if (b == 10) {// \n
//            qDebug() << "change line at " << text[offset-2] << PageLineNow;
            LineWidthNow = 0;
            PageLineNow++;
            newPageOffset = offset+1;
        } else if (b != 13) {// not \r
            // Ascii
            LineWidthNow += fm.width(text[offset]);
            if (LineWidthNow > width) {
//                qDebug() << "change line at " << text[offset] << PageLineNow;
                LineWidthNow = fm.width(text[offset]);
                PageLineNow++;
                newPageOffset = offset;
            }
        }

        if (PageLineNow > PageLineNum) {
            PageLineNow = 0;
            list.append(newPageOffset);
//            return list;
        }
    }
    if(list.last() != FileContentSize || FileContentSize == 0)
        list.append(FileContentSize);
    return list;
}
