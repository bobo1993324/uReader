    import QtQuick 2.0
import Ubuntu.Components 0.1
import "../components"
import Ubuntu.Components.Popups 0.1

Page{
    id: readPage
    property var pageList : [page0, page1, page2]
    property var fileName
    property var translatedIndexList
    property var originalIndexList
    property var currentScreen : page1
    property var prevScreen : page0
    property var nextScreen : page2
    property int currentIndexListIdx
    property string content;
    property string translatedContent; //original content with endline added
    property int mARGIN : units.gu(4)
    property int fontSize: FontUtils.sizeToPixels("medium")
    property int textLineHeight: wrapTextUtils.getLineHeight(page0.font) * textLineSpace
    property real textLineSpace: 1.2
    property string encoding
    property bool wordWrap
    property bool isReady
    property double readToRatio: currentIndexListIdx / (translatedIndexList.length - 2)
    onWidthChanged: {
        if (readPage.visible) {
            isReady = false;
            //progressSlider y will be set rigid
            progressSliderRect.y = height;
            timer1.start()
        }
    }

    onHeightChanged: {
        if (readPage.visible) {
            isReady = false;
            //progressSlider y will be set rigid
            progressSliderRect.y = height;
            timer1.start()
        }
    }

    onFileNameChanged: {
        console.log("onFileNameChanged")
        isReady = false;
        var newContents = aDocument.contents
        if (!newContents.history[fileName]) {
            newContents.history[fileName] ={};
            aDocument.contents = newContents
        } else {
            if (newContents.history[fileName].encoding) {
                encoding = newContents.history[fileName].encoding;
            } else {
                encoding = "UTF-8"
            }
        }

        readContent();

        timer1.start()
    }

    function readContent() {
        isReady = false;
        content = files.readFile(fileName, encoding);
        content = content.replace(/\t/g, "    ");
        //count space to see if need to warp
        var spaceCount = 0;
        for (var i = 0; i < 1000; i++) {
            //            console.log(content[i])
            if (content[i] === ' ' ) {
                spaceCount ++;
            }
        }
        console.log("space Count is " + spaceCount);
        if (spaceCount > 70) {
            wordWrap = true;
        } else {
            wordWrap = false;
        }
    }

    Timer {
        id: timer1
        repeat: false
        interval: 1000
        onTriggered: indexAndSet()
    }
    property var indexCache: ({});

    function indexAndSet(){
        console.log("indexAndSet" + JSON.stringify(aDocument.contents.history[fileName] + " " + page1.height + " " + page1.width + " " + fontSize))
        isReady = false;
        if (aDocument.contents.history[fileName].fontSize)
            fontSize = aDocument.contents.history[fileName].fontSize;
        console.log("font size is " + fontSize + " " + page1.font.pixelSize)
        if (indexCache[page1.height + "-" + page1.width + "-" + fontSize] !== undefined) {
            var cacheKey = page1.height + "-" + page1.width+ "-" + fontSize;
            var cacheObject = indexCache[cacheKey];
            translatedIndexList = cacheObject.indexList;
            translatedContent = cacheObject.translatedContent;
            originalIndexList = cacheObject.originalIndexList;
        } else {
            var tmp;
            if (!wordWrap)
                tmp = wrapTextUtils.indexTxt(page1.font, page1.height, page1.width, content, textLineSpace);
            else
                tmp = wrapTextUtils.indexTxtWrapped(page1.font, page1.height, page1.width, content, textLineSpace);
            translatedIndexList = tmp[0];
            translatedContent = tmp[1];
            originalIndexList = tmp[2];
            indexCache[page1.height + "-" + page1.width+ "-" + fontSize] = {
                indexList: translatedIndexList,
                translatedContent: translatedContent,
                originalIndexList: originalIndexList
            }
        }
        if (aDocument.contents.history[fileName].totalCount !== content.length) {
            currentIndexListIdx = 0;
        } else {
            currentIndexListIdx = getPageIdx(aDocument.contents.history[fileName].readTo);
        }
        //load current page
        if (currentIndexListIdx >= translatedIndexList.length || currentIndexListIdx < 0)
            currentIndexListIdx = 0;
        setThreePageText();
        resetScreenPosition();
        isReady = true;
    }

    function setThreePageText() {
        currentScreen.text = translatedContent.substring(translatedIndexList[currentIndexListIdx], translatedIndexList[currentIndexListIdx + 1]);
        nextScreen.text = translatedContent.substring(translatedIndexList[currentIndexListIdx + 1], translatedIndexList[currentIndexListIdx + 2]);
        prevScreen.text = translatedContent.substring(translatedIndexList[currentIndexListIdx - 1], translatedIndexList[currentIndexListIdx]);
    }

    onFontSizeChanged: {
        console.log("onFontSizeChanged")
        timer1.start();
        saveAll();
    }

    Flickable {
        id: textEditsItem
        width: (parent.width - mARGIN * 2) > units.gu(75) ? units.gu(75) : parent.width - mARGIN * 2
        anchors {
            top: parent.top
            bottom: progressBar.top
            margins: units.gu(3)
        }
        contentHeight: height
        contentWidth: width
        x: (parent.width - width) / 2
        clip: true

        Text{
            id: page0
            text: "Page 0"
            font.family: "Ubuntu"
            width : parent.width
            height: parent.height
            x: -width

            wrapMode: Text.NoWrap
            Behavior on x{
                UbuntuNumberAnimation { duration:  UbuntuAnimation.SlowDuration}
            }

            font.pixelSize: fontSize
            lineHeight: textLineHeight
            lineHeightMode: Text.FixedHeight
        }

        Text{
            id: page1
            font.family: "Ubuntu"
            text: "Page 1 (Swipe to turn)"
            width : parent.width
            height: parent.height
            wrapMode: Text.NoWrap
            Behavior on x{
                UbuntuNumberAnimation { duration:  UbuntuAnimation.SlowDuration}
            }
            font.pixelSize: fontSize
            lineHeight: textLineHeight
            lineHeightMode: Text.FixedHeight
        }
        Text{
            id: page2
            text: "Page 2"
            font.family: "Ubuntu"

            width : parent.width
            height: parent.height
            x: width

            wrapMode: Text.NoWrap
            Behavior on x{
                UbuntuNumberAnimation { duration:  UbuntuAnimation.SlowDuration}
            }

            font.pixelSize: fontSize
            lineHeight: textLineHeight
            lineHeightMode: Text.FixedHeight
        }
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
                width: parent.width * readToRatio
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
            maximumValue: translatedIndexList.length - 2
            live: false
            width: parent.width - mARGIN * 2
            anchors.horizontalCenter: parent.horizontalCenter
            onValueChanged: {
                readPage.currentIndexListIdx = Math.floor(value);
                saveTimer.start()
                setThreePageText();
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
            UbuntuNumberAnimation { duration:  UbuntuNumberAnimation.slowDuration}
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.bottomMargin: parent.height - progressSliderRect.y
        enabled: isReady
        property int startPosition
        property int prevPosistion
        property bool startDrag

        property var pagePositions: [0, 0, 0]
        onPressed: {
            startPosition = mouse.x;
            pagePositions[0] = page0.x;
            pagePositions[1] = page1.x;
            pagePositions[2] = page2.x;
            startDrag = false
        }
        onMouseXChanged: {
            if (!startDrag && Math.abs(startPosition - mouse.x) > units.gu(1)) {
                prevScreen.visible = true;
                nextScreen.visible = true;
                startDrag = true;
                canceled()
            } else if (startDrag){
//                textEditsItem.contentX = startPosition - mouse.x;
                page0.x = pagePositions[0] - startPosition + mouse.x;
                page1.x = pagePositions[1] - startPosition + mouse.x;
                page2.x = pagePositions[2] - startPosition + mouse.x;
            }
        }
        onReleased: {
//            console.log("onReleased")
            if (startDrag) {
//                console.log("startDrag" + currentScreen.x)
                if (startPosition - mouse.x > units.gu(10) && currentIndexListIdx != translatedIndexList.length - 2) {
                    nextPage();
                } else if (startPosition - mouse.x < - units.gu(10) && currentIndexListIdx != 0) {
                    prevPage();
                } else {
//                    console.log("reset")
                    resetScreenPosition();
                }
            }
        }

        onClicked: {
            if(!startDrag) {
                if (mouse.x < width * 0.3) {
//                    console.log("clicked left")
                    prevPage();
                } else if (mouse.x > width * 0.7) {
//                    console.log("clicked right")
                    nextPage();
                } else if (!tools.animating){
                    if (tools.opened)
                        tools.close();
                    else
                        tools.open();
                }
            }
        }

    }

    function nextPage(){
        if(currentIndexListIdx < translatedIndexList.length -2){
            var tmp = currentScreen
            currentScreen = nextScreen
            nextScreen = prevScreen
            prevScreen = tmp

            prevScreen.visible = true
            currentScreen.visible = true
            nextScreen.visible = false;
            resetScreenPosition();

            nextScreen.text = translatedContent.substring(translatedIndexList[currentIndexListIdx + 2], translatedIndexList[currentIndexListIdx + 3]);
            currentIndexListIdx ++;
            saveTimer.start();
        }
    }
    function prevPage(){
        if(currentIndexListIdx != 0){
            //load prev page
            var tmp = currentScreen
            currentScreen = prevScreen
            prevScreen = nextScreen
            nextScreen = tmp

            prevScreen.visible = false;
            currentScreen.visible = true
            nextScreen.visible = true;
            resetScreenPosition();

            prevScreen.text = translatedContent.substring(translatedIndexList[currentIndexListIdx - 2], translatedIndexList[currentIndexListIdx - 1]);
            currentIndexListIdx --;
            saveTimer.start()
        }
    }
    function getPageIdx(originalIndex){
        console.debug("getPageIdx called with " + originalIndex);
        for (var i = 0; i < originalIndexList.length; i++) {
            if (originalIndex < originalIndexList[i]) {
                console.debug("getPageIdx return " + (i - 1) + " " + originalIndexList[i - 1] + " " + originalIndexList[i]);
                return i - 1;
            }
        }
        return 0;
    }

    function setNewEncoding(newEncoding){
        encoding = newEncoding;
        readContent();
        timer1.start();
        saveTimer.start();
    }

    function saveAll(){
        var newContents = aDocument.contents
        if(newContents.history[fileName]){
            newContents.history[fileName].readTo = originalIndexList[currentIndexListIdx];
            newContents.history[fileName].encoding = encoding;
            newContents.history[fileName].totalCount = content.length;
            newContents.history[fileName].fontSize = fontSize;
            newContents.history[fileName].readToRatio = readToRatio
            aDocument.contents = newContents
        }
        console.log("save all " + JSON.stringify(aDocument.contents.history[fileName]))
    }

    Panel {
        id: tools
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: units.gu(8)

        Component.onCompleted: {
            tools.open();
            closeToolbarTimer.start();
        }
        Rectangle {
            anchors.fill: parent
            color: "white"
        }

        Timer {
            id: closeToolbarTimer
            interval: 2000
            repeat: false
            onTriggered: tools.close()
        }

        ToolbarItems{
            ToolbarButton{
                action:Action{
                    iconSource: "../img/font-increase.svg"
                    text: i18n.tr("Font +")
                    onTriggered: {
                        isReady = false;
                        fontSize += units.gu(0.25);
                    }
                }
            }

            ToolbarButton{
                action:Action{
                    iconSource: "../img/font-decrease.svg"
                    text: i18n.tr("Font -")
                    onTriggered: {
                        isReady = false;
                        fontSize -= units.gu(0.25);
                        timer1.start();
                    }
                }
            }

            ToolbarButton{
                action:Action{
                    iconSource: "../img/jump.svg"
                    text: i18n.tr("Jump to")
                    onTriggered: {
                        progressSlider.value = currentIndexListIdx
                        progressSlider.disappearTime = 4;
                        progressDisappearTimer.start();
                        progressSliderRect.y = readPage.height - progressSliderRect.height
                        tools.close()

                    }
                }
            }

            ToolbarButton{
                id: encodingButton
                action: Action{
                    iconSource: "../img/encoding.svg"
                    text: i18n.tr("Encoding")
                    onTriggered: {
                        PopupUtils.open(encodingPopover, encodingButton);
                    }
                }
            }

            back: ToolbarButton{
                action: Action{
                    text: i18n.tr("Back")
                    iconSource: "../img/back.svg"
                    onTriggered:{
                        pageStack.pop();
                    }
                }
            }
        }
    }

    EncodingPopover {
        id: encodingPopover
    }

    Rectangle {
        visible: !isReady
        anchors.fill: parent
        color: Theme.palette.normal.background
        ActivityIndicator{
            running: !isReady;
            anchors.centerIn: parent
        }
    }
    function resetScreenPosition() {
        currentScreen.x = 0
        nextScreen.x = nextScreen.width + units.gu(2);
        prevScreen.x = - prevScreen.width - units.gu(2);
    }
    Timer {
        id: saveTimer
        interval: 500
        repeat: false
        onTriggered: saveAll()
    }
}
