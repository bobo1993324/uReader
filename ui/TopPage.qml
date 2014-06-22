import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem
import Ubuntu.Components.Popups 0.1

import "../components"

Page {
    id: topPage
    title: i18n.tr("QmlTextReader")
    property var filesList: files.files
    Component.onCompleted: {
        if (filesList.length == 0) {
            PopupUtils.open(afd)
        }
    }

    AddFileDialogue {
        id: afd
    }

    Component {
        id: bookCoverCom
        BookCover{
            visible: filesList.indexOf(modelData) > -1
            height: width * 1.5
            width: coverWidth
            title: modelData.indexOf(".") >= 0 ? modelData.substring(0, modelData.indexOf(".")) : modelData
            completion: aDocument.contents.history[modelData] ? aDocument.contents.history[modelData].readToRatio : 0
            onClicked: {
                readPage.fileName = modelData;
                pageStack.push(readPage);
            }
        }
    }
    flickable: flick
    Flickable{
        id: flick
        clip: true
        width: parent.width - units.gu(4)
        height: parent.height - units.gu(4)
        anchors.centerIn: parent

        contentWidth: flow.width
        contentHeight: flow.height
        Flow{
            id: flow
            spacing: units.gu(2)
            width: flick.width
            Repeater {
                model: filesList
                delegate: bookCoverCom
            }
        }
    }
    function addToRecent(fileName) {
        var tmp = aDocument.contents;
        if (!tmp.recent) {
            tmp.recent = [fileName];
            return;
        }
        var originalIdx = tmp.recent.indexOf(fileName);
        if (originalIdx != -1) {
            tmp.recent.splice(originalIdx, 1);
        }
        tmp.recent.unshift(fileName);
        //limit the length of recent to 8
        while (tmp.recent.length > 8) {
            tmp.recent.splice(-1, 1)
        }

        aDocument.contents = tmp;
        console.log(aDocument.contents.recent);
    }
    tools: ToolbarItems{
        ToolbarButton{
            action: Action{
                text: i18n.tr("Help")
                iconSource: "../img/help.svg"
                onTriggered: pageStack.push(helpPage);
            }
        }
        ToolbarButton {
            action: Action {
                text: i18n.tr("Import")
                iconSource: "image://theme/add"
                onTriggered: PopupUtils.open(cpd)
            }
        }
    }
//    ContentImport {
//        id: contentImport
//        onRequestCompleted: console.log(contentImport.importItems[0].url)
//    }
    ContentPickerDialog {
        id: cpd
    }
}
