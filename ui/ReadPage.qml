import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
Page{
    id: readPage
    property var pageList : [page0, page1, page2]
    property var fileName
    property var indexList
    property int currentPageListIdx : 1
    property int currentIndexListIdx
    property string content;
    property int mARGIN : units.gu(2)
    onFileNameChanged: {
        content = files.readFile(fileName, "GB2312");
        indexList = files.indexTxt(page1.font, page1.height, page1.width, content);
        console.log(indexList);
        currentIndexListIdx = 0;
        //load current page
        pageList[currentPageListIdx].text = content.substring(indexList[currentIndexListIdx], indexList[currentIndexListIdx + 1]);
        //load next page
        if(currentIndexListIdx + 1 < indexList.length){
            pageList[currentPageListIdx == 2 ? 0 : currentPageListIdx + 1].text = content.substring(indexList[currentIndexListIdx + 1], indexList[currentIndexListIdx + 2]);
        }
    }

    TextEdit{
        id: page0
        text: "Page 0"
        font.family: "WenQuanYi Micro Hei"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 0 ? mARGIN : (currentPageListIdx == 1 ? -parent.width : parent.width)

        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: mARGIN
        }

        wrapMode: Text.Wrap
        Behavior on x{
            UbuntuNumberAnimation{}
        }
    }
    TextEdit{
        id: page1
        font.family: "WenQuanYi Micro Hei"
        text: "Page 1 (Swipe to turn)"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 1 ? mARGIN : (currentPageListIdx == 2 ? -parent.width : parent.width)
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: mARGIN
        }
        clip: true
        wrapMode: Text.Wrap
        Behavior on x{
            UbuntuNumberAnimation{}
        }
    }
    TextEdit{
        id: page2
        text: "Page 2"
        font.family: "WenQuanYi Micro Hei"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 2 ? mARGIN : (currentPageListIdx == 0 ? -parent.width : parent.width)
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: mARGIN
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
            text: fileName
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            color: "#65A6D1"
            width: parent.width
            Rectangle{
                height: parent.height
                width: parent.width * currentIndexListIdx / indexList.length
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
        if(currentIndexListIdx < indexList.length -1){
            //load next page
            pageList[currentPageListIdx == 2 ? 0 : currentPageListIdx + 1].text = content.substring(indexList[currentIndexListIdx + 1], indexList[currentIndexListIdx + 2]);

            pageList[currentPageListIdx == 0 ? 2 : currentPageListIdx - 1].visible = false
            pageList[currentPageListIdx == 2 ? 0 : currentPageListIdx + 1].visible = true

            currentPageListIdx ++;
            if(currentPageListIdx > 2)
                currentPageListIdx = 0
            currentIndexListIdx ++;
        }
    }
    function prevPage(){
        if(currentIndexListIdx != 0){
            //load prev page

            pageList[currentPageListIdx == 0 ? 2 : currentPageListIdx - 1].text = content.substring(indexList[currentIndexListIdx - 1], indexList[currentIndexListIdx]);

            pageList[currentPageListIdx == 0 ? 2 : currentPageListIdx - 1].visible = true
            pageList[currentPageListIdx == 2 ? 0 : currentPageListIdx + 1].visible = false

            currentPageListIdx --;
            if(currentPageListIdx < 0)
                currentPageListIdx = 2;
            currentIndexListIdx --;
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
