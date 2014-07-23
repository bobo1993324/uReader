#include <QFont>
#include <QVariantList>
class WrapTextUtiles : public QObject{
    Q_OBJECT
public:
    Q_INVOKABLE QVariantList indexTxt(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE QVariantList indexTxtWrapped(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE int getLineHeight(QFont font);
};
