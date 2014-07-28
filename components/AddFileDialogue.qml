import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
Component {
    id: dialog
    Dialog {
        id: dialogue
        title: i18n.tr("No files Imported.")
        Column {
            spacing: units.gu(2)
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Import")
                onClicked: {
                    PopupUtils.close(dialogue)
                    PopupUtils.open(cpd)
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }
}
