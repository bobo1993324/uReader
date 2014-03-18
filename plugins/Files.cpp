#include "Files.h"

QStringList FilesModel::files(){
    //    QFontDatabase qfdb;
    qDebug() << "FilesModel::files()";
    QDir qdir(QDir::homePath() + "/.local/share/com.bobo-324.qmltextreader/Documents");
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
    QFile f(QDir::homePath() + "/.local/share/com.bobo-324.qmltextreader/Documents/" + fileName);
    qDebug() << "read " << fileName << " " << f.exists();
    f.open(QFile::ReadOnly);
    QTextStream in(&f);
    in.setCodec((const char *)encoding.toLocal8Bit());
    QString s = in.readAll();
    f.close();
    return s;
}

QVariantList FilesModel::indexTxtWrapped(QFont font, int height, int width, QString text){
    //TODO it doesn't work perfectly. add breakline manually
    qDebug() << font << " " << height << " " << width << " " << text.length();
    QString qsb;

    QVariantList list;
    QFontMetrics fm=QFontMetrics(font);
    int PageLineNum = height / qMax(fm.height(), fm.lineSpacing());
    qDebug() << fm.lineSpacing() << fm.height() << PageLineNum;
    int PageLineNow = 0;
    int LineWidthNow = 0;
    int newPageOffset=0;
    list.append(0);
    int FileContentSize = text.size();
    int wordWidth = 0;
    QString word = "";
//    int i = 0;
    for (int offset = 0; offset < FileContentSize; offset++){
        if (text[offset] == '\n' || text[offset] == ' '){
            if (text[offset] == '\n') {
                LineWidthNow += wordWidth;

                if (LineWidthNow > width) {
                    qsb.append('\n');
                    PageLineNow++;
                }
                LineWidthNow = 0;
//                            qDebug() << word;
                PageLineNow++;
                qsb.append(word).append('\n');
                newPageOffset = qsb.size();
                word = "";
                wordWidth = 0;
            } else if (text[offset] == ' ') {
                wordWidth += fm.width(text[offset]);
                LineWidthNow += wordWidth;
                if (LineWidthNow > width) {
                    qsb.append('\n');
                    newPageOffset = qsb.size();
                    LineWidthNow = wordWidth;
                    PageLineNow++;
//                                    qDebug() << word;
                }
                qsb.append(word).append(' ');
                word = "";
                wordWidth = 0;
            }
            //        qDebug() << "read " << text[offset] << LineWidthNow << fm.width(text[offset]);

            if (PageLineNow >= PageLineNum) {
                PageLineNow = 0;
                list.append(newPageOffset);
//                i++;
//                offset -= 1;
//                if(i==4) {
//                    QVariantList returnVal;
//                    returnVal << QVariant(list) << QVariant(qsb);
//                    return returnVal;
//                }
            }
        } else {
            word += text[offset];
            wordWidth += fm.width(text[offset]);
        }
    }
    if(list.last() != FileContentSize || FileContentSize == 0)
        list.append(qsb.size());
    QVariantList returnVal;
    returnVal << QVariant(list) << QVariant(qsb);
    return returnVal;

}

QVariantList FilesModel::indexTxt(QFont font, int height, int width, QString text){
    qDebug() << font << " " << height << " " << width << " " << text.length();

    QString qsb;

    QVariantList list;
    QFontMetrics fm=QFontMetrics(font);
    int PageLineNum = height / qMax(fm.height(), fm.lineSpacing());
    qDebug() << fm.lineSpacing() << fm.height() << PageLineNum;
    int PageLineNow = 0;
    int LineWidthNow = 0;
    int newPageOffset=0;
    list.append(0);
    int FileContentSize = text.size();
    //    int i = 0;
    for (int offset = 0; offset < FileContentSize; offset++){
        int b = text[offset].toLatin1();

        if (b == 10) {// \n
            //            qDebug() << "change line at " << text[offset-2] << PageLineNow;
            LineWidthNow = 0;
            PageLineNow++;
            qsb.append('\n');
            newPageOffset = qsb.size();
        } else if (b != 13) {// not \r
            LineWidthNow += fm.width(text[offset]);
            if (LineWidthNow > width) {
                //                qDebug() << "change line at " << text[offset] << PageLineNow;
                LineWidthNow = fm.width(text[offset]);
                PageLineNow++;
                qsb.append('\n');
                newPageOffset = qsb.size();
            }
            qsb.append(text[offset]);
        }

        if (PageLineNow >= PageLineNum) {
            PageLineNow = 0;
            list.append(newPageOffset);
            //            i++;
            //            if(i==3)
            //            return list;
        }
    }
    if(list.last() != FileContentSize || FileContentSize == 0)
        list.append(qsb.size());
    QVariantList returnVal;
    returnVal << QVariant(list) << QVariant(qsb);
    return returnVal;
}
