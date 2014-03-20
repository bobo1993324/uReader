import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
Component {
    id: dialog
    Dialog {
        id: dialogue
        text: i18n.tr("No files found. Copy txt files to '~/.local/share/com.bobo-324.qmltextreader/Documents' and restart the application.")
        Button {
            text: "Close"
            onClicked: PopupUtils.close(dialogue)
        }
    }
}
