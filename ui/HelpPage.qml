import QtQuick 2.0
import Ubuntu.Components 0.1
Page {
    title: "Help"
    Label{
        width: parent.width- units.gu(2) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: i18n.tr("\nWelcome to QmlTextReader.\nThis is a reader for txt file, for novel reading.\n\nTo add a file, put it under path '~/.local/share/\ncom.ubuntu.developer.\nbobo1993324.qmltextreader/Documents'. \nTo turn page in the reading mode, either click on the right or left, or swipe right or left.\n\nAny feature request or bug report is appreciated. If do, mail to bobo1993324@gmail.com.")
        wrapMode: Text.WordWrap
    }
}
