#include <QFont>
#include <QVariantList>
class WrapTextUtiles : public QObject{
    Q_OBJECT
public:
    // [0] translatedindexList, [1] translated text, [2], originalIndexList
    Q_INVOKABLE QVariantList indexTxt(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE QVariantList indexTxtWrapped(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE int getLineHeight(QFont font);
};
