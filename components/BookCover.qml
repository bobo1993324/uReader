import QtQuick 2.0
import Ubuntu.Components 0.1
UbuntuShape{
    id: root
    property string title
    property real completion: 0

    signal clicked
    signal pressAndHold


    color: "white"
    Canvas {
        id: canvas
        anchors.fill: parent
        visible: completion > 0
        onPaint:{
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.beginPath();
            ctx.arc(width / 2, height / 2, 20, -0.5 * Math.PI, 2 * Math.PI * completion - 0.5 * Math.PI , false);
            ctx.lineWidth = 10;
            ctx.strokeStyle = "rgba(10,103,163, 0.5)";
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(width / 2, height / 2, 20, 0, 2 * Math.PI , false);
            ctx.lineWidth = 10;
            ctx.strokeStyle = "rgba(101,166,209, 0.5)";
            ctx.stroke();
        }
    }
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
    MouseArea{
        anchors.fill: parent
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
    Connections{
        target: mainView
        onGoToTopPage:{
            console.log("topPage");
            canvas.requestPaint();
        }
    }
}
