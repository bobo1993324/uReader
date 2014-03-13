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
        contentHeight: contentColumn.height + units.gu(2)
        Column {
            id: contentColumn
            spacing: units.gu(1)
            width: parent.width - units.gu(2) * 2
            anchors {
                margins: units.gu(2)
                horizontalCenter: parent.horizontalCenter
            }

            ListItem.Header{
                text: "Recent"
            }
            Row{
                height: coverHeight
                spacing: units.gu(4)
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "Click Me"
                    onClicked: {console.log("clicked")
                        pageStack.push(readPage)
                    }
                    onPressAndHold: {console.log("hold")}
                }

                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "hahahahahaha"
                }

                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                    }
                }

            ListItem.Header{
                text:'Files'
            }
            Flow{
                width: parent.width
                spacing: units.gu(4)
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
                BookCover{
                    height: coverHeight
                    width: height * 2 / 3
                    title: "haha"
                }
            }
        }
    }
}
