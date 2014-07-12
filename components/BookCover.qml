import QtQuick 2.0
import Ubuntu.Components 0.1
UbuntuShape{
    id: root
    property string title
    property real completion: 0
    property bool displayDelete
    property string fileName
    signal openFile
    signal deleteFile


    color: "white"
    Label{
        text: title
        width: implicitWidth < parent.width * 0.8 ? implicitWidth : parent.width * 0.8
        height: paintedHeight
        wrapMode: Text.WrapAnywhere
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: units.gu(2)
        }
    }

    UbuntuShape{
        height: units.gu(1)
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#65A6D1"
        UbuntuShape{
            height: parent.height
            width: parent.width * completion
            color:"#0A67A3"
        }
    }

    UbuntuShape{
        id: deleteButton
        width: units.gu(3)
        height: displayDelete ? width : 0
        clip: true
        color: "#65A6D1"
        Label {
            color: "white"
            anchors.centerIn: parent
            anchors.margins: units.gu(0.5)
            text: "x"
        }
        Behavior on height {
            UbuntuNumberAnimation {

            }
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            if (deleteMode) {
                if (mouse.x < deleteButton.width && mouse.y < deleteButton.height) {
                    root.deleteFile();
                } else {
                    deleteMode = false;
                }
            } else {
                root.openFile()
            }
        }
        onPressAndHold: {
            deleteMode = !deleteMode;
        }
    }
}
