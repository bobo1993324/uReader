import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Content 0.1

Item {
    property list<ContentItem> importItems
    property var activeTransfer
    signal requestCompleted();
    ContentPeer {
        id: docSourceSingle
        contentType: ContentType.Pictures
        handler: ContentHandler.Source
        selectionType: ContentTransfer.Single
    }
    ContentTransferHint {
        id: transferHint
        anchors.fill: parent
        activeTransfer: root.activeTransfer
    }
    Connections {
        target: root.activeTransfer
        onStateChanged: {
            console.log(root.activeTransfer.state)
            if (root.activeTransfer.state === ContentTransfer.Charged) {
                importItems = root.activeTransfer.items;
            }
        }
    }
    function request() {
        activeTransfer = docSourceSingle.request()
    }
}
