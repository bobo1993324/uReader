#include "WrapTextUtils.h"
#include <QDebug>
#include <QFontMetrics>
QVariantList WrapTextUtiles::indexTxtWrapped(QFont font, int height, int width, QString text, double lineSpace){
    qDebug() << font << " " << height << " " << width << " " << text.length();
    QString qsb;

    QVariantList translatedIndexList;
    QVariantList originalIndexList;
    QFontMetrics fm=QFontMetrics(font);
    int PageLineNum = height / (qMax(fm.height(), fm.lineSpacing()) * lineSpace);
    qDebug() << fm.lineSpacing() << fm.height() << PageLineNum;
    int PageLineNow = 0;
    int LineWidthNow = 0;
    int newPageOffset=0;
    translatedIndexList.append(0);
    originalIndexList.append(0);
    int FileContentSize = text.size();
    int wordWidth = 0;
    QString word = "";
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
                }
                qsb.append(word).append(' ');
                word = "";
                wordWidth = 0;
            }

            if (PageLineNow >= PageLineNum) {
                PageLineNow = 0;
                translatedIndexList.append(newPageOffset);
                originalIndexList.append(offset);
            }
        } else {
            word += text[offset];
            wordWidth += fm.width(text[offset]);
        }
    }
    if(translatedIndexList.last() != FileContentSize || FileContentSize == 0) {
        translatedIndexList.append(qsb.size());
        originalIndexList.append(FileContentSize);
    }
    QVariantList returnVal;
    returnVal << QVariant(translatedIndexList) << QVariant(qsb) << QVariant(originalIndexList);
    return returnVal;

}

QVariantList WrapTextUtiles::indexTxt(QFont font, int height, int width, QString text, double lineSpace){
    qDebug() << font << " " << height << " " << width << " " << text.length();

    QString qsb;

    QVariantList translatedIndexList;
    QVariantList originalIndexList;
    QFontMetrics fm=QFontMetrics(font);
    int PageLineNum = height / (qMax(fm.height(), fm.lineSpacing()) * lineSpace);
    qDebug() << fm.lineSpacing() << fm.height() << PageLineNum;
    int PageLineNow = 0;
    int LineWidthNow = 0;
    int newPageOffset=0;
    translatedIndexList.append(0);
    originalIndexList.append(0);
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
            translatedIndexList.append(newPageOffset);
            originalIndexList.append(offset);
        }
    }
    if(translatedIndexList.last() != FileContentSize || FileContentSize == 0) {
        translatedIndexList.append(qsb.size());
        originalIndexList.append(FileContentSize);
    }
    QVariantList returnVal;
    returnVal << QVariant(translatedIndexList) << QVariant(qsb) << QVariant(originalIndexList);
    return returnVal;
}


int WrapTextUtiles::getLineHeight(QFont font) {
    QFontMetrics fm=QFontMetrics(font);
    return qMax(fm.height(), fm.lineSpacing());
}
