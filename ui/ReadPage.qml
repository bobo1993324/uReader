import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
Page{
    id: readPage
    property var pageList : [page0, page1, page2]
    property var fileName
    property var indexList
    property int currentPageListIdx
    property int currentIndexListIdx
    property string content;
    property int mARGIN : units.gu(4)
    property int fontSize: 11
    onWidthChanged: {
        timer1.start()
    }

    onHeightChanged: {
        if (readPage.visible) {
            progressSliderRect.y = height;
            timer1.start()
        }
    }

    onFileNameChanged: {
//        console.log("onFileNameChanged")
        var newContents = aDocument.contents
        if(!newContents.history[fileName]){
            newContents.history[fileName] =
                    {
                readTo: 0,
                totalCount: content.length,
                fontSize: fontSize
            };
            aDocument.contents = newContents
        }

        content = files.readFile(fileName, "GB2312");
        timer1.start()
    }

    Timer {
        id: timer1
        repeat: false
        interval: 1000
        onTriggered: indexAndSet()
    }

    function indexAndSet(){
        if (aDocument.contents.history[fileName].fontSize)
            fontSize = aDocument.contents.history[fileName].fontSize;
        //update totalCount
        var tmp = aDocument.contents;
        if (tmp.history[fileName].totalCount != content.length) {
            tmp.history[fileName].totalCount = content.length
            aDocument.contents = tmp;
        }

        indexList = files.indexTxt(page1.font, page1.height, page1.width, content);
        currentIndexListIdx = getPageIdx(aDocument.contents.history[fileName].readTo);
//        console.log("currentIndexListIdx is " + currentIndexListIdx + "readTo is " + aDocument.contents.history[fileName].readTo)
        if(!currentIndexListIdx || currentIndexListIdx >= content.length)
            currentIndexListIdx = 0;
        //load current page

        pageList[currentPageListIdx].text = content.substring(indexList[currentIndexListIdx], indexList[currentIndexListIdx + 1]);
    }

    function saveReadTo(){
        var newContents = aDocument.contents
        if(newContents.history[fileName]){
            newContents.history[fileName].readTo = indexList[currentIndexListIdx];
            aDocument.contents = newContents
        }
        console.log(JSON.stringify(aDocument.contents))
    }

    onFontSizeChanged: {
        var newContents = aDocument.contents
        if (newContents.history[fileName]) {
            newContents.history[fileName].fontSize = fontSize;
            aDocument.contents = newContents
        }
        console.log(JSON.stringify(aDocument.contents))
    }

    TextEdit{
        id: page0
        text: "Page 0"
        font.family: "WenQuanYi Micro Hei"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 0 ? mARGIN : (currentPageListIdx == 1 ? -parent.width : parent.width)

        height: parent.height - progressBar.height - mARGIN * 2
        y: mARGIN

        wrapMode: Text.WrapAnywhere
        Behavior on x{
            UbuntuNumberAnimation{}
        }

        font.pointSize: fontSize
    }
    TextEdit{
        id: page1
        font.family: "WenQuanYi Micro Hei"
        text: "Page 1 (Swipe to turn)"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 1 ? mARGIN : (currentPageListIdx == 2 ? -parent.width : parent.width)
        height: parent.height - progressBar.height - mARGIN * 2
        y: mARGIN

        wrapMode: Text.WrapAnywhere
        Behavior on x{
            UbuntuNumberAnimation{}
        }
        font.pointSize: fontSize
    }
    TextEdit{
        id: page2
        text: "Page 2"
        font.family: "WenQuanYi Micro Hei"
        readOnly: true
        width: parent.width - mARGIN * 2
        x: currentPageListIdx == 2 ? mARGIN : (currentPageListIdx == 0 ? -parent.width : parent.width)
        height: parent.height - progressBar.height - mARGIN * 2
        y: mARGIN

        wrapMode: Text.WrapAnywhere
        Behavior on x{
            UbuntuNumberAnimation{}
        }

        font.pointSize: fontSize
    }

    Column{

        id: progressBar
        width: parent.width
        anchors.bottom: parent.bottom
        Label {
            id: fileNameLabel
            text: fileName
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            color: "#65A6D1"
            width: parent.width
            Rectangle{
                id: progressRec1
                height: parent.height
                width: parent.width * currentIndexListIdx / indexList.length
                color: "#0A67A3"
            }

            height: units.gu(1)
        }
    }

    Rectangle{
        id: progressSliderRect
        y: parent.height

        width: parent.width
        height: progressSlider.height + units.gu(1)
        color: Theme.palette.normal.background
        Slider {
            id: progressSlider
            function formatValue(v) { return Math.floor(v * 100 / maximumValue) + "%"}
            minimumValue: 0
            maximumValue: indexList.length - 2
            live: false
            width: parent.width - mARGIN * 2
            anchors.horizontalCenter: parent.horizontalCenter
            onValueChanged: {
                currentIndexListIdx = Math.floor(value);
                saveReadTo();
                pageList[currentPageListIdx].text = content.substring(indexList[currentIndexListIdx], indexList[currentIndexListIdx + 1]);
            }

            onPressedChanged: {
                disappearTime = 3
            }

            property int disappearTime: 0
            Timer{
                id: progressDisappearTimer
                interval: 1000
                repeat: true
                onTriggered: {
                    if (progressSlider.pressed){
                        return;
                    }

                    if (progressSlider.disappearTime == 0) {
                        progressSliderRect.y = readPage.height
                        stop();
                    } else {
                        progressSlider.disappearTime --
                    }
                }
            }
        }
        Behavior on y {
            UbuntuNumberAnimation{}
        }
    }

    MyGestureArea{
        id: myGestureArea
        width: parent.width
        height: progressSliderRect.y
        onSwipeRight: prevPage()
        onSwipeLeft: nextPage()
        onRealClicked: {
            if (mouse.x < width * 0.3) {
                console.log("clicked left")
                prevPage();
            } else if (mouse.x > width * 0.7) {
                console.log("clicked right")
                nextPage();
            } else if (!readPage.toolbar.animating){
                readPage.toolbar.open();
            }
        }
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
            saveReadTo();
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
            saveReadTo();
        }
    }
    function getPageIdx(idx){
        //TODO binary search
        for (var i = 1; i < indexList.length; i++) {
            if (idx < indexList[i]) {
//                console.log(indexList[i] + " " + (i-1))
                return i - 1;
            }
        }
        return 0;
    }

    tools:ToolbarItems{
        //        ToolbarButton{
        //            width: 60
        //            action:Action{
        //                iconSource: "../img/bookmark-add.svg"
        //                text: "Add bookmarks"
        //            }
        //        }
        //        ToolbarButton{
        //            width: 60
        //            action:Action{
        //                iconSource: "../img/bookmark.svg"
        //                text: "Bookmarks"
        //            }
        //        }

        ToolbarButton{
            action:Action{
                iconSource: "../img/font-increase.svg"
                text: "Font +"
                onTriggered: {
                    fontSize += 2;
                    timer1.start();
                }
            }
        }

        ToolbarButton{
            action:Action{
                iconSource: "../img/font-decrease.svg"
                text: "Font -"
                onTriggered: {
                    fontSize -= 2;
                    timer1.start();
                }
            }
        }

        ToolbarButton{
            action:Action{
                iconSource: "../img/jump.svg"
                text: "Jump to"
                onTriggered: {
                    progressSlider.value = currentIndexListIdx
                    progressSlider.disappearTime = 4;
                    progressDisappearTimer.start();
                    progressSliderRect.y = readPage.height - progressSliderRect.height
                    readPage.toolbar.close()

                }
            }
        }

        back: ToolbarButton{
            action: Action{
                text: "Back"
                iconSource: "../img/back.svg"
                onTriggered:{
                    pageStack.pop();
                    mainView.goToTopPage();
                }
            }
        }
    }
}
