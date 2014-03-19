import QtQuick 2.0
import Ubuntu.Components 0.1
UbuntuShape{
    id: root
    property string title
    property real completion: 0

    signal clicked
    signal pressAndHold


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

    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
}
