import QtQuick 2.0
import Ubuntu.Components 0.1
Page {
    title: i18n.tr("Help")
    Label{
        width: parent.width- units.gu(2) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: i18n.tr("\nWelcome to QmlTextReader.This is a reader for text file, for reading novels. \
\nTo turn page in the reading mode, either click on the right or left, or swipe right or left. \
\n\nAny feature request or bug report is appreciated. \
If do, mail to bobo1993324@gmail.com or submit issue at https://github.com/bobo1993324/uReader.")
        wrapMode: Text.WordWrap
    }
}
