import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

import "../components"

Page {
    id: topPage
    title:"UReader"

    Flickable{
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentColumn.height
        Column {
            id: contentColumn
            spacing: units.gu(1)
            width: parent.width
//            ListItem.Header{
//                text: "Recent"
//                visible: false
//            }
//            Row{
//                height: coverHeight
//                spacing: units.gu(4)
//                visible: false
//                BookCover{
//                    height: coverHeight
//                    width: height * 2 / 3
//                    title: "Click Me"
//                    onClicked: {console.log("clicked")
//                        pageStack.push(readPage)
//                    }
//                    onPressAndHold: {console.log("hold")}
//                }

//                BookCover{
//                    height: coverHeight
//                    width: height * 2 / 3
//                    title: "hahahahahaha"
//                }

//                BookCover{
//                    height: coverHeight
//                    width: height * 2 / 3
//                    title: "haha"
//                }
//            }

            ListItem.Header{
                text:'Files'
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
                            readPage.fileName = modelData;
                            pageStack.push(readPage);
                        }
                    }
                }
            }
        }
    }
}
