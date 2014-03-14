#include <QObject>
#include <QStringList>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QFont>
#include <QFontMetrics>
class FilesModel : public QObject{
    Q_OBJECT
    Q_PROPERTY(QStringList files READ files)
public:
    QStringList files();
    Q_INVOKABLE QString readFile(QString fileName, QString encoding);
    Q_INVOKABLE QVariantList indexTxt(QFont font, int height, int width, QString text);
};
