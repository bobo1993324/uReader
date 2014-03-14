import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem
import UReader 0.1
import "components"
import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
        objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
        applicationName: "com.bobo-324.uReader"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(50)
    height: units.gu(75)

    property int coverHeight: units.gu(18)

    FilesModel{
        id: files
    }

    Component.onCompleted: console.log("files are" + files.files);
    PageStack{
        id: pageStack
        Component.onCompleted: push(topPage)
    }
    TopPage{
        id: topPage
        visible: false
    }
    ReadPage{
        id: readPage
        visible: false
    }
}
