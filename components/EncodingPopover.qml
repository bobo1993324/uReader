import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1

Component {
    ActionSelectionPopover {
        id: popover
        actions: ActionList {
            Action {
                text: "UTF-8 (Universal)"
                property string encValue: "UTF-8"
                onTriggered: {
                    readPage.setNewEncoding(encValue)
                    PopupUtils.close(popover);
                }
            }
            Action{
                text: "GB2312 (Chinese)"
                property string encValue: "GB2312"
                onTriggered: {
                    readPage.setNewEncoding(encValue)
                    PopupUtils.close(popover);
                }
            }
        }
        delegate: ListItem.Standard {
            text: action.text
            Label{
                text: "<"
                visible: readPage.encoding == action.encValue
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin:  units.gu(2)
                }
            }
        }
    }
}
