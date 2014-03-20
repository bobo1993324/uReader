import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem
import Ubuntu.Components.Popups 0.1

import "../components"

Page {
    id: topPage
    title: i18n.tr("QmlTextReader")
    property var filesList:[]
    Component.onCompleted: {
        filesList = files.files
        if (filesList.length == 0) {
            PopupUtils.open(afd)
        }
    }

    AddFileDialogue {
        id: afd
    }

    Component {
        id: bookCoverCom
        BookCover{
            visible: filesList.indexOf(modelData) > -1
            height: coverHeight
            width: height * 2 / 3
            title: modelData
            completion: aDocument.contents.history[modelData] ? aDocument.contents.history[modelData].readTo * 1.0 / aDocument.contents.history[modelData].totalCount : 0
            onClicked: {
                addToRecent(modelData);
                readPage.fileName = modelData;
                pageStack.push(readPage);
            }
        }
    }

    Flickable{
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentColumn.height
        Column {
            id: contentColumn
            spacing: units.gu(1)
            width: parent.width
            ListItem.Header{
                text: i18n.tr("Recent")
                visible: aDocument.contents.recent.length > 0
            }
            Flickable{
                width: parent.width - units.gu(2) * 2
                anchors.horizontalCenter: parent.horizontalCenter
                height: coverHeight
                contentHeight: coverHeight
                contentWidth: recentRow.width
                Row{
                    id: recentRow
                    height: coverHeight
                    spacing: units.gu(4)
                    visible: aDocument.contents.recent.length > 0
                    Repeater {
                        model: aDocument.contents.recent
                        delegate: bookCoverCom
                    }
                }
            }

            ListItem.Header{
                text: i18n.tr("Files")
            }
            Flow{
                spacing: units.gu(4)
                width: parent.width - units.gu(2) * 2
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: filesList
                    delegate: bookCoverCom
                }
            }
            Rectangle{
                width: parent.width
                height: 1
                color: "transparent"
            }
        }
    }
    function addToRecent(fileName) {
        var tmp = aDocument.contents;
        if (!tmp.recent) {
            tmp.recent = [fileName];
            return;
        }
        var originalIdx = tmp.recent.indexOf(fileName);
        if (originalIdx != -1) {
            tmp.recent.splice(originalIdx, 1);
        }
        tmp.recent.unshift(fileName);
        //limit the length of recent to 8
        while (tmp.recent.length > 8) {
            tmp.recent.splice(-1, 1)
        }

        aDocument.contents = tmp;
        console.log(aDocument.contents.recent);
    }
    tools: ToolbarItems{
        ToolbarButton{
            action: Action{
                text: i18n.tr("Help")
                iconSource: "../img/help.svg"
                onTriggered: pageStack.push(helpPage);
            }
        }
    }
}
