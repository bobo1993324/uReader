import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

import "../components"

Page {
    id: topPage
    title: i18n.tr("QmlTextReader")

    Flickable{
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentColumn.height
        Column {
            id: contentColumn
            spacing: units.gu(1)
            width: parent.width
            ListItem.Header{
                text: "Recent"
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
                        BookCover{
                            height: coverHeight
                            width: height * 2 / 3
                            title: modelData
                            completion: aDocument.contents.history[modelData] ? aDocument.contents.history[modelData].readTo * 1.0 / aDocument.contents.history[modelData].totalCount : 0
                        }
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
                    model: files.files
                    BookCover{
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
        var originalIdx = tmp.recent.indexOf(fileName);
        if (originalIdx != -1) {
            tmp.recent.splice(originalIdx, 1);
        }
        tmp.recent.unshift(fileName);
        aDocument.contents = tmp;
        console.log(aDocument.contents.recent);
    }
}
