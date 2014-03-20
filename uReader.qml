import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem
import U1db 1.0 as U1db
import UReader 0.1
import "components"
import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.bobo1993324.qmltextreader"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true
    width: units.gu(50)
    height: units.gu(75)

    property int coverHeight: units.gu(18)

    Component.onCompleted: {
        console.log("i18n" + i18n.domain + " " + i18n.language)
        i18n.bindtextdomain(i18n.domain, "./locale")
    }

    FilesModel{
        id: files
    }

    Style{
        id: stylea
    }

    Item{
        U1db.Database {
            id: aDatabase
            path: "aU1DbDatabase"
        }
        U1db.Document {
            id: aDocument
            database: aDatabase
            docId: 'uReader'
            create: true
            defaults: { "history": {},
                recent: []}
        }
    }
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
    HelpPage {
        id: helpPage
        visible: false
    }
}
