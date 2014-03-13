import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
Page{
    id: readPage
    property int currentPage: 1;
    property var pageList : [page0, page1, page2]

    TextEdit{
        id: page0
        text: "Page 0"
        readOnly: true
        width: parent.width - units.gu(2) * 2
        x: -parent.width
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: units.gu(2)
        }

        wrapMode: Text.Wrap
        Behavior on x{
            UbuntuNumberAnimation{}
        }
    }
    TextEdit{
        id: page1
        text: "Page 1 (Swipe to turn)"
        readOnly: true
        width: parent.width - units.gu(2) * 2
        x: units.gu(2)
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: units.gu(2)
        }

        wrapMode: Text.Wrap
        Behavior on x{
            UbuntuNumberAnimation{}
        }
    }
    TextEdit{
        id: page2
        text: "Page 2"
        readOnly: true
        width: parent.width - units.gu(2) * 2
        x: parent.width
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: units.gu(2)
        }

        wrapMode: Text.Wrap
        Behavior on x{
            UbuntuNumberAnimation{}
        }
    }

    Column{
        id: progressBar
        width: parent.width
        anchors.bottom: parent.bottom
        Label {
            text: "Title"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            color: "#65A6D1"
            width: parent.width
            Rectangle{
                height: parent.height
                width: parent.width * 0.2
                color: "#0A67A3"
            }

            height: units.gu(1)
        }
    }
    MyGestureArea{
        anchors.fill: parent
        onSwipeRight: prevPage()
        onSwipeLeft: nextPage()
    }
    function nextPage(){
        if ( currentPage == 1){
            pageList[1].x = - readPage.width
            pageList[2].x = units.gu(2)
            currentPage = 2
        }
        if ( currentPage == 0){
            pageList[0].x = - readPage.width
            pageList[1].x = units.gu(2)
            currentPage = 1
        }
    }
    function prevPage(){
        if(currentPage == 1){
            pageList[1].x = readPage.width
            pageList[0].x = units.gu(2)
            currentPage = 0;
        }

        if(currentPage == 2){
            pageList[2].x = readPage.width
            pageList[1].x = units.gu(2)
            currentPage = 1;
        }
    }
    tools: ToolbarItems{
        ToolbarButton{
            width: 60
            action:Action{

                text: "Add bookmarks"
            }
        }
        ToolbarButton{
            width: 60
            action:Action{

                text: "Bookmarks"
            }
        }
        ToolbarButton{
            width: 60
            action:Action{

                text: "Font size +"
            }
        }
        ToolbarButton{
            width: 60
            action:Action{

                text: "Font size -"
            }
        }

        ToolbarButton{
            width: 60
            action:Action{

                text: "Jump to"
            }
        }
    }
}
