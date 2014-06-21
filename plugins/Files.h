#include <QObject>
#include <QStringList>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QFont>
#include <QFontMetrics>
#include <QStringBuilder>
class FilesModel : public QObject{
    Q_OBJECT
    Q_PROPERTY(QStringList files READ files NOTIFY filesChanged)
public:
    QStringList files();
    Q_INVOKABLE QString readFile(QString fileName, QString encoding);
    Q_INVOKABLE QVariantList indexTxt(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE QVariantList indexTxtWrapped(QFont font, int height, int width, QString text, double lineSpace);
    Q_INVOKABLE int getLineHeight(QFont font);
    Q_INVOKABLE void importFiles(QString fullPath);
signals:
    void filesChanged();
};
